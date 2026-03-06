// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get paymentReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'paymentMethod')
  String get paymentMethodString => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String get currencyCode => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get statusString => throw _privateConstructorUsedError;
  String get purpose => throw _privateConstructorUsedError;
  String? get subscriptionId => throw _privateConstructorUsedError;
  String? get paynowPollUrl => throw _privateConstructorUsedError;
  String? get paynowReference => throw _privateConstructorUsedError;
  String? get mobileNumber => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
          PaymentModel value, $Res Function(PaymentModel) then) =
      _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String paymentReference,
      @JsonKey(name: 'paymentMethod') String paymentMethodString,
      @JsonKey(name: 'currency') String currencyCode,
      double amount,
      @JsonKey(name: 'status') String statusString,
      String purpose,
      String? subscriptionId,
      String? paynowPollUrl,
      String? paynowReference,
      String? mobileNumber,
      String? errorMessage,
      DateTime createdAt,
      DateTime? completedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? paymentReference = null,
    Object? paymentMethodString = null,
    Object? currencyCode = null,
    Object? amount = null,
    Object? statusString = null,
    Object? purpose = null,
    Object? subscriptionId = freezed,
    Object? paynowPollUrl = freezed,
    Object? paynowReference = freezed,
    Object? mobileNumber = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentReference: null == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethodString: null == paymentMethodString
          ? _value.paymentMethodString
          : paymentMethodString // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      paynowPollUrl: freezed == paynowPollUrl
          ? _value.paynowPollUrl
          : paynowPollUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      paynowReference: freezed == paynowReference
          ? _value.paynowReference
          : paynowReference // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileNumber: freezed == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
          _$PaymentModelImpl value, $Res Function(_$PaymentModelImpl) then) =
      __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String paymentReference,
      @JsonKey(name: 'paymentMethod') String paymentMethodString,
      @JsonKey(name: 'currency') String currencyCode,
      double amount,
      @JsonKey(name: 'status') String statusString,
      String purpose,
      String? subscriptionId,
      String? paynowPollUrl,
      String? paynowReference,
      String? mobileNumber,
      String? errorMessage,
      DateTime createdAt,
      DateTime? completedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
      _$PaymentModelImpl _value, $Res Function(_$PaymentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? paymentReference = null,
    Object? paymentMethodString = null,
    Object? currencyCode = null,
    Object? amount = null,
    Object? statusString = null,
    Object? purpose = null,
    Object? subscriptionId = freezed,
    Object? paynowPollUrl = freezed,
    Object? paynowReference = freezed,
    Object? mobileNumber = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_$PaymentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentReference: null == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethodString: null == paymentMethodString
          ? _value.paymentMethodString
          : paymentMethodString // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      paynowPollUrl: freezed == paynowPollUrl
          ? _value.paynowPollUrl
          : paynowPollUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      paynowReference: freezed == paynowReference
          ? _value.paynowReference
          : paynowReference // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileNumber: freezed == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl extends _PaymentModel {
  const _$PaymentModelImpl(
      {required this.id,
      required this.organizationId,
      required this.paymentReference,
      @JsonKey(name: 'paymentMethod') required this.paymentMethodString,
      @JsonKey(name: 'currency') this.currencyCode = 'USD',
      required this.amount,
      @JsonKey(name: 'status') required this.statusString,
      required this.purpose,
      this.subscriptionId,
      this.paynowPollUrl,
      this.paynowReference,
      this.mobileNumber,
      this.errorMessage,
      required this.createdAt,
      this.completedAt,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata,
        super._();

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String paymentReference;
  @override
  @JsonKey(name: 'paymentMethod')
  final String paymentMethodString;
  @override
  @JsonKey(name: 'currency')
  final String currencyCode;
  @override
  final double amount;
  @override
  @JsonKey(name: 'status')
  final String statusString;
  @override
  final String purpose;
  @override
  final String? subscriptionId;
  @override
  final String? paynowPollUrl;
  @override
  final String? paynowReference;
  @override
  final String? mobileNumber;
  @override
  final String? errorMessage;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'PaymentModel(id: $id, organizationId: $organizationId, paymentReference: $paymentReference, paymentMethodString: $paymentMethodString, currencyCode: $currencyCode, amount: $amount, statusString: $statusString, purpose: $purpose, subscriptionId: $subscriptionId, paynowPollUrl: $paynowPollUrl, paynowReference: $paynowReference, mobileNumber: $mobileNumber, errorMessage: $errorMessage, createdAt: $createdAt, completedAt: $completedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference) &&
            (identical(other.paymentMethodString, paymentMethodString) ||
                other.paymentMethodString == paymentMethodString) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.statusString, statusString) ||
                other.statusString == statusString) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.paynowPollUrl, paynowPollUrl) ||
                other.paynowPollUrl == paynowPollUrl) &&
            (identical(other.paynowReference, paynowReference) ||
                other.paynowReference == paynowReference) &&
            (identical(other.mobileNumber, mobileNumber) ||
                other.mobileNumber == mobileNumber) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      paymentReference,
      paymentMethodString,
      currencyCode,
      amount,
      statusString,
      purpose,
      subscriptionId,
      paynowPollUrl,
      paynowReference,
      mobileNumber,
      errorMessage,
      createdAt,
      completedAt,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentModel extends PaymentModel {
  const factory _PaymentModel(
      {required final String id,
      required final String organizationId,
      required final String paymentReference,
      @JsonKey(name: 'paymentMethod') required final String paymentMethodString,
      @JsonKey(name: 'currency') final String currencyCode,
      required final double amount,
      @JsonKey(name: 'status') required final String statusString,
      required final String purpose,
      final String? subscriptionId,
      final String? paynowPollUrl,
      final String? paynowReference,
      final String? mobileNumber,
      final String? errorMessage,
      required final DateTime createdAt,
      final DateTime? completedAt,
      final Map<String, dynamic> metadata}) = _$PaymentModelImpl;
  const _PaymentModel._() : super._();

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get paymentReference;
  @override
  @JsonKey(name: 'paymentMethod')
  String get paymentMethodString;
  @override
  @JsonKey(name: 'currency')
  String get currencyCode;
  @override
  double get amount;
  @override
  @JsonKey(name: 'status')
  String get statusString;
  @override
  String get purpose;
  @override
  String? get subscriptionId;
  @override
  String? get paynowPollUrl;
  @override
  String? get paynowReference;
  @override
  String? get mobileNumber;
  @override
  String? get errorMessage;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) {
  return _SubscriptionModel.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tier')
  String get tierString => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get statusString => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get autoRenew => throw _privateConstructorUsedError;
  String? get cancelledReason => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubscriptionModelCopyWith<SubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionModelCopyWith<$Res> {
  factory $SubscriptionModelCopyWith(
          SubscriptionModel value, $Res Function(SubscriptionModel) then) =
      _$SubscriptionModelCopyWithImpl<$Res, SubscriptionModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      @JsonKey(name: 'tier') String tierString,
      @JsonKey(name: 'status') String statusString,
      DateTime startDate,
      DateTime endDate,
      bool autoRenew,
      String? cancelledReason,
      DateTime? cancelledAt,
      DateTime? createdAt});
}

/// @nodoc
class _$SubscriptionModelCopyWithImpl<$Res, $Val extends SubscriptionModel>
    implements $SubscriptionModelCopyWith<$Res> {
  _$SubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? tierString = null,
    Object? statusString = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? autoRenew = null,
    Object? cancelledReason = freezed,
    Object? cancelledAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      tierString: null == tierString
          ? _value.tierString
          : tierString // ignore: cast_nullable_to_non_nullable
              as String,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      cancelledReason: freezed == cancelledReason
          ? _value.cancelledReason
          : cancelledReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionModelImplCopyWith<$Res>
    implements $SubscriptionModelCopyWith<$Res> {
  factory _$$SubscriptionModelImplCopyWith(_$SubscriptionModelImpl value,
          $Res Function(_$SubscriptionModelImpl) then) =
      __$$SubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      @JsonKey(name: 'tier') String tierString,
      @JsonKey(name: 'status') String statusString,
      DateTime startDate,
      DateTime endDate,
      bool autoRenew,
      String? cancelledReason,
      DateTime? cancelledAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$SubscriptionModelImplCopyWithImpl<$Res>
    extends _$SubscriptionModelCopyWithImpl<$Res, _$SubscriptionModelImpl>
    implements _$$SubscriptionModelImplCopyWith<$Res> {
  __$$SubscriptionModelImplCopyWithImpl(_$SubscriptionModelImpl _value,
      $Res Function(_$SubscriptionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? tierString = null,
    Object? statusString = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? autoRenew = null,
    Object? cancelledReason = freezed,
    Object? cancelledAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$SubscriptionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      tierString: null == tierString
          ? _value.tierString
          : tierString // ignore: cast_nullable_to_non_nullable
              as String,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      cancelledReason: freezed == cancelledReason
          ? _value.cancelledReason
          : cancelledReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionModelImpl extends _SubscriptionModel {
  const _$SubscriptionModelImpl(
      {required this.id,
      required this.organizationId,
      @JsonKey(name: 'tier') required this.tierString,
      @JsonKey(name: 'status') required this.statusString,
      required this.startDate,
      required this.endDate,
      this.autoRenew = true,
      this.cancelledReason,
      this.cancelledAt,
      this.createdAt})
      : super._();

  factory _$SubscriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  @JsonKey(name: 'tier')
  final String tierString;
  @override
  @JsonKey(name: 'status')
  final String statusString;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final bool autoRenew;
  @override
  final String? cancelledReason;
  @override
  final DateTime? cancelledAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, organizationId: $organizationId, tierString: $tierString, statusString: $statusString, startDate: $startDate, endDate: $endDate, autoRenew: $autoRenew, cancelledReason: $cancelledReason, cancelledAt: $cancelledAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.tierString, tierString) ||
                other.tierString == tierString) &&
            (identical(other.statusString, statusString) ||
                other.statusString == statusString) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.cancelledReason, cancelledReason) ||
                other.cancelledReason == cancelledReason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      tierString,
      statusString,
      startDate,
      endDate,
      autoRenew,
      cancelledReason,
      cancelledAt,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      __$$SubscriptionModelImplCopyWithImpl<_$SubscriptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionModelImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionModel extends SubscriptionModel {
  const factory _SubscriptionModel(
      {required final String id,
      required final String organizationId,
      @JsonKey(name: 'tier') required final String tierString,
      @JsonKey(name: 'status') required final String statusString,
      required final DateTime startDate,
      required final DateTime endDate,
      final bool autoRenew,
      final String? cancelledReason,
      final DateTime? cancelledAt,
      final DateTime? createdAt}) = _$SubscriptionModelImpl;
  const _SubscriptionModel._() : super._();

  factory _SubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  @JsonKey(name: 'tier')
  String get tierString;
  @override
  @JsonKey(name: 'status')
  String get statusString;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  bool get autoRenew;
  @override
  String? get cancelledReason;
  @override
  DateTime? get cancelledAt;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaynowInitRequest _$PaynowInitRequestFromJson(Map<String, dynamic> json) {
  return _PaynowInitRequest.fromJson(json);
}

/// @nodoc
mixin _$PaynowInitRequest {
  double get amount => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get returnUrl => throw _privateConstructorUsedError;
  String get resultUrl => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaynowInitRequestCopyWith<PaynowInitRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaynowInitRequestCopyWith<$Res> {
  factory $PaynowInitRequestCopyWith(
          PaynowInitRequest value, $Res Function(PaynowInitRequest) then) =
      _$PaynowInitRequestCopyWithImpl<$Res, PaynowInitRequest>;
  @useResult
  $Res call(
      {double amount,
      String email,
      String phone,
      String reference,
      String returnUrl,
      String resultUrl,
      String description});
}

/// @nodoc
class _$PaynowInitRequestCopyWithImpl<$Res, $Val extends PaynowInitRequest>
    implements $PaynowInitRequestCopyWith<$Res> {
  _$PaynowInitRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? email = null,
    Object? phone = null,
    Object? reference = null,
    Object? returnUrl = null,
    Object? resultUrl = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      returnUrl: null == returnUrl
          ? _value.returnUrl
          : returnUrl // ignore: cast_nullable_to_non_nullable
              as String,
      resultUrl: null == resultUrl
          ? _value.resultUrl
          : resultUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaynowInitRequestImplCopyWith<$Res>
    implements $PaynowInitRequestCopyWith<$Res> {
  factory _$$PaynowInitRequestImplCopyWith(_$PaynowInitRequestImpl value,
          $Res Function(_$PaynowInitRequestImpl) then) =
      __$$PaynowInitRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String email,
      String phone,
      String reference,
      String returnUrl,
      String resultUrl,
      String description});
}

/// @nodoc
class __$$PaynowInitRequestImplCopyWithImpl<$Res>
    extends _$PaynowInitRequestCopyWithImpl<$Res, _$PaynowInitRequestImpl>
    implements _$$PaynowInitRequestImplCopyWith<$Res> {
  __$$PaynowInitRequestImplCopyWithImpl(_$PaynowInitRequestImpl _value,
      $Res Function(_$PaynowInitRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? email = null,
    Object? phone = null,
    Object? reference = null,
    Object? returnUrl = null,
    Object? resultUrl = null,
    Object? description = null,
  }) {
    return _then(_$PaynowInitRequestImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      returnUrl: null == returnUrl
          ? _value.returnUrl
          : returnUrl // ignore: cast_nullable_to_non_nullable
              as String,
      resultUrl: null == resultUrl
          ? _value.resultUrl
          : resultUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaynowInitRequestImpl implements _PaynowInitRequest {
  const _$PaynowInitRequestImpl(
      {required this.amount,
      required this.email,
      required this.phone,
      required this.reference,
      required this.returnUrl,
      required this.resultUrl,
      this.description = 'Subscription Payment'});

  factory _$PaynowInitRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaynowInitRequestImplFromJson(json);

  @override
  final double amount;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String reference;
  @override
  final String returnUrl;
  @override
  final String resultUrl;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'PaynowInitRequest(amount: $amount, email: $email, phone: $phone, reference: $reference, returnUrl: $returnUrl, resultUrl: $resultUrl, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaynowInitRequestImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.returnUrl, returnUrl) ||
                other.returnUrl == returnUrl) &&
            (identical(other.resultUrl, resultUrl) ||
                other.resultUrl == resultUrl) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, amount, email, phone, reference,
      returnUrl, resultUrl, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaynowInitRequestImplCopyWith<_$PaynowInitRequestImpl> get copyWith =>
      __$$PaynowInitRequestImplCopyWithImpl<_$PaynowInitRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaynowInitRequestImplToJson(
      this,
    );
  }
}

abstract class _PaynowInitRequest implements PaynowInitRequest {
  const factory _PaynowInitRequest(
      {required final double amount,
      required final String email,
      required final String phone,
      required final String reference,
      required final String returnUrl,
      required final String resultUrl,
      final String description}) = _$PaynowInitRequestImpl;

  factory _PaynowInitRequest.fromJson(Map<String, dynamic> json) =
      _$PaynowInitRequestImpl.fromJson;

  @override
  double get amount;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get reference;
  @override
  String get returnUrl;
  @override
  String get resultUrl;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$PaynowInitRequestImplCopyWith<_$PaynowInitRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaynowResponse _$PaynowResponseFromJson(Map<String, dynamic> json) {
  return _PaynowResponse.fromJson(json);
}

/// @nodoc
mixin _$PaynowResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get pollUrl => throw _privateConstructorUsedError;
  String? get redirectUrl => throw _privateConstructorUsedError;
  String? get hash => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaynowResponseCopyWith<PaynowResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaynowResponseCopyWith<$Res> {
  factory $PaynowResponseCopyWith(
          PaynowResponse value, $Res Function(PaynowResponse) then) =
      _$PaynowResponseCopyWithImpl<$Res, PaynowResponse>;
  @useResult
  $Res call(
      {bool success,
      String? pollUrl,
      String? redirectUrl,
      String? hash,
      String? error});
}

/// @nodoc
class _$PaynowResponseCopyWithImpl<$Res, $Val extends PaynowResponse>
    implements $PaynowResponseCopyWith<$Res> {
  _$PaynowResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? pollUrl = freezed,
    Object? redirectUrl = freezed,
    Object? hash = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      pollUrl: freezed == pollUrl
          ? _value.pollUrl
          : pollUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      redirectUrl: freezed == redirectUrl
          ? _value.redirectUrl
          : redirectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaynowResponseImplCopyWith<$Res>
    implements $PaynowResponseCopyWith<$Res> {
  factory _$$PaynowResponseImplCopyWith(_$PaynowResponseImpl value,
          $Res Function(_$PaynowResponseImpl) then) =
      __$$PaynowResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? pollUrl,
      String? redirectUrl,
      String? hash,
      String? error});
}

/// @nodoc
class __$$PaynowResponseImplCopyWithImpl<$Res>
    extends _$PaynowResponseCopyWithImpl<$Res, _$PaynowResponseImpl>
    implements _$$PaynowResponseImplCopyWith<$Res> {
  __$$PaynowResponseImplCopyWithImpl(
      _$PaynowResponseImpl _value, $Res Function(_$PaynowResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? pollUrl = freezed,
    Object? redirectUrl = freezed,
    Object? hash = freezed,
    Object? error = freezed,
  }) {
    return _then(_$PaynowResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      pollUrl: freezed == pollUrl
          ? _value.pollUrl
          : pollUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      redirectUrl: freezed == redirectUrl
          ? _value.redirectUrl
          : redirectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaynowResponseImpl implements _PaynowResponse {
  const _$PaynowResponseImpl(
      {required this.success,
      this.pollUrl,
      this.redirectUrl,
      this.hash,
      this.error});

  factory _$PaynowResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaynowResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? pollUrl;
  @override
  final String? redirectUrl;
  @override
  final String? hash;
  @override
  final String? error;

  @override
  String toString() {
    return 'PaynowResponse(success: $success, pollUrl: $pollUrl, redirectUrl: $redirectUrl, hash: $hash, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaynowResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.pollUrl, pollUrl) || other.pollUrl == pollUrl) &&
            (identical(other.redirectUrl, redirectUrl) ||
                other.redirectUrl == redirectUrl) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, pollUrl, redirectUrl, hash, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaynowResponseImplCopyWith<_$PaynowResponseImpl> get copyWith =>
      __$$PaynowResponseImplCopyWithImpl<_$PaynowResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaynowResponseImplToJson(
      this,
    );
  }
}

abstract class _PaynowResponse implements PaynowResponse {
  const factory _PaynowResponse(
      {required final bool success,
      final String? pollUrl,
      final String? redirectUrl,
      final String? hash,
      final String? error}) = _$PaynowResponseImpl;

  factory _PaynowResponse.fromJson(Map<String, dynamic> json) =
      _$PaynowResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get pollUrl;
  @override
  String? get redirectUrl;
  @override
  String? get hash;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$PaynowResponseImplCopyWith<_$PaynowResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaynowStatusResponse _$PaynowStatusResponseFromJson(Map<String, dynamic> json) {
  return _PaynowStatusResponse.fromJson(json);
}

/// @nodoc
mixin _$PaynowStatusResponse {
  String get status => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get paynowReference => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaynowStatusResponseCopyWith<PaynowStatusResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaynowStatusResponseCopyWith<$Res> {
  factory $PaynowStatusResponseCopyWith(PaynowStatusResponse value,
          $Res Function(PaynowStatusResponse) then) =
      _$PaynowStatusResponseCopyWithImpl<$Res, PaynowStatusResponse>;
  @useResult
  $Res call(
      {String status,
      String? reference,
      double? amount,
      String? paynowReference});
}

/// @nodoc
class _$PaynowStatusResponseCopyWithImpl<$Res,
        $Val extends PaynowStatusResponse>
    implements $PaynowStatusResponseCopyWith<$Res> {
  _$PaynowStatusResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? reference = freezed,
    Object? amount = freezed,
    Object? paynowReference = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paynowReference: freezed == paynowReference
          ? _value.paynowReference
          : paynowReference // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaynowStatusResponseImplCopyWith<$Res>
    implements $PaynowStatusResponseCopyWith<$Res> {
  factory _$$PaynowStatusResponseImplCopyWith(_$PaynowStatusResponseImpl value,
          $Res Function(_$PaynowStatusResponseImpl) then) =
      __$$PaynowStatusResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String? reference,
      double? amount,
      String? paynowReference});
}

/// @nodoc
class __$$PaynowStatusResponseImplCopyWithImpl<$Res>
    extends _$PaynowStatusResponseCopyWithImpl<$Res, _$PaynowStatusResponseImpl>
    implements _$$PaynowStatusResponseImplCopyWith<$Res> {
  __$$PaynowStatusResponseImplCopyWithImpl(_$PaynowStatusResponseImpl _value,
      $Res Function(_$PaynowStatusResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? reference = freezed,
    Object? amount = freezed,
    Object? paynowReference = freezed,
  }) {
    return _then(_$PaynowStatusResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paynowReference: freezed == paynowReference
          ? _value.paynowReference
          : paynowReference // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaynowStatusResponseImpl implements _PaynowStatusResponse {
  const _$PaynowStatusResponseImpl(
      {required this.status,
      this.reference,
      this.amount,
      this.paynowReference});

  factory _$PaynowStatusResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaynowStatusResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String? reference;
  @override
  final double? amount;
  @override
  final String? paynowReference;

  @override
  String toString() {
    return 'PaynowStatusResponse(status: $status, reference: $reference, amount: $amount, paynowReference: $paynowReference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaynowStatusResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paynowReference, paynowReference) ||
                other.paynowReference == paynowReference));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, reference, amount, paynowReference);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaynowStatusResponseImplCopyWith<_$PaynowStatusResponseImpl>
      get copyWith =>
          __$$PaynowStatusResponseImplCopyWithImpl<_$PaynowStatusResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaynowStatusResponseImplToJson(
      this,
    );
  }
}

abstract class _PaynowStatusResponse implements PaynowStatusResponse {
  const factory _PaynowStatusResponse(
      {required final String status,
      final String? reference,
      final double? amount,
      final String? paynowReference}) = _$PaynowStatusResponseImpl;

  factory _PaynowStatusResponse.fromJson(Map<String, dynamic> json) =
      _$PaynowStatusResponseImpl.fromJson;

  @override
  String get status;
  @override
  String? get reference;
  @override
  double? get amount;
  @override
  String? get paynowReference;
  @override
  @JsonKey(ignore: true)
  _$$PaynowStatusResponseImplCopyWith<_$PaynowStatusResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
