import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';
import '../../core/constants/firestore_paths.dart';
import '../../core/utils/stream_extensions.dart';
import '../../presentation/controllers/auth_controller.dart';

/// Inventory repository provider
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref);
});

/// Inventory for a shop
final shopInventoryProvider =
    StreamProvider.family<List<ProductInventory>, String>((ref, shopId) {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository
      .watchShopInventory(shopId)
      .onErrorEmit(() => <ProductInventory>[]);
});

/// Inventory repository for Firestore operations
class InventoryRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InventoryRepository(this._ref);

  String? get _organizationId {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.organizationId;
  }

  CollectionReference<Map<String, dynamic>> get _inventoryCollection {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');
    return _firestore.collection(FirestorePaths.inventory(orgId));
  }

  /// Watch inventory for a specific shop
  Stream<List<ProductInventory>> watchShopInventory(String shopId) {
    final orgId = _organizationId;
    if (orgId == null) return Stream.value([]);

    return _firestore
        .collection(FirestorePaths.inventory(orgId))
        .where('shopId', isEqualTo: shopId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    ProductInventory.fromJson(_convertTimestamps(doc.data())),
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

  /// Get inventory level for a product at a shop
  Future<int> getStockLevel(String shopId, String productId) async {
    final orgId = _organizationId;
    if (orgId == null) return 0;

    final doc = await _inventoryCollection.doc('${shopId}_$productId').get();
    if (!doc.exists) return 0;
    return doc.data()?['quantity'] as int? ?? 0;
  }

  /// Get total stock across all shops for a product
  Future<int> getTotalStock(String productId) async {
    final orgId = _organizationId;
    if (orgId == null) return 0;

    final snapshot = await _firestore
        .collection(FirestorePaths.inventory(orgId))
        .where('productId', isEqualTo: productId)
        .get();

    return snapshot.docs.fold<int>(
      0,
      (sum, doc) => sum + (doc.data()['quantity'] as int? ?? 0),
    );
  }

  /// Set stock level for a product at a shop
  Future<void> setStockLevel({
    required String shopId,
    required String productId,
    required int quantity,
    String? reason,
    String? notes,
  }) async {
    final orgId = _organizationId;
    final user = _ref.read(currentUserProvider).valueOrNull;
    if (orgId == null || user == null) {
      throw Exception('User not authenticated');
    }

    final inventoryRef = _inventoryCollection.doc('${shopId}_$productId');

    await _firestore.runTransaction((transaction) async {
      final currentDoc = await transaction.get(inventoryRef);
      final previousQty =
          currentDoc.exists ? (currentDoc.data()?['quantity'] as int? ?? 0) : 0;

      // Update inventory
      transaction.set(
        inventoryRef,
        {
          'productId': productId,
          'shopId': shopId,
          'quantity': quantity,
          'lastCountDate': FieldValue.serverTimestamp(),
          'lastCountBy': user.id,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // Record adjustment (Movement)
      if (previousQty != quantity) {
        final change = quantity - previousQty;
        _logMovementInTransaction(
          transaction: transaction,
          orgId: orgId,
          shopId: shopId,
          productId: productId,
          quantityChange: change,
          type: reason ?? 'manual_adjustment', // 'count', 'received', etc.
          currentStock: quantity,
          referenceId: null,
          notes: notes,
          userId: user.id,
          userName: user.name,
        );
      }
    });
  }

  /// Adjust stock level (increment/decrement)
  Future<void> adjustStock({
    required String shopId,
    required String productId,
    required int adjustment,
    required String adjustmentType, // 'sale', 'transfer', 'received', 'loss'
    String? reason,
    String? notes,
    String? referenceId,
    String? referenceType,
  }) async {
    final orgId = _organizationId;
    final user = _ref.read(currentUserProvider).valueOrNull;
    if (orgId == null || user == null) {
      throw Exception('User not authenticated');
    }

    final inventoryRef = _inventoryCollection.doc('${shopId}_$productId');

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(inventoryRef);
      final currentQty =
          doc.exists ? (doc.data()?['quantity'] as int? ?? 0) : 0;
      final newQty = currentQty + adjustment;

      if (doc.exists) {
        transaction.update(inventoryRef, {
          'quantity': newQty,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.set(inventoryRef, {
          'productId': productId,
          'shopId': shopId,
          'quantity': newQty,
          'reservedQuantity': 0,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Log Movement
      _logMovementInTransaction(
        transaction: transaction,
        orgId: orgId,
        shopId: shopId,
        productId: productId,
        quantityChange: adjustment,
        type: adjustmentType,
        currentStock: newQty,
        referenceId: referenceId,
        notes: notes ?? reason,
        userId: user.id,
        userName: user.name,
      );
    });
  }

  /// Helper to log stock movement within a transaction
  void _logMovementInTransaction({
    required Transaction transaction,
    required String orgId,
    required String shopId,
    required String productId,
    required int quantityChange,
    required String type,
    required int currentStock,
    String? referenceId,
    String? notes,
    required String userId,
    required String userName,
  }) {
    final movementRef =
        _firestore.collection(FirestorePaths.stockMovements(orgId)).doc();

    transaction.set(movementRef, {
      'organizationId': orgId,
      'shopId': shopId,
      'productId': productId,
      'quantityChange': quantityChange,
      'type':
          type, // 'sale', 'received', 'transfer_in', 'transfer_out', 'count', 'loss', 'adjustment'
      'quantityAfter': currentStock,
      'referenceId': referenceId,
      'notes': notes,
      'timestamp': FieldValue.serverTimestamp(),
      'performedBy': userId,
      'performedByName': userName,
      'createdAt': DateTime.now()
          .toIso8601String(), // For easy sorting/filtering client-side if needed
    });
  }

  /// Add opening stock for a new product
  Future<void> addOpeningStock({
    required String shopId,
    required String productId,
    required int quantity,
  }) async {
    await setStockLevel(
      shopId: shopId,
      productId: productId,
      quantity: quantity,
      reason: 'opening_stock',
      notes: 'Initial stock entry',
    );
  }
}
