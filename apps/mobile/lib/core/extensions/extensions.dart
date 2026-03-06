import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// String extensions
extension StringExtension on String {
  /// Capitalize first letter
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalized).join(' ');
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if string is a valid phone number (Zimbabwean format)
  bool get isValidZimbabweanPhone {
    // Matches: 077XXXXXXX, 078XXXXXXX, +263XXXXXXXXX, etc.
    return RegExp(r'^(\+263|0)(77|78|71|73)\d{7}$').hasMatch(replaceAll(' ', ''));
  }

  /// Truncate with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Convert to double or null
  double? toDoubleOrNull() => double.tryParse(this);

  /// Convert to int or null
  int? toIntOrNull() => int.tryParse(this);
}

/// DateTime extensions
extension DateTimeExtension on DateTime {
  /// Format as readable date
  String get formattedDate => DateFormat('dd MMM yyyy').format(this);

  /// Format as readable time
  String get formattedTime => DateFormat('HH:mm').format(this);

  /// Format as full datetime
  String get formattedDateTime => DateFormat('dd MMM yyyy, HH:mm').format(this);

  /// Format as ISO date only
  String get isoDate => DateFormat('yyyy-MM-dd').format(this);

  /// Check if is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return isAfter(startOfWeek.subtract(const Duration(days: 1)));
  }

  /// Check if is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Get relative time string
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (isYesterday) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formattedDate;
    }
  }

  /// Start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// End of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);
}

/// Number extensions
extension NumExtension on num {
  /// Format as currency
  String formatCurrency(Currency currency) {
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  /// Format with thousand separators
  String get formatted {
    return NumberFormat('#,##0.##').format(this);
  }

  /// Format as compact (e.g., 1.2K, 3.4M)
  String get compact {
    return NumberFormat.compact().format(this);
  }

  /// Format as percentage
  String get percentage {
    return '${toStringAsFixed(1)}%';
  }
}

/// List extensions
extension ListExtension<T> on List<T> {
  /// Safely get element at index or null
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Group by a key
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Sum by a selector
  double sumBy(num Function(T) selector) {
    return fold(0.0, (sum, element) => sum + selector(element));
  }
}

/// Map extensions
extension MapExtension<K, V> on Map<K, V> {
  /// Get value or default
  V getOr(K key, V defaultValue) {
    return this[key] ?? defaultValue;
  }
}

/// Duration extensions
extension DurationExtension on Duration {
  /// Format as HH:MM:SS
  String get formatted {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = (inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Format as human readable
  String get humanReadable {
    if (inDays > 0) {
      return '${inDays}d ${inHours % 24}h';
    } else if (inHours > 0) {
      return '${inHours}h ${inMinutes % 60}m';
    } else if (inMinutes > 0) {
      return '${inMinutes}m ${inSeconds % 60}s';
    } else {
      return '${inSeconds}s';
    }
  }
}
