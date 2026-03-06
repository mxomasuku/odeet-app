// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      paymentReference: json['paymentReference'] as String,
      paymentMethodString: json['paymentMethod'] as String,
      currencyCode: json['currency'] as String? ?? 'USD',
      amount: (json['amount'] as num).toDouble(),
      statusString: json['status'] as String,
      purpose: json['purpose'] as String,
      subscriptionId: json['subscriptionId'] as String?,
      paynowPollUrl: json['paynowPollUrl'] as String?,
      paynowReference: json['paynowReference'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'paymentReference': instance.paymentReference,
      'paymentMethod': instance.paymentMethodString,
      'currency': instance.currencyCode,
      'amount': instance.amount,
      'status': instance.statusString,
      'purpose': instance.purpose,
      'subscriptionId': instance.subscriptionId,
      'paynowPollUrl': instance.paynowPollUrl,
      'paynowReference': instance.paynowReference,
      'mobileNumber': instance.mobileNumber,
      'errorMessage': instance.errorMessage,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

_$SubscriptionModelImpl _$$SubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      tierString: json['tier'] as String,
      statusString: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      autoRenew: json['autoRenew'] as bool? ?? true,
      cancelledReason: json['cancelledReason'] as String?,
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SubscriptionModelImplToJson(
        _$SubscriptionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'tier': instance.tierString,
      'status': instance.statusString,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'autoRenew': instance.autoRenew,
      'cancelledReason': instance.cancelledReason,
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$PaynowInitRequestImpl _$$PaynowInitRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PaynowInitRequestImpl(
      amount: (json['amount'] as num).toDouble(),
      email: json['email'] as String,
      phone: json['phone'] as String,
      reference: json['reference'] as String,
      returnUrl: json['returnUrl'] as String,
      resultUrl: json['resultUrl'] as String,
      description: json['description'] as String? ?? 'Subscription Payment',
    );

Map<String, dynamic> _$$PaynowInitRequestImplToJson(
        _$PaynowInitRequestImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'email': instance.email,
      'phone': instance.phone,
      'reference': instance.reference,
      'returnUrl': instance.returnUrl,
      'resultUrl': instance.resultUrl,
      'description': instance.description,
    };

_$PaynowResponseImpl _$$PaynowResponseImplFromJson(Map<String, dynamic> json) =>
    _$PaynowResponseImpl(
      success: json['success'] as bool,
      pollUrl: json['pollUrl'] as String?,
      redirectUrl: json['redirectUrl'] as String?,
      hash: json['hash'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$PaynowResponseImplToJson(
        _$PaynowResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'pollUrl': instance.pollUrl,
      'redirectUrl': instance.redirectUrl,
      'hash': instance.hash,
      'error': instance.error,
    };

_$PaynowStatusResponseImpl _$$PaynowStatusResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PaynowStatusResponseImpl(
      status: json['status'] as String,
      reference: json['reference'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      paynowReference: json['paynowReference'] as String?,
    );

Map<String, dynamic> _$$PaynowStatusResponseImplToJson(
        _$PaynowStatusResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'reference': instance.reference,
      'amount': instance.amount,
      'paynowReference': instance.paynowReference,
    };
