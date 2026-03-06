import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/firestore_paths.dart';
import '../../presentation/controllers/auth_controller.dart';

/// Stock Audit Service Provider
final stockAuditServiceProvider = Provider<StockAuditService>((ref) {
  return StockAuditService(ref);
});

/// Stock Audit Record Model - represents a completed audit
class StockAuditRecord {
  final String id;
  final String shopId;
  final DateTime auditDate;
  final Map<String, int> systemStock; // productId -> system quantity
  final Map<String, int> actualStock; // productId -> actual counted quantity
  final Map<String, int> variance; // productId -> difference (actual - system)
  final String auditedBy;
  final DateTime createdAt;

  StockAuditRecord({
    required this.id,
    required this.shopId,
    required this.auditDate,
    required this.systemStock,
    required this.actualStock,
    required this.variance,
    required this.auditedBy,
    required this.createdAt,
  });

  factory StockAuditRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    Map<String, int> parseIntMap(dynamic raw) {
      if (raw == null) return {};
      return Map<String, int>.from(
        (raw as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toInt()),
        ),
      );
    }

    return StockAuditRecord(
      id: doc.id,
      shopId: data['shopId'] as String,
      auditDate: (data['auditDate'] as Timestamp).toDate(),
      systemStock: parseIntMap(data['systemStock'] ?? data['closingStock']),
      actualStock: parseIntMap(data['actualStock']),
      variance: parseIntMap(data['variance']),
      auditedBy: data['auditedBy'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'shopId': shopId,
      'auditDate': Timestamp.fromDate(auditDate),
      'systemStock': systemStock,
      'actualStock': actualStock,
      'variance': variance,
      'auditedBy': auditedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

/// Stock Audit Report Model - for UI display
class StockAuditReport {
  final Map<String, StockAuditItem> items;
  final DateTime? lastAuditDate;
  final DateTime currentDate;

  StockAuditReport({
    required this.items,
    this.lastAuditDate,
    required this.currentDate,
  });
}

class StockAuditItem {
  final String productId;
  final String productName;
  final int openingStock;
  final int stockIn;
  final int stockOut;
  final int closingStock;

  StockAuditItem({
    required this.productId,
    required this.productName,
    required this.openingStock,
    required this.stockIn,
    required this.stockOut,
    required this.closingStock,
  });
}

/// Product Movement Model - represents a single movement event
class ProductMovement {
  final String id;
  final String productId;
  final String
      type; // 'sale', 'transfer_in', 'transfer_out', 'adjustment', 'purchase'
  final int quantity;
  final DateTime timestamp;
  final String? referenceId; // Sale ID, Transfer ID, etc.
  final String? description;

  ProductMovement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.timestamp,
    this.referenceId,
    this.description,
  });

  factory ProductMovement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductMovement(
      id: doc.id,
      productId: data['productId'] as String,
      type: data['type'] as String? ?? 'unknown',
      quantity: (data['quantityChange'] as num?)?.toInt() ?? 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      referenceId: data['referenceId'] as String?,
      description: data['description'] as String?,
    );
  }
}

/// Service to manage stock audits
class StockAuditService {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StockAuditService(this._ref);

  String? get _organizationId {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.organizationId;
  }

  String? get _userId {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.id;
  }

  /// Get the most recent audit record for a shop
  Future<StockAuditRecord?> getLastAudit(String shopId) async {
    final orgId = _organizationId;
    if (orgId == null) return null;

    final snapshot = await _firestore
        .collection(FirestorePaths.stockAudits(orgId))
        .where('shopId', isEqualTo: shopId)
        .orderBy('auditDate', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return StockAuditRecord.fromFirestore(snapshot.docs.first);
  }

  /// Get audit history for a shop (or all shops if shopId is null)
  Future<List<StockAuditRecord>> getAuditHistory({String? shopId}) async {
    final orgId = _organizationId;
    if (orgId == null) return [];

    Query<Map<String, dynamic>> query =
        _firestore.collection(FirestorePaths.stockAudits(orgId));

    if (shopId != null) {
      query = query.where('shopId', isEqualTo: shopId);
    }

    final snapshot = await query.orderBy('auditDate', descending: true).get();

    return snapshot.docs
        .map((doc) => StockAuditRecord.fromFirestore(doc))
        .toList();
  }

  /// Get a specific audit record by ID
  Future<StockAuditRecord?> getAuditById(String auditId) async {
    final orgId = _organizationId;
    if (orgId == null) return null;

    final doc = await _firestore
        .collection(FirestorePaths.stockAudits(orgId))
        .doc(auditId)
        .get();

    if (!doc.exists) return null;
    return StockAuditRecord.fromFirestore(doc);
  }

  /// Get product names by their IDs
  Future<Map<String, String>> getProductNames(List<String> productIds) async {
    final orgId = _organizationId;
    if (orgId == null) return {};
    if (productIds.isEmpty) return {};

    final names = <String, String>{};

    // Firestore has a limit of 30 for whereIn, so batch if needed
    for (var i = 0; i < productIds.length; i += 30) {
      final batch = productIds.skip(i).take(30).toList();
      final snapshot = await _firestore
          .collection(FirestorePaths.products(orgId))
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        names[doc.id] = data['name'] as String? ?? doc.id;
      }
    }

    return names;
  }

  /// Get all movements for a specific product since a given date
  Future<List<ProductMovement>> getProductMovements({
    required String shopId,
    required String productId,
    required DateTime sinceDate,
  }) async {
    final orgId = _organizationId;
    if (orgId == null) return [];

    final snapshot = await _firestore
        .collection(FirestorePaths.stockMovements(orgId))
        .where('shopId', isEqualTo: shopId)
        .where('productId', isEqualTo: productId)
        .where('timestamp', isGreaterThan: Timestamp.fromDate(sinceDate))
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ProductMovement.fromFirestore(doc))
        .toList();
  }

  /// Generate current audit report based on last audit
  Future<StockAuditReport> getAuditReport({required String shopId}) async {
    final orgId = _organizationId;
    if (orgId == null) throw Exception('User not authenticated');

    // 1. Get last audit record
    final lastAudit = await getLastAudit(shopId);
    final startDate = lastAudit?.auditDate ??
        DateTime(2024); // Default to beginning if no audit
    final now = DateTime.now();

    // 2. Fetch current inventory
    final inventorySnapshot = await _firestore
        .collection(FirestorePaths.inventory(orgId))
        .where('shopId', isEqualTo: shopId)
        .get();

    final currentInventory = <String, int>{};
    for (final doc in inventorySnapshot.docs) {
      final data = doc.data();
      final pid = data['productId'] as String;
      final qty = (data['quantity'] as num?)?.toInt() ?? 0;
      currentInventory[pid] = qty;
    }

    // 3. Fetch movements since last audit
    final movementsSnapshot = await _firestore
        .collection(FirestorePaths.stockMovements(orgId))
        .where('shopId', isEqualTo: shopId)
        .where('timestamp', isGreaterThan: Timestamp.fromDate(startDate))
        .orderBy('timestamp', descending: false)
        .get();

    final movements = movementsSnapshot.docs.map((d) {
      final data = d.data();
      return {
        'productId': data['productId'] as String,
        'quantityChange': (data['quantityChange'] as num?)?.toInt() ?? 0,
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
      };
    }).toList();

    // 4. Fetch product names
    final productsSnapshot =
        await _firestore.collection(FirestorePaths.products(orgId)).get();

    final productNames = {
      for (final doc in productsSnapshot.docs)
        doc.id: doc.data()['name'] as String? ?? 'Unknown Product',
    };

    // 5. Calculate report items
    final reportItems = <String, StockAuditItem>{};

    // Get all unique product IDs
    final productIds = <String>{
      ...currentInventory.keys,
      ...movements.map((m) => m['productId'] as String),
      if (lastAudit != null) ...lastAudit.actualStock.keys,
    };

    for (final pid in productIds) {
      // Opening stock = last audit's actual stock (or system if no actual, or 0 if no audit)
      final openingStock =
          lastAudit?.actualStock[pid] ?? lastAudit?.systemStock[pid] ?? 0;

      // Calculate flows
      int stockIn = 0;
      int stockOut = 0;

      for (final m in movements) {
        if (m['productId'] != pid) continue;
        final change = m['quantityChange'] as int;

        if (change > 0) {
          stockIn += change;
        } else {
          stockOut += (-change);
        }
      }

      // Closing stock = current inventory
      final closingStock = currentInventory[pid] ?? 0;

      reportItems[pid] = StockAuditItem(
        productId: pid,
        productName: productNames[pid] ?? 'Unknown Product',
        openingStock: openingStock,
        stockIn: stockIn,
        stockOut: stockOut,
        closingStock: closingStock,
      );
    }

    return StockAuditReport(
      items: reportItems,
      lastAuditDate: lastAudit?.auditDate,
      currentDate: now,
    );
  }

  /// Complete and save a new audit with actual counts
  Future<void> completeAudit({
    required String shopId,
    required Map<String, int> actualCounts,
  }) async {
    final orgId = _organizationId;
    final userId = _userId;
    if (orgId == null || userId == null) {
      throw Exception('User not authenticated');
    }

    // Get current inventory as system stock
    final inventorySnapshot = await _firestore
        .collection(FirestorePaths.inventory(orgId))
        .where('shopId', isEqualTo: shopId)
        .get();

    final systemStock = <String, int>{};
    for (final doc in inventorySnapshot.docs) {
      final data = doc.data();
      final pid = data['productId'] as String;
      final qty = (data['quantity'] as num?)?.toInt() ?? 0;
      systemStock[pid] = qty;
    }

    // Calculate variance (actual - system)
    final variance = <String, int>{};
    final allProductIds = <String>{...systemStock.keys, ...actualCounts.keys};
    for (final pid in allProductIds) {
      final actual = actualCounts[pid] ?? 0;
      final system = systemStock[pid] ?? 0;
      variance[pid] = actual - system;
    }

    // Create audit record
    final auditRecord = StockAuditRecord(
      id: '', // Will be set by Firestore
      shopId: shopId,
      auditDate: DateTime.now(),
      systemStock: systemStock,
      actualStock: actualCounts,
      variance: variance,
      auditedBy: userId,
      createdAt: DateTime.now(),
    );

    // Save to Firestore
    await _firestore
        .collection(FirestorePaths.stockAudits(orgId))
        .add(auditRecord.toFirestore());
  }
}
