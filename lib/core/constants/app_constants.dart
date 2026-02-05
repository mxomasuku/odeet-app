/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'StockTake';
  static const String appVersion = '1.0.0';

  // Trial Period
  static const int trialDurationDays = 90;

  // Sync Settings
  static const int syncIntervalMinutes = 5;
  static const int maxRetryAttempts = 3;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache Duration
  static const int cacheDurationHours = 24;

  // Timeouts
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
}

/// Supported currencies in Zimbabwe
enum Currency {
  usd('USD', 'US Dollar', '\$'),
  zwl('ZWL', 'Zimbabwe Dollar', 'ZWL\$'),
  zar('ZAR', 'South African Rand', 'R'),
  bwp('BWP', 'Botswana Pula', 'P');

  final String code;
  final String name;
  final String symbol;

  const Currency(this.code, this.name, this.symbol);
}

/// Payment methods available in Zimbabwe
enum PaymentMethod {
  cash('Cash', 'cash'),
  ecocash('EcoCash', 'ecocash'),
  onemoney('OneMoney', 'onemoney'),
  innbucks('InnBucks', 'innbucks'),
  visa('Visa', 'visa'),
  mastercard('Mastercard', 'mastercard'),
  bank('Bank Transfer', 'bank');

  final String displayName;
  final String code;

  const PaymentMethod(this.displayName, this.code);
}

/// User roles within the organization
enum UserRole {
  owner('Owner', 100),
  manager('Manager', 80),
  shopkeeper('Shopkeeper', 40),
  auditor('Auditor', 50);

  final String displayName;
  final int level;

  const UserRole(this.displayName, this.level);
}

/// Stock transfer statuses
enum TransferStatus {
  pending('Pending'),
  inTransit('In Transit'),
  delivered('Delivered'),
  confirmed('Confirmed'),
  rejected('Rejected'),
  cancelled('Cancelled');

  final String displayName;

  const TransferStatus(this.displayName);
}

/// Cash collection statuses
enum CashCollectionStatus {
  pending('Pending'),
  collected('Collected'),
  confirmed('Confirmed'),
  disputed('Disputed');

  final String displayName;

  const CashCollectionStatus(this.displayName);
}

/// Subscription tiers
enum SubscriptionTier {
  trial('Trial', 0),
  basic('Basic', 9.99),
  professional('Professional', 24.99),
  enterprise('Enterprise', 49.99);

  final String name;
  final double monthlyPrice;

  const SubscriptionTier(this.name, this.monthlyPrice);
}
