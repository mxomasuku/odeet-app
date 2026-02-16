import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transfer_model.dart';
import '../../core/constants/firestore_paths.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/stream_extensions.dart';
import '../../presentation/controllers/auth_controller.dart';

/// Transfer repository provider
final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepository(ref);
});

/// Transfers stream provider
final transfersStreamProvider = StreamProvider<List<TransferModel>>((ref) {
  final repository = ref.watch(transferRepositoryProvider);
  return repository.watchTransfers().onErrorEmit(() => <TransferModel>[]);
});

/// Pending transfers count
final pendingTransfersCountProvider = FutureProvider<int>((ref) async {
  try {
    final repository = ref.watch(transferRepositoryProvider);
    return repository.getPendingTransfersCount();
  } catch (e) {
    debugPrint('Error fetching pending transfers count: $e');
    return 0;
  }
});

/// Transfer repository for Firestore operations
class TransferRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TransferRepository(this._ref);

  String? get _organizationId {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.organizationId;
  }

  CollectionReference<Map<String, dynamic>> get _transfersCollection {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');
    return _firestore.collection(FirestorePaths.transfers(orgId));
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

  /// Watch all transfers as a stream
  Stream<List<TransferModel>> watchTransfers() {
    final orgId = _organizationId;
    if (orgId == null) return Stream.value([]);

    return _firestore
        .collection(FirestorePaths.transfers(orgId))
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TransferModel.fromJson({
                  'id': doc.id,
                  ..._convertTimestamps(doc.data()),
                }),
              )
              .toList(),
        );
  }

  /// Watch pending/incoming transfers for a shop
  Stream<List<TransferModel>> watchPendingTransfersForShop(String shopId) {
    final orgId = _organizationId;
    if (orgId == null) return Stream.value([]);

    return _firestore
        .collection(FirestorePaths.transfers(orgId))
        .where('destinationShopId', isEqualTo: shopId)
        .where('status', whereIn: ['pending', 'inTransit', 'delivered'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TransferModel.fromJson({
                  'id': doc.id,
                  ..._convertTimestamps(doc.data()),
                }),
              )
              .toList(),
        );
  }

  /// Get a single transfer by ID
  Future<TransferModel?> getTransfer(String transferId) async {
    final doc = await _transfersCollection.doc(transferId).get();
    if (!doc.exists) return null;
    return TransferModel.fromJson({
      'id': doc.id,
      ..._convertTimestamps(doc.data()!),
    });
  }

  /// Get pending transfers count
  Future<int> getPendingTransfersCount() async {
    final orgId = _organizationId;
    if (orgId == null) return 0;

    final snapshot = await _firestore
        .collection(FirestorePaths.transfers(orgId))
        .where('status', whereIn: ['pending', 'inTransit', 'delivered'])
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// Generate a unique transfer number
  Future<String> _generateTransferNumber() async {
    final now = DateTime.now();
    final datePrefix =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
    return 'TR-$datePrefix-$timestamp';
  }

  /// Create a new transfer
  Future<String> createTransfer({
    required String fromShopId,
    required String fromShopName,
    required String toShopId,
    required String toShopName,
    required List<TransferItemModel> items,
    String? notes,
  }) async {
    final orgId = _organizationId;
    final user = _ref.read(currentUserProvider).valueOrNull;
    if (orgId == null || user == null) {
      throw Exception('User not authenticated');
    }

    final transferNumber = await _generateTransferNumber();
    final docRef = _transfersCollection.doc();

    final transferData = {
      'organizationId': orgId,
      'transferNumber': transferNumber,
      'sourceShopId': fromShopId,
      'sourceShopName': fromShopName,
      'destinationShopId': toShopId,
      'destinationShopName': toShopName,
      'items': items.map((item) => item.toJson()).toList(),
      'status': TransferStatus.pending.name,
      'createdBy': user.id,
      'createdByName': user.name,
      'createdAt': FieldValue.serverTimestamp(),
      'notes': notes,
    };

    await docRef.set(transferData);

    // Reserve stock at source shop
    await _reserveStockForTransfer(orgId, fromShopId, items);

    return docRef.id;
  }

  /// Approve a transfer (only managers/owners can call this)
  Future<void> approveTransfer(String transferId) async {
    final user = _ref.read(currentUserProvider).valueOrNull;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Check if user can approve (manager or owner)
    if (!user.canApproveTransfer) {
      throw Exception('You do not have permission to approve transfers');
    }

    final transfer = await getTransfer(transferId);
    if (transfer == null) {
      throw Exception('Transfer not found');
    }

    if (transfer.isApproved) {
      throw Exception('Transfer is already approved');
    }

    if (transfer.status != TransferStatus.pending) {
      throw Exception('Only pending transfers can be approved');
    }

    await _transfersCollection.doc(transferId).update({
      'approvedBy': user.id,
      'approvedByName': user.name,
      'approvedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Reserve stock at source shop
  Future<void> _reserveStockForTransfer(
    String orgId,
    String shopId,
    List<TransferItemModel> items,
  ) async {
    for (final item in items) {
      final inventoryRef = _firestore
          .collection(FirestorePaths.inventory(orgId))
          .doc('${shopId}_${item.productId}');

      await _firestore.runTransaction((transaction) async {
        final inventoryDoc = await transaction.get(inventoryRef);

        if (inventoryDoc.exists) {
          final currentReserved =
              inventoryDoc.data()?['reservedQuantity'] as int? ?? 0;
          transaction.update(inventoryRef, {
            'reservedQuantity': currentReserved + item.quantity,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    }
  }

  /// Update transfer status
  Future<void> updateTransferStatus({
    required String transferId,
    required TransferStatus newStatus,
    String? receivedBy,
    String? receivedByName,
    List<TransferItemModel>? receivedItems,
    String? discrepancyNotes,
  }) async {
    final updateData = <String, dynamic>{
      'status': newStatus.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (newStatus == TransferStatus.inTransit) {
      updateData['dispatchedAt'] = FieldValue.serverTimestamp();
    }

    if (newStatus == TransferStatus.delivered) {
      updateData['deliveredAt'] = FieldValue.serverTimestamp();
    }

    if (newStatus == TransferStatus.confirmed) {
      updateData['confirmedAt'] = FieldValue.serverTimestamp();
      updateData['receivedBy'] = receivedBy;
      updateData['receivedByName'] = receivedByName;
      if (receivedItems != null) {
        updateData['receivedItems'] =
            receivedItems.map((item) => item.toJson()).toList();
      }
      if (discrepancyNotes != null) {
        updateData['discrepancyNotes'] = discrepancyNotes;
      }

      // Complete inventory transfer
      final transfer = await getTransfer(transferId);
      if (transfer != null) {
        await _completeInventoryTransfer(
          transfer,
          receivedItems ?? transfer.items,
        );
      }
    }

    await _transfersCollection.doc(transferId).update(updateData);
  }

  /// Complete inventory transfer (move stock from source to destination)
  Future<void> _completeInventoryTransfer(
    TransferModel transfer,
    List<TransferItemModel> receivedItems,
  ) async {
    final orgId = transfer.organizationId;

    for (final item in receivedItems) {
      // Decrease from source
      final sourceRef = _firestore
          .collection(FirestorePaths.inventory(orgId))
          .doc('${transfer.sourceShopId}_${item.productId}');

      // Increase at destination
      final destRef = _firestore
          .collection(FirestorePaths.inventory(orgId))
          .doc('${transfer.destinationShopId}_${item.productId}');

      await _firestore.runTransaction((transaction) async {
        final sourceDoc = await transaction.get(sourceRef);
        final destDoc = await transaction.get(destRef);

        // Update source
        if (sourceDoc.exists) {
          final currentQty = sourceDoc.data()?['quantity'] as int? ?? 0;
          final currentReserved =
              sourceDoc.data()?['reservedQuantity'] as int? ?? 0;
          transaction.update(sourceRef, {
            'quantity': currentQty - item.quantity,
            'reservedQuantity':
                (currentReserved - item.quantity).clamp(0, currentReserved),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        // Update destination
        if (destDoc.exists) {
          final currentQty = destDoc.data()?['quantity'] as int? ?? 0;
          transaction.update(destRef, {
            'quantity': currentQty + item.quantity,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          transaction.set(destRef, {
            'productId': item.productId,
            'shopId': transfer.destinationShopId,
            'quantity': item.quantity,
            'reservedQuantity': 0,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    }
  }
}
