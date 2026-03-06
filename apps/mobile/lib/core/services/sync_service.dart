import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
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

/// Provider for sync status stream
final syncStatusStreamProvider = StreamProvider<SyncStatus>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.syncStatusStream;
});

/// Provider for pending sync count stream (real-time updates)
final pendingSyncCountStreamProvider = StreamProvider<int>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.pendingCountStream;
});

/// Provider for pending sync count (one-time fetch)
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.getPendingSyncCount();
});

/// Provider for pending sync items list
final pendingSyncItemsProvider =
    FutureProvider<List<SyncQueueItem>>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.getPendingItems();
});

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  error,
  completed,
  offline,
}

/// Sync operation types
enum SyncOperation {
  create,
  update,
  delete,
}

/// Sync operation category - determines if operation can work offline
enum SyncCategory {
  /// Shop operations: sales, transfers, stock - can work offline
  shopOperation,

  /// Settings operations: user management, org settings - require network
  settings,
}

/// Sync queue item with enhanced metadata
class SyncQueueItem {
  final String id;
  final String collection;
  final String documentId;
  final SyncOperation operation;
  final SyncCategory category;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;
  final String displayName;
  final String? localId;

  SyncQueueItem({
    required this.id,
    required this.collection,
    required this.documentId,
    required this.operation,
    required this.data,
    required this.createdAt,
    this.category = SyncCategory.shopOperation,
    this.retryCount = 0,
    this.displayName = 'Pending operation',
    this.localId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'collection': collection,
        'documentId': documentId,
        'operation': operation.name,
        'category': category.name,
        'data': data,
        'createdAt': createdAt.toIso8601String(),
        'retryCount': retryCount,
        'displayName': displayName,
        'localId': localId,
      };

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) => SyncQueueItem(
        id: json['id'] as String,
        collection: json['collection'] as String,
        documentId: json['documentId'] as String,
        operation: SyncOperation.values.firstWhere(
          (e) => e.name == json['operation'],
        ),
        category: SyncCategory.values.firstWhere(
          (e) => e.name == (json['category'] as String? ?? 'shopOperation'),
          orElse: () => SyncCategory.shopOperation,
        ),
        data: Map<String, dynamic>.from(json['data'] as Map),
        createdAt: DateTime.parse(json['createdAt'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
        displayName: json['displayName'] as String? ?? 'Pending operation',
        localId: json['localId'] as String?,
      );

  SyncQueueItem copyWith({int? retryCount}) => SyncQueueItem(
        id: id,
        collection: collection,
        documentId: documentId,
        operation: operation,
        category: category,
        data: data,
        createdAt: createdAt,
        retryCount: retryCount ?? this.retryCount,
        displayName: displayName,
        localId: localId,
      );

  /// Human-readable operation type
  String get operationTypeDisplay {
    switch (operation) {
      case SyncOperation.create:
        return 'Create';
      case SyncOperation.update:
        return 'Update';
      case SyncOperation.delete:
        return 'Delete';
    }
  }

  /// Formatted time ago string
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

/// Service for handling offline-first sync
class SyncService {
  final ConnectivityService _connectivityService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  Box? _syncQueueBox;
  Timer? _syncTimer;
  bool _isSyncing = false;

  // Stream controllers for reactive updates
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  final _pendingCountController = StreamController<int>.broadcast();

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;
  Stream<int> get pendingCountStream => _pendingCountController.stream;

  SyncStatus _currentStatus = SyncStatus.idle;
  SyncStatus get currentStatus => _currentStatus;

  SyncService(this._connectivityService);

  /// Initialize the sync service
  Future<void> initialize() async {
    _syncQueueBox = Hive.box(HiveBoxes.syncQueue);

    // Emit initial count
    _emitPendingCount();

    // Listen for connectivity changes
    _connectivityService.statusStream.listen((status) {
      if (status == ConnectivityStatus.online) {
        _updateStatus(SyncStatus.idle);
        syncNow();
      } else {
        _updateStatus(SyncStatus.offline);
      }
    });

    // Set initial status based on connectivity
    if (!_connectivityService.isOnline) {
      _updateStatus(SyncStatus.offline);
    }

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

  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    _syncStatusController.add(status);
  }

  void _emitPendingCount() {
    final count = _syncQueueBox?.length ?? 0;
    _pendingCountController.add(count);
  }

  /// Add an item to the sync queue
  Future<String> addToQueue({
    required String collection,
    required String documentId,
    required SyncOperation operation,
    required Map<String, dynamic> data,
    SyncCategory category = SyncCategory.shopOperation,
    String displayName = 'Pending operation',
    String? localId,
  }) async {
    final item = SyncQueueItem(
      id: _uuid.v4(),
      collection: collection,
      documentId: documentId,
      operation: operation,
      data: data,
      createdAt: DateTime.now(),
      category: category,
      displayName: displayName,
      localId: localId,
    );

    await _syncQueueBox?.put(item.id, jsonEncode(item.toJson()));
    _emitPendingCount();

    debugPrint('SyncService: Added to queue - $displayName (${item.id})');

    // Try immediate sync if online
    if (_connectivityService.isOnline) {
      syncNow();
    }

    return item.id;
  }

  /// Get count of pending sync items
  Future<int> getPendingSyncCount() async {
    return _syncQueueBox?.length ?? 0;
  }

  /// Get pending items by category
  Future<List<SyncQueueItem>> getPendingItemsByCategory(
    SyncCategory category,
  ) async {
    final allItems = await getPendingItems();
    return allItems.where((item) => item.category == category).toList();
  }

  /// Get all pending sync items
  Future<List<SyncQueueItem>> getPendingItems() async {
    final items = <SyncQueueItem>[];
    for (final key in _syncQueueBox?.keys ?? []) {
      final jsonStr = _syncQueueBox?.get(key) as String?;
      if (jsonStr != null) {
        try {
          items.add(
            SyncQueueItem.fromJson(
              jsonDecode(jsonStr) as Map<String, dynamic>,
            ),
          );
        } catch (e) {
          debugPrint('SyncService: Error parsing queue item: $e');
        }
      }
    }
    // Sort by created date
    items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  /// Remove a specific item from the queue
  Future<void> removeFromQueue(String itemId) async {
    await _syncQueueBox?.delete(itemId);
    _emitPendingCount();
  }

  /// Sync all pending items
  Future<void> syncNow() async {
    if (_isSyncing || !_connectivityService.isOnline) return;

    final pendingCount = await getPendingSyncCount();
    if (pendingCount == 0) return;

    _isSyncing = true;
    _updateStatus(SyncStatus.syncing);

    try {
      final items = await getPendingItems();
      for (final item in items) {
        try {
          await _syncItem(item);
          // Remove from queue on success
          await _syncQueueBox?.delete(item.id);
          _emitPendingCount();
          debugPrint('SyncService: Synced ${item.displayName}');
        } catch (e) {
          debugPrint('SyncService: Error syncing ${item.displayName}: $e');
          // Increment retry count
          if (item.retryCount < AppConstants.maxRetryAttempts) {
            final updated = item.copyWith(retryCount: item.retryCount + 1);
            await _syncQueueBox?.put(item.id, jsonEncode(updated.toJson()));
          } else {
            // Max retries reached, move to failed state but keep for review
            debugPrint(
              'SyncService: Max retries reached for ${item.displayName}',
            );
          }
        }
      }

      final remaining = await getPendingSyncCount();
      if (remaining == 0) {
        _updateStatus(SyncStatus.completed);
        // Reset to idle after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (_currentStatus == SyncStatus.completed) {
            _updateStatus(SyncStatus.idle);
          }
        });
      } else {
        _updateStatus(SyncStatus.error);
      }
    } catch (e) {
      debugPrint('SyncService: Sync error: $e');
      _updateStatus(SyncStatus.error);
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
          'isSynced': true,
        });
        break;
      case SyncOperation.update:
        await docRef.update({
          ...item.data,
          'syncedAt': FieldValue.serverTimestamp(),
          'isSynced': true,
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
    _emitPendingCount();
  }

  /// Check if there are pending items
  bool get hasPendingItems => (_syncQueueBox?.length ?? 0) > 0;

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _syncStatusController.close();
    _pendingCountController.close();
  }
}
