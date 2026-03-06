/// Firestore collection paths
class FirestorePaths {
  FirestorePaths._();

  // Root collections
  static const String organizations = 'organizations';
  static const String users = 'users';
  static const String subscriptions = 'subscriptions';
  static const String payments = 'payments';

  // Organization sub-collections
  static String shops(String orgId) => '$organizations/$orgId/shops';
  static String products(String orgId) => '$organizations/$orgId/products';
  static String categories(String orgId) => '$organizations/$orgId/categories';
  static String sales(String orgId) => '$organizations/$orgId/sales';
  static String inventory(String orgId) => '$organizations/$orgId/inventory';
  static String transfers(String orgId) => '$organizations/$orgId/transfers';
  static String cashCollections(String orgId) =>
      '$organizations/$orgId/cash_collections';
  static String priceHistory(String orgId) =>
      '$organizations/$orgId/price_history';
  static String stockAdjustments(String orgId) =>
      '$organizations/$orgId/stock_adjustments';
  static String stockMovements(String orgId) =>
      '$organizations/$orgId/stock_movements';
  static String stockAudits(String orgId) =>
      '$organizations/$orgId/stock_audits';
  static String auditLogs(String orgId) => '$organizations/$orgId/audit_logs';

  // Shop sub-collections
  static String shopInventory(String orgId, String shopId) =>
      '$organizations/$orgId/shops/$shopId/inventory';
  static String shopSales(String orgId, String shopId) =>
      '$organizations/$orgId/shops/$shopId/sales';

  // Document paths
  static String organization(String orgId) => '$organizations/$orgId';
  static String user(String userId) => '$users/$userId';
  static String shop(String orgId, String shopId) =>
      '$organizations/$orgId/shops/$shopId';
  static String product(String orgId, String productId) =>
      '$organizations/$orgId/products/$productId';
}

/// Hive box names for local storage
class HiveBoxes {
  HiveBoxes._();

  static const String products = 'products';
  static const String sales = 'sales';
  static const String inventory = 'inventory';
  static const String transfers = 'transfers';
  static const String cashCollections = 'cash_collections';
  static const String syncQueue = 'sync_queue';
  static const String settings = 'settings';
  static const String user = 'user';
  static const String shops = 'shops';
  static const String categories = 'categories';
}
