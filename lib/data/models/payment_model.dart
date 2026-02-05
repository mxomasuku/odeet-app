import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String organizationId,
    required String paymentReference,
    @JsonKey(name: 'paymentMethod') required String paymentMethodString,
    @JsonKey(name: 'currency') @Default('USD') String currencyCode,
    required double amount,
    @JsonKey(name: 'status') required String statusString,
    required String purpose,
    String? subscriptionId,
    String? paynowPollUrl,
    String? paynowReference,
    String? mobileNumber,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? completedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _PaymentModel;

  const PaymentModel._();

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  PaymentMethod get paymentMethod => PaymentMethod.values.firstWhere(
        (p) => p.code == paymentMethodString,
        orElse: () => PaymentMethod.cash,
      );

  Currency get currency => Currency.values.firstWhere(
        (c) => c.code == currencyCode,
        orElse: () => Currency.usd,
      );

  PaymentStatus get status => PaymentStatus.values.firstWhere(
        (s) => s.name == statusString,
        orElse: () => PaymentStatus.pending,
      );

  bool get isPending => status == PaymentStatus.pending;
  bool get isCompleted => status == PaymentStatus.completed;
  bool get isFailed => status == PaymentStatus.failed;
  bool get isCancelled => status == PaymentStatus.cancelled;
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
}

@freezed
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required String id,
    required String organizationId,
    @JsonKey(name: 'tier') required String tierString,
    @JsonKey(name: 'status') required String statusString,
    required DateTime startDate,
    required DateTime endDate,
    @Default(true) bool autoRenew,
    String? cancelledReason,
    DateTime? cancelledAt,
    DateTime? createdAt,
  }) = _SubscriptionModel;

  const SubscriptionModel._();

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  SubscriptionTier get tier => SubscriptionTier.values.firstWhere(
        (t) => t.name == tierString,
        orElse: () => SubscriptionTier.trial,
      );

  SubscriptionStatus get status => SubscriptionStatus.values.firstWhere(
        (s) => s.name == statusString,
        orElse: () => SubscriptionStatus.active,
      );

  bool get isActive =>
      status == SubscriptionStatus.active &&
      DateTime.now().isBefore(endDate);

  int get daysRemaining {
    final remaining = endDate.difference(DateTime.now()).inDays;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isExpiringSoon => daysRemaining <= 7 && daysRemaining > 0;
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  suspended,
}

/// Paynow payment initiation request
@freezed
class PaynowInitRequest with _$PaynowInitRequest {
  const factory PaynowInitRequest({
    required double amount,
    required String email,
    required String phone,
    required String reference,
    required String returnUrl,
    required String resultUrl,
    @Default('Subscription Payment') String description,
  }) = _PaynowInitRequest;

  factory PaynowInitRequest.fromJson(Map<String, dynamic> json) =>
      _$PaynowInitRequestFromJson(json);
}

/// Paynow payment response
@freezed
class PaynowResponse with _$PaynowResponse {
  const factory PaynowResponse({
    required bool success,
    String? pollUrl,
    String? redirectUrl,
    String? hash,
    String? error,
  }) = _PaynowResponse;

  factory PaynowResponse.fromJson(Map<String, dynamic> json) =>
      _$PaynowResponseFromJson(json);
}

/// Paynow status check response
@freezed
class PaynowStatusResponse with _$PaynowStatusResponse {
  const factory PaynowStatusResponse({
    required String status,
    String? reference,
    double? amount,
    String? paynowReference,
  }) = _PaynowStatusResponse;

  factory PaynowStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$PaynowStatusResponseFromJson(json);
}
