/// Base exception for the app
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// No internet connection
class NoInternetException extends NetworkException {
  const NoInternetException()
      : super(
          message: 'No internet connection. Please check your network.',
          code: 'NO_INTERNET',
        );
}

/// Server error
class ServerException extends NetworkException {
  const ServerException({
    super.message = 'Server error occurred. Please try again later.',
    String? code,
    super.originalError,
  }) : super(
          code: code ?? 'SERVER_ERROR',
        );
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
      : super(
          message: 'Invalid email or password.',
          code: 'INVALID_CREDENTIALS',
        );
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException()
      : super(
          message: 'User not found.',
          code: 'USER_NOT_FOUND',
        );
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException()
      : super(
          message: 'This email is already registered.',
          code: 'EMAIL_IN_USE',
        );
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException()
      : super(
          message: 'Password is too weak. Use at least 8 characters.',
          code: 'WEAK_PASSWORD',
        );
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException()
      : super(
          message: 'Your session has expired. Please log in again.',
          code: 'SESSION_EXPIRED',
        );
}

/// Database exceptions
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class RecordNotFoundException extends DatabaseException {
  const RecordNotFoundException({String? entity})
      : super(
          message: '${entity ?? 'Record'} not found.',
          code: 'NOT_FOUND',
        );
}

class DuplicateRecordException extends DatabaseException {
  const DuplicateRecordException({String? entity})
      : super(
          message: '${entity ?? 'Record'} already exists.',
          code: 'DUPLICATE',
        );
}

/// Sync exceptions
class SyncException extends AppException {
  const SyncException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class SyncConflictException extends SyncException {
  const SyncConflictException()
      : super(
          message: 'Sync conflict detected. Please resolve manually.',
          code: 'SYNC_CONFLICT',
        );
}

/// Payment exceptions
class PaymentException extends AppException {
  const PaymentException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class PaymentFailedException extends PaymentException {
  const PaymentFailedException({String? reason})
      : super(
          message: reason ?? 'Payment failed. Please try again.',
          code: 'PAYMENT_FAILED',
        );
}

class InsufficientFundsException extends PaymentException {
  const InsufficientFundsException()
      : super(
          message: 'Insufficient funds.',
          code: 'INSUFFICIENT_FUNDS',
        );
}

/// Subscription exceptions
class SubscriptionException extends AppException {
  const SubscriptionException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class TrialExpiredException extends SubscriptionException {
  const TrialExpiredException()
      : super(
          message: 'Your trial has expired. Please subscribe to continue.',
          code: 'TRIAL_EXPIRED',
        );
}

class SubscriptionRequiredException extends SubscriptionException {
  const SubscriptionRequiredException()
      : super(
          message: 'A subscription is required to access this feature.',
          code: 'SUBSCRIPTION_REQUIRED',
        );
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
  });
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({
    super.message = 'You do not have permission to perform this action.',
    String? code,
  }) : super(
          code: code ?? 'PERMISSION_DENIED',
        );
}

/// Stock-related exceptions
class StockException extends AppException {
  const StockException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class InsufficientStockException extends StockException {
  final String productName;
  final int available;
  final int requested;

  const InsufficientStockException({
    required this.productName,
    required this.available,
    required this.requested,
  }) : super(
          message:
              'Insufficient stock for $productName. Available: $available, Requested: $requested',
          code: 'INSUFFICIENT_STOCK',
        );
}
