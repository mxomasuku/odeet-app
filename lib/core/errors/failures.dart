import 'package:equatable/equatable.dart';

/// Base failure class for functional error handling
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class NoInternetFailure extends NetworkFailure {
  const NoInternetFailure()
      : super(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        );
}

class ServerFailure extends NetworkFailure {
  const ServerFailure({
    super.message = 'Server error occurred',
    String? code,
  }) : super(code: code ?? 'SERVER_ERROR');
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure()
      : super(
          message: 'Connection timed out',
          code: 'TIMEOUT',
        );
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super(
          message: 'Invalid email or password',
          code: 'INVALID_CREDENTIALS',
        );
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure()
      : super(
          message: 'Session expired',
          code: 'SESSION_EXPIRED',
        );
}

/// Database failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code});
}

class NotFoundFailure extends DatabaseFailure {
  const NotFoundFailure({String? entity})
      : super(
          message: '${entity ?? 'Record'} not found',
          code: 'NOT_FOUND',
        );
}

/// Validation failures
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
  }) : super(code: 'VALIDATION_ERROR');

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission denied',
  }) : super(code: 'PERMISSION_DENIED');
}

/// Sync failures
class SyncFailure extends Failure {
  const SyncFailure({required super.message, super.code});
}

/// Payment failures
class PaymentFailure extends Failure {
  const PaymentFailure({required super.message, super.code});
}

/// Subscription failures
class SubscriptionFailure extends Failure {
  const SubscriptionFailure({required super.message, super.code});
}

class TrialExpiredFailure extends SubscriptionFailure {
  const TrialExpiredFailure()
      : super(
          message: 'Trial period has expired',
          code: 'TRIAL_EXPIRED',
        );
}

/// Stock failures
class StockFailure extends Failure {
  const StockFailure({required super.message, super.code});
}

class InsufficientStockFailure extends StockFailure {
  final String productName;
  final int available;
  final int requested;

  const InsufficientStockFailure({
    required this.productName,
    required this.available,
    required this.requested,
  }) : super(
          message: 'Insufficient stock for $productName',
          code: 'INSUFFICIENT_STOCK',
        );

  @override
  List<Object?> get props => [message, code, productName, available, requested];
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred',
  }) : super(code: 'CACHE_ERROR');
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
  }) : super(code: 'UNKNOWN_ERROR');
}
