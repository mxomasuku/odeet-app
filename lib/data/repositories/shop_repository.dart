import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shop_model.dart';
import '../../core/constants/firestore_paths.dart';
import '../../presentation/controllers/auth_controller.dart';

/// Shop repository provider
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository(ref);
});

/// Shops stream provider
final shopsStreamProvider = StreamProvider<List<ShopModel>>((ref) {
  // Watch user provider to trigger rebuild when user logs in/updates
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.valueOrNull;

  if (user?.organizationId == null) return Stream.value([]);

  final repository = ref.watch(shopRepositoryProvider);

  // If user is owner, manager, or auditor, show all shops
  if (user!.isOwner || user.isManager || user.canViewLedger) {
    return repository.watchShops(orgId: user.organizationId);
  }

  // Otherwise (shopkeeper), show only assigned shops
  // Note: Since watchShopsForUser isn't implemented as a stream yet, we'll implement a new stream method in repo
  // Or reuse watchShops with a query filter if possible, but Firestore 'IN' queries are limited.
  // Better to look for 'assignedUserIds' array-contains.
  return repository.watchShopsForUser(user.id, orgId: user.organizationId);
});

/// Shop stream provider by ID
final shopProvider = StreamProvider.family<ShopModel?, String>((ref, id) {
  final repository = ref.watch(shopRepositoryProvider);
  return repository.watchShop(id);
});

/// Current shop provider (selected shop for operations)
final currentShopProvider = StateProvider<ShopModel?>((ref) => null);

/// Helper to convert Firestore Timestamps to DateTime ISO strings
Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
  final result = <String, dynamic>{};
  for (final entry in data.entries) {
    if (entry.value is Timestamp) {
      result[entry.key] = (entry.value as Timestamp).toDate().toIso8601String();
    } else if (entry.value is Map<String, dynamic>) {
      result[entry.key] =
          _convertTimestamps(entry.value as Map<String, dynamic>);
    } else {
      result[entry.key] = entry.value;
    }
  }
  return result;
}

/// Shop repository for Firestore operations
class ShopRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ShopRepository(this._ref);

  String? get _organizationId {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.organizationId;
  }

  CollectionReference<Map<String, dynamic>> get _shopsCollection {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');
    return _firestore.collection(FirestorePaths.shops(orgId));
  }

  /// Watch all shops as a stream
  Stream<List<ShopModel>> watchShops({String? orgId}) {
    final targetOrgId = orgId ?? _organizationId;
    if (targetOrgId == null) return Stream.value([]);

    return _firestore
        .collection(FirestorePaths.shops(targetOrgId))
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) {
                  try {
                    final data = _convertTimestamps(doc.data());
                    return ShopModel.fromJson({
                      'id': doc.id,
                      ...data,
                    });
                  } catch (e) {
                    debugPrint('Error parsing ShopModel: $e');
                    return null;
                  }
                },
              )
              .whereType<ShopModel>()
              .toList(),
        );
  }

  /// Watch shops assigned to a specific user
  Stream<List<ShopModel>> watchShopsForUser(String userId, {String? orgId}) {
    final targetOrgId = orgId ?? _organizationId;
    if (targetOrgId == null) return Stream.value([]);

    return _firestore
        .collection(FirestorePaths.shops(targetOrgId))
        .where('isActive', isEqualTo: true)
        .where('assignedUserIds', arrayContains: userId)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) {
                  try {
                    final data = _convertTimestamps(doc.data());
                    return ShopModel.fromJson({
                      'id': doc.id,
                      ...data,
                    });
                  } catch (e) {
                    debugPrint('Error parsing ShopModel: $e');
                    return null;
                  }
                },
              )
              .whereType<ShopModel>()
              .toList(),
        );
  }

  /// Watch a single shop
  Stream<ShopModel?> watchShop(String shopId) {
    if (_organizationId == null) return Stream.value(null);
    return _shopsCollection.doc(shopId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = _convertTimestamps(doc.data()!);
      return ShopModel.fromJson({
        'id': doc.id,
        ...data,
      });
    });
  }

  /// Get all shops
  Future<List<ShopModel>> getShops() async {
    final orgId = _organizationId;
    if (orgId == null) return [];

    final snapshot = await _firestore
        .collection(FirestorePaths.shops(orgId))
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .get();

    return snapshot.docs
        .map(
          (doc) => ShopModel.fromJson({
            'id': doc.id,
            ..._convertTimestamps(doc.data()),
          }),
        )
        .toList();
  }

  /// Get a single shop by ID
  Future<ShopModel?> getShop(String shopId) async {
    final doc = await _shopsCollection.doc(shopId).get();
    if (!doc.exists) return null;
    return ShopModel.fromJson({
      'id': doc.id,
      ..._convertTimestamps(doc.data()!),
    });
  }

  /// Get the head office shop
  Future<ShopModel?> getHeadOffice() async {
    final orgId = _organizationId;
    if (orgId == null) return null;

    final snapshot = await _firestore
        .collection(FirestorePaths.shops(orgId))
        .where('isHeadOffice', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return ShopModel.fromJson({
      'id': doc.id,
      ..._convertTimestamps(doc.data()),
    });
  }

  /// Get shops assigned to a user
  Future<List<ShopModel>> getShopsForUser(String userId) async {
    final orgId = _organizationId;
    if (orgId == null) return [];

    final snapshot = await _firestore
        .collection(FirestorePaths.shops(orgId))
        .where('assignedUserIds', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => ShopModel.fromJson({
            'id': doc.id,
            ..._convertTimestamps(doc.data()),
          }),
        )
        .toList();
  }

  /// Create a new shop
  Future<String> createShop({
    required String name,
    String? code,
    String? address,
    String? city,
    String? phone,
    bool isHeadOffice = false,
  }) async {
    final orgId = _organizationId;
    final user = _ref.read(currentUserProvider).valueOrNull;
    if (orgId == null || user == null) {
      throw Exception('User not authenticated');
    }

    final docRef = _shopsCollection.doc();
    await docRef.set({
      'organizationId': orgId,
      'name': name.trim(),
      'code': code?.trim(),
      'address': address?.trim(),
      'city': city?.trim(),
      'phone': phone?.trim(),
      'isActive': true,
      'isHeadOffice': isHeadOffice,
      'managerId': user.id,
      'managerName': user.name,
      'assignedUserIds': [user.id],
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  /// Get shop count for the organization
  Future<int> getShopCount() async {
    final orgId = _organizationId;
    if (orgId == null) return 0;

    final snapshot = await _firestore
        .collection(FirestorePaths.shops(orgId))
        .where('isActive', isEqualTo: true)
        .count()
        .get();

    return snapshot.count ?? 0;
  }
}
