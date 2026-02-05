import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Format currency amount
String formatCurrency(double amount, Currency currency) {
  final formatter = NumberFormat.currency(
    symbol: currency.symbol,
    decimalDigits: 2,
  );
  return formatter.format(amount);
}

/// Format date
String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
  return DateFormat(pattern).format(date);
}

/// Format date time
String formatDateTime(DateTime dateTime) {
  return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
}

/// Format relative time
String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else {
    return formatDate(dateTime);
  }
}

/// Generate SKU from product name
String generateSku(String productName) {
  final words = productName.toUpperCase().split(' ');
  final prefix = words.take(2).map((w) => w.isNotEmpty ? w[0] : '').join();
  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  return '$prefix${timestamp.substring(timestamp.length - 6)}';
}

/// Validate Zimbabwean phone number
bool isValidZimbabweanPhone(String phone) {
  final cleaned = phone.replaceAll(RegExp(r'[\s\-]'), '');
  return RegExp(r'^(\+263|0)(77|78|71|73)\d{7}$').hasMatch(cleaned);
}

/// Format Zimbabwean phone number
String formatZimbabweanPhone(String phone) {
  final cleaned = phone.replaceAll(RegExp(r'[\s\-]'), '');
  if (cleaned.startsWith('0')) {
    return '+263${cleaned.substring(1)}';
  }
  return cleaned;
}

/// Calculate profit margin percentage
double calculateProfitMargin(double costPrice, double sellingPrice) {
  if (sellingPrice == 0) return 0;
  return ((sellingPrice - costPrice) / sellingPrice) * 100;
}

/// Calculate markup percentage
double calculateMarkup(double costPrice, double sellingPrice) {
  if (costPrice == 0) return 0;
  return ((sellingPrice - costPrice) / costPrice) * 100;
}

/// Get greeting based on time of day
String getTimeGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good morning';
  } else if (hour < 17) {
    return 'Good afternoon';
  } else {
    return 'Good evening';
  }
}

/// Truncate text with ellipsis
String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}

/// Format file size
String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

/// Validate barcode format
bool isValidBarcode(String barcode) {
  // EAN-13, EAN-8, UPC-A formats
  if (barcode.length == 13 || barcode.length == 8 || barcode.length == 12) {
    return RegExp(r'^\d+$').hasMatch(barcode);
  }
  return false;
}

/// Calculate check digit for EAN-13
String calculateEan13CheckDigit(String barcode) {
  if (barcode.length != 12) {
    throw ArgumentError('Barcode must be 12 digits');
  }

  int sum = 0;
  for (int i = 0; i < 12; i++) {
    final digit = int.parse(barcode[i]);
    sum += digit * (i.isEven ? 1 : 3);
  }

  final checkDigit = (10 - (sum % 10)) % 10;
  return checkDigit.toString();
}

/// Get days remaining in trial
int getTrialDaysRemaining(DateTime trialStartDate) {
  final trialEndDate = trialStartDate.add(
    const Duration(days: AppConstants.trialDurationDays),
  );
  final remaining = trialEndDate.difference(DateTime.now()).inDays;
  return remaining < 0 ? 0 : remaining;
}

/// Check if trial is expired
bool isTrialExpired(DateTime trialStartDate) {
  return getTrialDaysRemaining(trialStartDate) <= 0;
}

/// Parse currency from string
Currency parseCurrency(String code) {
  return Currency.values.firstWhere(
    (c) => c.code == code.toUpperCase(),
    orElse: () => Currency.usd,
  );
}

/// Get stock status label
String getStockStatusLabel(int quantity, int lowStockThreshold) {
  if (quantity <= 0) return 'Out of Stock';
  if (quantity <= lowStockThreshold) return 'Low Stock';
  return 'In Stock';
}

/// Get stock status color
StockStatus getStockStatus(int quantity, int lowStockThreshold) {
  if (quantity <= 0) return StockStatus.outOfStock;
  if (quantity <= lowStockThreshold) return StockStatus.lowStock;
  return StockStatus.inStock;
}

enum StockStatus { inStock, lowStock, outOfStock }
