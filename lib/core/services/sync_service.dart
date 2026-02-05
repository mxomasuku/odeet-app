import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../constants/firestore_paths.dart';
import 'connectivity_service.dart';

/// Provider for sync service
final syncServiceProvider = Provider<SyncService>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return SyncService(connectivityService);
});

/// Provider for sync status
final syncStatusProvider = StateProvider<SyncStatus>((ref) {
  return SyncStatus.idle;
});

/// Provider for pending sync count
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.getPendingSyncCount();
});

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  error,
  completed,
}

/// Sync operation types
enum SyncOperation {
  create,
  update,
  delete,
}

/// Sync queue item
class SyncQueueItem {
  final String id;
  final String collection;
  final String documentId;
  final SyncOperation operation;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;

  SyncQueueItem({
    required this.id,
    required this.collection,
    required this.documentId,
    required this.operation,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'collection': collection,
        'documentId': documentId,
        'operation': operation.name,
        'data': data,
        'createdAt': createdAt.toIso8601String(),
        'retryCount': retryCount,
      };

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) => SyncQueueItem(
        id: json['id'] as String,
        collection: json['collection'] as String,
        documentId: json['documentId'] as String,
        operation: SyncOperation.values.firstWhere(
          (e) => e.name == json['operation'],
        ),
        data: Map<String, dynamic>.from(json['data'] as Map),
        createdAt: DateTime.parse(json['createdAt'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
      );

  SyncQueueItem copyWith({int? retryCount}) => SyncQueueItem(
        id: id,
        collection: collection,
        documentId: documentId,
        operation: operation,
        data: data,
        createdAt: createdAt,
        retryCount: retryCount ?? this.retryCount,
      );
}

/// Service for handling offline-first sync
class SyncService {
  final ConnectivityService _connectivityService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  Box? _syncQueueBox;
  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncService(this._connectivityService);

  /// Initialize the sync service
  Future<void> initialize() async {
    _syncQueueBox = Hive.box(HiveBoxes.syncQueue);

    // Listen for connectivity changes
    _connectivityService.statusStream.listen((status) {
      if (status == ConnectivityStatus.online) {
        syncNow();
      }
    });

    // Set up periodic sync
    _syncTimer = Timer.periodic(
      const Duration(minutes: AppConstants.syncIntervalMinutes),
      (_) => syncNow(),
    );

    // Initial sync if online
    if (_connectivityService.isOnline) {
      syncNow();
    }
  }

  /// Add an item to the sync queue
  Future<void> addToQueue({
    required String collection,
    required String documentId,
    required SyncOperation operation,
    required Map<String, dynamic> data,
  }) async {
    final item = SyncQueueItem(
      id: _uuid.v4(),
      collection: collection,
      documentId: documentId,
      operation: operation,
      data: data,
      createdAt: DateTime.now(),
    );

    await _syncQueueBox?.put(item.id, jsonEncode(item.toJson()));

    // Try immediate sync if online
    if (_connectivityService.isOnline) {
      syncNow();
    }
  }

  /// Get count of pending sync items
  Future<int> getPendingSyncCount() async {
    return _syncQueueBox?.length ?? 0;
  }

  /// Get all pending sync items
  Future<List<SyncQueueItem>> getPendingItems() async {
    final items = <SyncQueueItem>[];
    for (final key in _syncQueueBox?.keys ?? []) {
      final jsonStr = _syncQueueBox?.get(key) as String?;
      if (jsonStr != null) {
        items.add(
          SyncQueueItem.fromJson(
            jsonDecode(jsonStr) as Map<String, dynamic>,
          ),
        );
      }
    }
    // Sort by created date
    items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  /// Sync all pending items
  Future<void> syncNow() async {
    if (_isSyncing || !_connectivityService.isOnline) return;

    _isSyncing = true;

    try {
      final items = await getPendingItems();

      for (final item in items) {
        try {
          await _syncItem(item);
          // Remove from queue on success
          await _syncQueueBox?.delete(item.id);
        } catch (e) {
          // Increment retry count
          if (item.retryCount < AppConstants.maxRetryAttempts) {
            final updated = item.copyWith(retryCount: item.retryCount + 1);
            await _syncQueueBox?.put(item.id, jsonEncode(updated.toJson()));
          } else {
            // Max retries reached, log error and remove
            // In production, you might want to move to a dead letter queue
            await _syncQueueBox?.delete(item.id);
          }
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync a single item to Firestore
  Future<void> _syncItem(SyncQueueItem item) async {
    final docRef = _firestore.collection(item.collection).doc(item.documentId);

    switch (item.operation) {
      case SyncOperation.create:
        await docRef.set({
          ...item.data,
          'syncedAt': FieldValue.serverTimestamp(),
        });
        break;
      case SyncOperation.update:
        await docRef.update({
          ...item.data,
          'syncedAt': FieldValue.serverTimestamp(),
        });
        break;
      case SyncOperation.delete:
        await docRef.delete();
        break;
    }
  }

  /// Clear all pending sync items
  Future<void> clearQueue() async {
    await _syncQueueBox?.clear();
  }

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
  }
}
