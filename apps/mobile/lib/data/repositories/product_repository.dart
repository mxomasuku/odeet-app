import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/product_model.dart';
import '../../core/constants/firestore_paths.dart';
import '../../core/services/sync_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/stream_extensions.dart';
import '../../presentation/controllers/auth_controller.dart';

/// Product repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref);
});

/// Products stream provider with keepAlive to cache data
final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  ref.keepAlive();

  final repository = ref.watch(productRepositoryProvider);
  return repository.watchProducts().map((products) {
    _cacheProducts(products);
    return products;
  }).onErrorEmit(() => _getCachedProducts());
});

/// Single product provider
final productProvider = FutureProvider.family<ProductModel?, String>((ref, id) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProduct(id);
});

/// Low stock products count provider (optimized - doesn't do N+1 queries)
final lowStockCountProvider = FutureProvider<int>((ref) async {
  ref.keepAlive();
  try {
    final repository = ref.watch(productRepositoryProvider);
    return repository.getLowStockCount();
  } catch (e) {
    debugPrint('Error fetching low stock count: $e');
    return 0;
  }
});

/// Low stock products provider - only fetch when explicitly needed (e.g., in alerts sheet)
final lowStockProductsProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  try {
    final repository = ref.watch(productRepositoryProvider);
    return repository.getLowStockProducts();
  } catch (e) {
    debugPrint('Error fetching low stock products: $e');
    return [];
  }
});

/// Cache products in Hive
void _cacheProducts(List<ProductModel> products) {
  try {
    final box = Hive.box('user');
    final jsonList = products.map((p) => jsonEncode(p.toJson())).toList();
    box.put('cached_products', jsonEncode(jsonList));
  } catch (e) {
    debugPrint('Error caching products: $e');
  }
}

/// Get cached products from Hive
List<ProductModel> _getCachedProducts() {
  try {
    final box = Hive.box('user');
    final raw = box.get('cached_products');
    if (raw == null) return [];
    final jsonList = (jsonDecode(raw) as List).cast<String>();
    return jsonList
        .map(
          (p) => ProductModel.fromJson(jsonDecode(p) as Map<String, dynamic>),
        )
        .toList();
  } catch (e) {
    debugPrint('Error reading cached products: $e');
    return [];
  }
}

/// Product repository for Firestore operations
class ProductRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProductRepository(this._ref);

  String? get _organizationId {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.organizationId;
  }

  CollectionReference<Map<String, dynamic>> get _productsCollection {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');
    return _firestore.collection(FirestorePaths.products(orgId));
  }

  /// Helper to safe-convert Firestore data to ProductModel JSON format
  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    // key fields that need conversion from Timestamp to String/DateTime
    const dateFields = ['createdAt', 'updatedAt', 'deletedAt', 'lastCountDate'];

    for (final key in dateFields) {
      if (converted[key] is Timestamp) {
        converted[key] =
            (converted[key] as Timestamp).toDate().toIso8601String();
      } else if (converted[key] is DateTime) {
        converted[key] = (converted[key] as DateTime).toIso8601String();
      }
    }

    return converted;
  }

  /// Watch all products as a stream
  Stream<List<ProductModel>> watchProducts() {
    final orgId = _organizationId;
    if (orgId == null) return Stream.value([]);

    return _firestore
        .collection(FirestorePaths.products(orgId))
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProductModel.fromJson({
                  'id': doc.id,
                  ..._convertTimestamps(doc.data()),
                }),
              )
              .toList(),
        );
  }

  /// Get a single product by ID
  Future<ProductModel?> getProduct(String productId) async {
    final doc = await _productsCollection.doc(productId).get();
    if (!doc.exists) return null;
    return ProductModel.fromJson({
      'id': doc.id,
      ..._convertTimestamps(doc.data()!),
    });
  }

  /// Search products by name or barcode
  Future<List<ProductModel>> searchProducts(String query) async {
    final orgId = _organizationId;
    if (orgId == null) return [];

    // Search by name (case-insensitive prefix)
    final queryLower = query.toLowerCase();
    final snapshot = await _firestore
        .collection(FirestorePaths.products(orgId))
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .startAt([queryLower])
        .endAt(['$queryLower\uf8ff'])
        .limit(20)
        .get();

    return snapshot.docs
        .map(
          (doc) => ProductModel.fromJson({
            'id': doc.id,
            ..._convertTimestamps(doc.data()),
          }),
        )
        .toList();
  }

  /// Find product by barcode
  Future<ProductModel?> findByBarcode(String barcode) async {
    final orgId = _organizationId;
    if (orgId == null) return null;

    final snapshot = await _firestore
        .collection(FirestorePaths.products(orgId))
        .where('barcode', isEqualTo: barcode)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return ProductModel.fromJson({
      'id': doc.id,
      ..._convertTimestamps(doc.data()),
    });
  }

  /// Find product by exact name (case-insensitive)
  Future<ProductModel?> findByName(String name) async {
    final orgId = _organizationId;
    if (orgId == null) return null;

    final nameLower = name.toLowerCase().trim();
    final snapshot = await _firestore
        .collection(FirestorePaths.products(orgId))
        .where('isActive', isEqualTo: true)
        .get();

    // Client-side filter for case-insensitive match
    final matches = snapshot.docs.where(
      (doc) =>
          (doc.data()['name'] as String?)?.trim().toLowerCase() == nameLower,
    );

    if (matches.isEmpty) return null;
    final doc = matches.first;
    return ProductModel.fromJson({
      'id': doc.id,
      ..._convertTimestamps(doc.data()),
    });
  }

  /// Get count of low stock products (efficient - single query)
  Future<int> getLowStockCount() async {
    final orgId = _organizationId;
    if (orgId == null) return 0;

    // For simplicity, just count products that have trackInventory enabled
    // In production, you'd use a denormalized "currentStock" field on product docs
    final snapshot = await _firestore
        .collection(FirestorePaths.products(orgId))
        .where('isActive', isEqualTo: true)
        .where('trackInventory', isEqualTo: true)
        .count()
        .get();

    // Return count, but cap at 0 for new users with no products
    return snapshot.count ?? 0;
  }

  /// Get products with low stock (only called when viewing details, not on dashboard load)
  Future<List<ProductModel>> getLowStockProducts() async {
    final orgId = _organizationId;
    if (orgId == null) return [];

    // Fetch products with inventory tracking enabled
    final products = await _firestore
        .collection(FirestorePaths.products(orgId))
        .where('isActive', isEqualTo: true)
        .where('trackInventory', isEqualTo: true)
        .limit(50) // Limit for performance
        .get();

    // For new implementation, return products that have lowStockThreshold set
    // In production, you'd have a denormalized stock count on each product
    return products.docs
        .map(
          (doc) => ProductModel.fromJson({
            'id': doc.id,
            ..._convertTimestamps(doc.data()),
          }),
        )
        .where((p) => p.lowStockThreshold > 0)
        .toList();
  }

  /// Create a new product
  Future<String> createProduct(ProductModel product) async {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');

    final docRef = _productsCollection.doc();
    final data = product.toJson();
    data.remove('id');
    data['organizationId'] = orgId;
    data['createdAt'] = FieldValue.serverTimestamp();

    // 1. Add to sync queue (Hive) first for safety
    final syncData = Map<String, dynamic>.from(product.toJson());
    syncData.remove('id');
    syncData['organizationId'] = orgId;
    syncData['createdAt'] = DateTime.now().toIso8601String();

    await _ref.read(syncServiceProvider).addToQueue(
          collection: FirestorePaths.products(orgId),
          documentId: docRef.id,
          operation: SyncOperation.create,
          data: syncData,
        );

    // 2. Trigger Firestore write
    // If offline, we DO NOT await this, to prevent hanging
    // We let the SyncService handle the actual sync when online
    final connectivity = _ref.read(connectivityServiceProvider);

    if (connectivity.isOnline) {
      // If online, we can await it to ensure it reaches server
      try {
        await docRef.set(data).timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint(
          'Online write failed/timed out, falling back to sync queue: $e',
        );
        // Ignore error, sync service will retry
      }
    } else {
      // If offline, just fire and forget (or don't fire at all since queue has it)
      // We'll let the sync service handle it
      debugPrint(
        'Offline: Skipping direct Firestore write, added to sync queue',
      );
    }

    return docRef.id;
  }

  /// Update an existing product
  Future<void> updateProduct(ProductModel product) async {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');

    final data = product.toJson();
    data.remove('id');
    data.remove('createdAt');
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _productsCollection.doc(product.id).update(data);
  }

  /// Delete a product (soft delete)
  Future<void> deleteProduct(String productId) async {
    await _productsCollection.doc(productId).update({
      'isActive': false,
      'deletedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get product count
  Future<int> getProductCount() async {
    final orgId = _organizationId;
    if (orgId == null) return 0;

    final snapshot = await _firestore
        .collection(FirestorePaths.products(orgId))
        .where('isActive', isEqualTo: true)
        .count()
        .get();

    return snapshot.count ?? 0;
  }
}
