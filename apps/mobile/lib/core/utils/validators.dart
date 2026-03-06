/// Form validation utilities
class Validators {
  Validators._();

  /// Validate required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validate email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validate password match
  static String? passwordMatch(String? value, String? original) {
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate phone number (Zimbabwean)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^(\+263|0)(77|78|71|73)\d{7}$').hasMatch(cleaned)) {
      return 'Please enter a valid Zimbabwean phone number';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.length < length) {
      return '${fieldName ?? 'This field'} must be at least $length characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int length, {String? fieldName}) {
    if (value != null && value.length > length) {
      return '${fieldName ?? 'This field'} must be at most $length characters';
    }
    return null;
  }

  /// Validate number
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  /// Validate positive number
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numError = number(value, fieldName: fieldName);
    if (numError != null) return numError;

    final num = double.parse(value!);
    if (num <= 0) {
      return '${fieldName ?? 'Value'} must be greater than 0';
    }
    return null;
  }

  /// Validate non-negative number
  static String? nonNegativeNumber(String? value, {String? fieldName}) {
    final numError = number(value, fieldName: fieldName);
    if (numError != null) return numError;

    final num = double.parse(value!);
    if (num < 0) {
      return '${fieldName ?? 'Value'} cannot be negative';
    }
    return null;
  }

  /// Validate integer
  static String? integer(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a whole number';
    }
    return null;
  }

  /// Validate barcode
  static String? barcode(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Barcode is optional
    }
    if (!RegExp(r'^\d{8}$|^\d{12}$|^\d{13}$').hasMatch(value)) {
      return 'Please enter a valid barcode (8, 12, or 13 digits)';
    }
    return null;
  }

  /// Validate price
  static String? price(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'Price is required' : null;
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }
    if (price < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }

  /// Validate quantity
  static String? quantity(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'Quantity is required' : null;
    }
    final qty = int.tryParse(value);
    if (qty == null) {
      return 'Please enter a whole number';
    }
    if (qty < 0) {
      return 'Quantity cannot be negative';
    }
    return null;
  }

  /// Validate URL
  static String? url(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'URL is required' : null;
    }
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    if (!urlPattern.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
