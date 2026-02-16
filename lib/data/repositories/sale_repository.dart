import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/sale_model.dart';
import '../../core/constants/firestore_paths.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/sync_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/stream_extensions.dart';
import '../../presentation/controllers/auth_controller.dart';

/// Sale repository provider
final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return SaleRepository(ref);
});

/// Sales stream provider - today's sales (includes local unsynced)
final todaysSalesStreamProvider = StreamProvider<List<SaleModel>>((ref) {
  final repository = ref.watch(saleRepositoryProvider);
  return repository.watchTodaysSales().onErrorEmit(() => <SaleModel>[]);
});

/// Sales stream provider - shop specific
final shopSalesProvider =
    StreamProvider.family<List<SaleModel>, String>((ref, shopId) {
  final repository = ref.watch(saleRepositoryProvider);
  return repository.watchShopSales(shopId).onErrorEmit(() => <SaleModel>[]);
});

/// Recent sales provider
final recentSalesProvider = FutureProvider<List<SaleModel>>((ref) async {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return [];

  final repository = ref.watch(saleRepositoryProvider);
  return repository.getRecentSales(limit: 10);
});

/// Sales for date range
final salesForDateRangeProvider =
    FutureProvider.family<List<SaleModel>, ({DateTime start, DateTime end})>(
        (ref, range) async {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return [];

  final repository = ref.watch(saleRepositoryProvider);
  return repository.getSalesForDateRange(range.start, range.end);
});

/// Today's sales summary
final todaysSalesSummaryProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) {
    return {
      'totalSales': 0.0,
      'transactionCount': 0,
      'totalItems': 0,
      'totalProfit': 0.0,
    };
  }

  final repository = ref.watch(saleRepositoryProvider);
  return repository.getTodaysSummary();
});

/// Single sale provider
final saleProvider =
    FutureProvider.family<SaleModel?, String>((ref, saleId) async {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return null;

  final repository = ref.watch(saleRepositoryProvider);
  return repository.getSale(saleId);
});

/// Sale repository for Firestore operations with offline-first support
class SaleRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  SaleRepository(this._ref);

  String? get _organizationId {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.organizationId;
  }

  Box get _localSalesBox => Hive.box(HiveBoxes.sales);
  Box get _localInventoryBox => Hive.box(HiveBoxes.inventory);

  SyncService get _syncService => _ref.read(syncServiceProvider);
  ConnectivityService get _connectivityService =>
      _ref.read(connectivityServiceProvider);

  CollectionReference<Map<String, dynamic>> get _salesCollection {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');
    return _firestore.collection(FirestorePaths.sales(orgId));
  }

  /// Watch today's sales as a stream (merging local and remote)
  Stream<List<SaleModel>> watchTodaysSales() {
    final orgId = _organizationId;
    if (orgId == null) return Stream.value([]);

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // If offline, return local sales only
    if (!_connectivityService.isOnline) {
      return Stream.value(_getLocalSalesForToday());
    }

    return _firestore
        .collection(FirestorePaths.sales(orgId))
        .where('saleDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('saleDate', isLessThan: endOfDay.toIso8601String())
        .orderBy('saleDate', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        final remoteSales = snapshot.docs
            .map(
              (doc) => SaleModel.fromJson({
                'id': doc.id,
                ..._convertTimestamps(doc.data()),
              }),
            )
            .toList();

        // Merge with unsynced local sales
        return _mergeLocalAndRemoteSales(remoteSales);
      },
    );
  }

  /// Get local sales for today (unsynced)
  List<SaleModel> _getLocalSalesForToday() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final sales = <SaleModel>[];
    for (final key in _localSalesBox.keys) {
      final jsonStr = _localSalesBox.get(key) as String?;
      if (jsonStr != null) {
        try {
          final sale =
              SaleModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
          // Check if sale is from today
          if (sale.saleDate.isAfter(startOfDay)) {
            sales.add(sale);
          }
        } catch (e) {
          debugPrint('Error parsing local sale: $e');
        }
      }
    }
    sales.sort((a, b) => b.saleDate.compareTo(a.saleDate));
    return sales;
  }

  /// Merge local unsynced sales with remote sales
  List<SaleModel> _mergeLocalAndRemoteSales(List<SaleModel> remoteSales) {
    final remoteIds = remoteSales.map((s) => s.id).toSet();
    final localSales = <SaleModel>[];

    for (final key in _localSalesBox.keys) {
      final jsonStr = _localSalesBox.get(key) as String?;
      if (jsonStr != null) {
        try {
          final sale =
              SaleModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
          // Only include if not already synced
          if (!remoteIds.contains(sale.id) && sale.isSynced == false) {
            localSales.add(sale);
          } else {
            // Remove from local if already synced
            _localSalesBox.delete(key);
          }
        } catch (e) {
          debugPrint('Error parsing local sale during merge: $e');
        }
      }
    }

    // Combine and sort
    final combined = [...localSales, ...remoteSales];
    combined.sort((a, b) => b.saleDate.compareTo(a.saleDate));
    return combined;
  }

  /// Watch sales for a specific shop
  Stream<List<SaleModel>> watchShopSales(String shopId) {
    final orgId = _organizationId;
    if (orgId == null) return Stream.value([]);

    return _firestore
        .collection(FirestorePaths.sales(orgId))
        .where('shopId', isEqualTo: shopId)
        .orderBy('saleDate', descending: true)
        .limit(20) // Limit to recent 20 sales for performance
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SaleModel.fromJson({
                  'id': doc.id,
                  ..._convertTimestamps(doc.data()),
                }),
              )
              .toList(),
        );
  }

  /// Helper to convert Firestore Timestamps to DateTime ISO strings
  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    for (final entry in data.entries) {
      if (entry.value is Timestamp) {
        result[entry.key] =
            (entry.value as Timestamp).toDate().toIso8601String();
      } else if (entry.value is Map<String, dynamic>) {
        result[entry.key] =
            _convertTimestamps(entry.value as Map<String, dynamic>);
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// Get recent sales
  Future<List<SaleModel>> getRecentSales({int limit = 10}) async {
    final orgId = _organizationId;
    if (orgId == null) return [];

    // If offline, return local sales
    if (!_connectivityService.isOnline) {
      return _getLocalSalesForToday().take(limit).toList();
    }

    final snapshot = await _firestore
        .collection(FirestorePaths.sales(orgId))
        .orderBy('saleDate', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map(
          (doc) => SaleModel.fromJson({
            'id': doc.id,
            ..._convertTimestamps(doc.data()),
          }),
        )
        .toList();
  }

  /// Get sales for a date range
  Future<List<SaleModel>> getSalesForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final orgId = _organizationId;
    if (orgId == null) return [];

    final snapshot = await _firestore
        .collection(FirestorePaths.sales(orgId))
        .where('saleDate', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('saleDate', isLessThan: end.toIso8601String())
        .orderBy('saleDate', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => SaleModel.fromJson({
            'id': doc.id,
            ..._convertTimestamps(doc.data()),
          }),
        )
        .toList();
  }

  /// Get a single sale by ID
  Future<SaleModel?> getSale(String saleId) async {
    // First check local storage
    final localJson = _localSalesBox.get(saleId) as String?;
    if (localJson != null) {
      return SaleModel.fromJson(jsonDecode(localJson) as Map<String, dynamic>);
    }

    // Then check Firestore
    final doc = await _salesCollection.doc(saleId).get();
    if (!doc.exists) return null;
    return SaleModel.fromJson({
      'id': doc.id,
      ..._convertTimestamps(doc.data()!),
    });
  }

  /// Generate a unique sale number
  String _generateLocalSaleNumber() {
    final now = DateTime.now();
    final datePrefix =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
    return 'SL-$datePrefix-$timestamp';
  }

  /// Create a new sale - OFFLINE-FIRST
  /// Returns immediately with local ID, queues for sync
  Future<String> createSale({
    required String shopId,
    required String shopName,
    required List<SaleItemModel> items,
    required double subtotal,
    required double totalAmount,
    required double amountPaid,
    required PaymentMethod paymentMethod,
    double discountAmount = 0,
    double discountPercent = 0,
    double taxAmount = 0,
    double changeGiven = 0,
    String? paymentReference,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? notes,
  }) async {
    final orgId = _organizationId;
    final user = _ref.read(currentUserProvider).valueOrNull;
    if (orgId == null || user == null) {
      throw Exception('User not authenticated');
    }

    // Generate local ID and sale number immediately
    final localId = _uuid.v4();
    final saleNumber = _generateLocalSaleNumber();
    final saleDate = DateTime.now().toIso8601String();

    final saleData = {
      'id': localId,
      'organizationId': orgId,
      'shopId': shopId,
      'shopName': shopName,
      'saleNumber': saleNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'discountPercent': discountPercent,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'changeGiven': changeGiven,
      'paymentMethod': paymentMethod.code,
      'currency': 'USD',
      'paymentReference': paymentReference,
      'status': 'completed',
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
      'soldBy': user.id,
      'soldByName': user.name,
      'saleDate': saleDate,
      'isSynced': false,
    };

    // 1. Store locally for immediate access
    await _localSalesBox.put(localId, jsonEncode(saleData));
    debugPrint('SaleRepository: Stored sale locally: $localId');

    // 2. Update local inventory
    await _updateLocalInventory(shopId, items);

    // 3. Queue for sync to Firestore
    await _syncService.addToQueue(
      collection: FirestorePaths.sales(orgId),
      documentId: localId,
      operation: SyncOperation.create,
      data: saleData,
      displayName: 'Sale $saleNumber',
      localId: localId,
    );

    // 4. Queue inventory updates for sync
    for (final item in items) {
      await _queueInventoryUpdate(
          orgId, shopId, item, localId, user.id, user.name);
    }

    return localId;
  }

  /// Update local inventory after sale
  Future<void> _updateLocalInventory(
      String shopId, List<SaleItemModel> items) async {
    for (final item in items) {
      final key = '${shopId}_${item.productId}';
      final existing = _localInventoryBox.get(key);

      int currentQty = 0;
      if (existing != null) {
        try {
          final data = jsonDecode(existing as String) as Map<String, dynamic>;
          currentQty = data['quantity'] as int? ?? 0;
        } catch (e) {
          debugPrint('Error parsing local inventory: $e');
        }
      }

      final newQty = currentQty - item.quantity;
      await _localInventoryBox.put(
          key,
          jsonEncode({
            'productId': item.productId,
            'shopId': shopId,
            'quantity': newQty,
            'updatedAt': DateTime.now().toIso8601String(),
          }));
    }
  }

  /// Queue inventory update for sync
  Future<void> _queueInventoryUpdate(
    String orgId,
    String shopId,
    SaleItemModel item,
    String saleId,
    String userId,
    String userName,
  ) async {
    // Queue the stock movement
    await _syncService.addToQueue(
      collection: FirestorePaths.stockMovements(orgId),
      documentId: _uuid.v4(),
      operation: SyncOperation.create,
      data: {
        'organizationId': orgId,
        'shopId': shopId,
        'productId': item.productId,
        'quantityChange': -item.quantity,
        'type': 'sale',
        'referenceId': saleId,
        'notes': 'Sale',
        'performedBy': userId,
        'performedByName': userName,
        'createdAt': DateTime.now().toIso8601String(),
      },
      displayName: 'Stock update: ${item.productName}',
    );
  }

  /// Get today's sales summary (includes local unsynced)
  Future<Map<String, dynamic>> getTodaysSummary() async {
    final orgId = _organizationId;
    if (orgId == null) {
      return {
        'totalSales': 0.0,
        'transactionCount': 0,
        'totalItems': 0,
        'totalProfit': 0.0,
      };
    }

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    double totalSales = 0;
    int transactionCount = 0;
    int totalItems = 0;
    double totalProfit = 0;

    // Add local sales
    final localSales = _getLocalSalesForToday();
    for (final sale in localSales) {
      totalSales += sale.totalAmount;
      transactionCount++;
      for (final item in sale.items) {
        totalItems += item.quantity;
        totalProfit += (item.unitPrice - item.costPrice) * item.quantity;
      }
    }

    // Add remote sales if online
    if (_connectivityService.isOnline) {
      try {
        final snapshot = await _firestore
            .collection(FirestorePaths.sales(orgId))
            .where('saleDate',
                isGreaterThanOrEqualTo: startOfDay.toIso8601String())
            .where('saleDate', isLessThan: endOfDay.toIso8601String())
            .where('status', isEqualTo: 'completed')
            .get();

        final localIds = localSales.map((s) => s.id).toSet();

        for (final doc in snapshot.docs) {
          // Skip if already counted from local
          if (localIds.contains(doc.id)) continue;

          final data = doc.data();
          totalSales += (data['totalAmount'] as num?)?.toDouble() ?? 0;
          transactionCount++;

          final items = data['items'] as List<dynamic>?;
          if (items != null) {
            for (final item in items) {
              final qty = (item['quantity'] as num?)?.toInt() ?? 0;
              final unitPrice = (item['unitPrice'] as num?)?.toDouble() ?? 0;
              final costPrice = (item['costPrice'] as num?)?.toDouble() ?? 0;
              totalItems += qty;
              totalProfit += (unitPrice - costPrice) * qty;
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching remote sales summary: $e');
      }
    }

    return {
      'totalSales': totalSales,
      'transactionCount': transactionCount,
      'totalItems': totalItems,
      'totalProfit': totalProfit,
    };
  }
}
