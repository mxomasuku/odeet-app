import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sale_model.dart';
import '../../core/constants/firestore_paths.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/controllers/auth_controller.dart';

/// Sale repository provider
final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return SaleRepository(ref);
});

/// Sales stream provider - today's sales
final todaysSalesStreamProvider = StreamProvider<List<SaleModel>>((ref) {
  final repository = ref.watch(saleRepositoryProvider);
  return repository.watchTodaysSales();
});

/// Sales stream provider - shop specific
final shopSalesProvider =
    StreamProvider.family<List<SaleModel>, String>((ref, shopId) {
  final repository = ref.watch(saleRepositoryProvider);
  return repository.watchShopSales(shopId);
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

/// Sale repository for Firestore operations
class SaleRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SaleRepository(this._ref);

  String? get _organizationId {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.organizationId;
  }

  CollectionReference<Map<String, dynamic>> get _salesCollection {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');
    return _firestore.collection(FirestorePaths.sales(orgId));
  }

  /// Watch today's sales as a stream
  Stream<List<SaleModel>> watchTodaysSales() {
    final orgId = _organizationId;
    if (orgId == null) return Stream.value([]);

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection(FirestorePaths.sales(orgId))
        .where('saleDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('saleDate', isLessThan: endOfDay.toIso8601String())
        .orderBy('saleDate', descending: true)
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
    final doc = await _salesCollection.doc(saleId).get();
    if (!doc.exists) return null;
    return SaleModel.fromJson({
      'id': doc.id,
      ..._convertTimestamps(doc.data()!),
    });
  }

  /// Generate a unique sale number
  Future<String> _generateSaleNumber() async {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final datePrefix =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    // Get count of today's sales
    final startOfDay = DateTime(now.year, now.month, now.day);
    final snapshot = await _firestore
        .collection(FirestorePaths.sales(orgId))
        .where('saleDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .count()
        .get();

    final count = (snapshot.count ?? 0) + 1;
    return 'SL-$datePrefix-${count.toString().padLeft(4, '0')}';
  }

  /// Create a new sale
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

    final saleNumber = await _generateSaleNumber();
    final docRef = _salesCollection.doc();

    final saleData = {
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
      'saleDate': DateTime.now().toIso8601String(),
      'isSynced': true,
    };

    await docRef.set(saleData);

    // Update inventory for each item
    await _updateInventoryForSale(orgId, shopId, items, docRef.id);

    return docRef.id;
  }

  /// Update inventory after a sale
  Future<void> _updateInventoryForSale(
    String orgId,
    String shopId,
    List<SaleItemModel> items,
    String saleId,
  ) async {
    final user = _ref.read(currentUserProvider).valueOrNull;
    final userId = user?.id ?? 'system';
    final userName = user?.name ?? 'System';

    for (final item in items) {
      final inventoryRef = _firestore
          .collection(FirestorePaths.inventory(orgId))
          .doc('${shopId}_${item.productId}');

      // Use a transaction to decrement stock
      await _firestore.runTransaction((transaction) async {
        final inventoryDoc = await transaction.get(inventoryRef);
        int currentQty = 0;
        int newQty = 0;

        if (inventoryDoc.exists) {
          currentQty = inventoryDoc.data()?['quantity'] as int? ?? 0;
          newQty = currentQty - item.quantity;
          transaction.update(inventoryRef, {
            'quantity': newQty,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Create inventory record with negative stock if it doesn't exist
          currentQty = 0;
          newQty = -item.quantity;
          transaction.set(inventoryRef, {
            'productId': item.productId,
            'shopId': shopId,
            'quantity': newQty,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        // Log Movement
        final movementRef =
            _firestore.collection(FirestorePaths.stockMovements(orgId)).doc();
        transaction.set(movementRef, {
          'organizationId': orgId,
          'shopId': shopId,
          'productId': item.productId,
          'quantityChange': -item.quantity,
          'type': 'sale',
          'quantityAfter': newQty,
          'referenceId': saleId,
          'notes': 'Sale',
          'timestamp': FieldValue.serverTimestamp(),
          'performedBy': userId,
          'performedByName': userName,
          'createdAt': DateTime.now().toIso8601String(),
        });
      });
    }
  }

  /// Get today's sales summary
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

    final snapshot = await _firestore
        .collection(FirestorePaths.sales(orgId))
        .where('saleDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('saleDate', isLessThan: endOfDay.toIso8601String())
        .where('status', isEqualTo: 'completed')
        .get();

    double totalSales = 0;
    int totalItems = 0;
    double totalProfit = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      totalSales += (data['totalAmount'] as num?)?.toDouble() ?? 0;

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

    return {
      'totalSales': totalSales,
      'transactionCount': snapshot.docs.length,
      'totalItems': totalItems,
      'totalProfit': totalProfit,
    };
  }
}
