// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_collection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CashCollectionModel _$CashCollectionModelFromJson(Map<String, dynamic> json) {
  return _CashCollectionModel.fromJson(json);
}

/// @nodoc
mixin _$CashCollectionModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get collectionNumber => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get shopName => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String get currencyCode => throw _privateConstructorUsedError;
  double get expectedAmount => throw _privateConstructorUsedError;
  double get actualAmount => throw _privateConstructorUsedError;
  double? get confirmedAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get statusString => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // Denominations breakdown
  Map<String, int> get denominations =>
      throw _privateConstructorUsedError; // Submitted by (cashier)
  String get submittedBy => throw _privateConstructorUsedError;
  String get submittedByName => throw _privateConstructorUsedError;
  DateTime get submittedAt =>
      throw _privateConstructorUsedError; // Collected by (manager/collector)
  String? get collectedBy => throw _privateConstructorUsedError;
  String? get collectedByName => throw _privateConstructorUsedError;
  DateTime? get collectedAt =>
      throw _privateConstructorUsedError; // Confirmed by (admin/accountant)
  String? get confirmedBy => throw _privateConstructorUsedError;
  String? get confirmedByName => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError; // Dispute
  String? get disputeReason => throw _privateConstructorUsedError;
  String? get disputedBy => throw _privateConstructorUsedError;
  DateTime? get disputedAt => throw _privateConstructorUsedError;
  String? get disputeResolution => throw _privateConstructorUsedError; // Sync
  DateTime? get syncedAt => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CashCollectionModelCopyWith<CashCollectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashCollectionModelCopyWith<$Res> {
  factory $CashCollectionModelCopyWith(
          CashCollectionModel value, $Res Function(CashCollectionModel) then) =
      _$CashCollectionModelCopyWithImpl<$Res, CashCollectionModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String collectionNumber,
      String shopId,
      String shopName,
      @JsonKey(name: 'currency') String currencyCode,
      double expectedAmount,
      double actualAmount,
      double? confirmedAmount,
      @JsonKey(name: 'status') String statusString,
      String? notes,
      Map<String, int> denominations,
      String submittedBy,
      String submittedByName,
      DateTime submittedAt,
      String? collectedBy,
      String? collectedByName,
      DateTime? collectedAt,
      String? confirmedBy,
      String? confirmedByName,
      DateTime? confirmedAt,
      String? disputeReason,
      String? disputedBy,
      DateTime? disputedAt,
      String? disputeResolution,
      DateTime? syncedAt,
      bool isSynced});
}

/// @nodoc
class _$CashCollectionModelCopyWithImpl<$Res, $Val extends CashCollectionModel>
    implements $CashCollectionModelCopyWith<$Res> {
  _$CashCollectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? collectionNumber = null,
    Object? shopId = null,
    Object? shopName = null,
    Object? currencyCode = null,
    Object? expectedAmount = null,
    Object? actualAmount = null,
    Object? confirmedAmount = freezed,
    Object? statusString = null,
    Object? notes = freezed,
    Object? denominations = null,
    Object? submittedBy = null,
    Object? submittedByName = null,
    Object? submittedAt = null,
    Object? collectedBy = freezed,
    Object? collectedByName = freezed,
    Object? collectedAt = freezed,
    Object? confirmedBy = freezed,
    Object? confirmedByName = freezed,
    Object? confirmedAt = freezed,
    Object? disputeReason = freezed,
    Object? disputedBy = freezed,
    Object? disputedAt = freezed,
    Object? disputeResolution = freezed,
    Object? syncedAt = freezed,
    Object? isSynced = null,
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
      collectionNumber: null == collectionNumber
          ? _value.collectionNumber
          : collectionNumber // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      expectedAmount: null == expectedAmount
          ? _value.expectedAmount
          : expectedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      confirmedAmount: freezed == confirmedAmount
          ? _value.confirmedAmount
          : confirmedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      denominations: null == denominations
          ? _value.denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      submittedBy: null == submittedBy
          ? _value.submittedBy
          : submittedBy // ignore: cast_nullable_to_non_nullable
              as String,
      submittedByName: null == submittedByName
          ? _value.submittedByName
          : submittedByName // ignore: cast_nullable_to_non_nullable
              as String,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      collectedBy: freezed == collectedBy
          ? _value.collectedBy
          : collectedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      collectedByName: freezed == collectedByName
          ? _value.collectedByName
          : collectedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      collectedAt: freezed == collectedAt
          ? _value.collectedAt
          : collectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedBy: freezed == confirmedBy
          ? _value.confirmedBy
          : confirmedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedByName: freezed == confirmedByName
          ? _value.confirmedByName
          : confirmedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disputeReason: freezed == disputeReason
          ? _value.disputeReason
          : disputeReason // ignore: cast_nullable_to_non_nullable
              as String?,
      disputedBy: freezed == disputedBy
          ? _value.disputedBy
          : disputedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      disputedAt: freezed == disputedAt
          ? _value.disputedAt
          : disputedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disputeResolution: freezed == disputeResolution
          ? _value.disputeResolution
          : disputeResolution // ignore: cast_nullable_to_non_nullable
              as String?,
      syncedAt: freezed == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashCollectionModelImplCopyWith<$Res>
    implements $CashCollectionModelCopyWith<$Res> {
  factory _$$CashCollectionModelImplCopyWith(_$CashCollectionModelImpl value,
          $Res Function(_$CashCollectionModelImpl) then) =
      __$$CashCollectionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String collectionNumber,
      String shopId,
      String shopName,
      @JsonKey(name: 'currency') String currencyCode,
      double expectedAmount,
      double actualAmount,
      double? confirmedAmount,
      @JsonKey(name: 'status') String statusString,
      String? notes,
      Map<String, int> denominations,
      String submittedBy,
      String submittedByName,
      DateTime submittedAt,
      String? collectedBy,
      String? collectedByName,
      DateTime? collectedAt,
      String? confirmedBy,
      String? confirmedByName,
      DateTime? confirmedAt,
      String? disputeReason,
      String? disputedBy,
      DateTime? disputedAt,
      String? disputeResolution,
      DateTime? syncedAt,
      bool isSynced});
}

/// @nodoc
class __$$CashCollectionModelImplCopyWithImpl<$Res>
    extends _$CashCollectionModelCopyWithImpl<$Res, _$CashCollectionModelImpl>
    implements _$$CashCollectionModelImplCopyWith<$Res> {
  __$$CashCollectionModelImplCopyWithImpl(_$CashCollectionModelImpl _value,
      $Res Function(_$CashCollectionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? collectionNumber = null,
    Object? shopId = null,
    Object? shopName = null,
    Object? currencyCode = null,
    Object? expectedAmount = null,
    Object? actualAmount = null,
    Object? confirmedAmount = freezed,
    Object? statusString = null,
    Object? notes = freezed,
    Object? denominations = null,
    Object? submittedBy = null,
    Object? submittedByName = null,
    Object? submittedAt = null,
    Object? collectedBy = freezed,
    Object? collectedByName = freezed,
    Object? collectedAt = freezed,
    Object? confirmedBy = freezed,
    Object? confirmedByName = freezed,
    Object? confirmedAt = freezed,
    Object? disputeReason = freezed,
    Object? disputedBy = freezed,
    Object? disputedAt = freezed,
    Object? disputeResolution = freezed,
    Object? syncedAt = freezed,
    Object? isSynced = null,
  }) {
    return _then(_$CashCollectionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      collectionNumber: null == collectionNumber
          ? _value.collectionNumber
          : collectionNumber // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      expectedAmount: null == expectedAmount
          ? _value.expectedAmount
          : expectedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      confirmedAmount: freezed == confirmedAmount
          ? _value.confirmedAmount
          : confirmedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      denominations: null == denominations
          ? _value._denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      submittedBy: null == submittedBy
          ? _value.submittedBy
          : submittedBy // ignore: cast_nullable_to_non_nullable
              as String,
      submittedByName: null == submittedByName
          ? _value.submittedByName
          : submittedByName // ignore: cast_nullable_to_non_nullable
              as String,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      collectedBy: freezed == collectedBy
          ? _value.collectedBy
          : collectedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      collectedByName: freezed == collectedByName
          ? _value.collectedByName
          : collectedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      collectedAt: freezed == collectedAt
          ? _value.collectedAt
          : collectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedBy: freezed == confirmedBy
          ? _value.confirmedBy
          : confirmedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedByName: freezed == confirmedByName
          ? _value.confirmedByName
          : confirmedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disputeReason: freezed == disputeReason
          ? _value.disputeReason
          : disputeReason // ignore: cast_nullable_to_non_nullable
              as String?,
      disputedBy: freezed == disputedBy
          ? _value.disputedBy
          : disputedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      disputedAt: freezed == disputedAt
          ? _value.disputedAt
          : disputedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disputeResolution: freezed == disputeResolution
          ? _value.disputeResolution
          : disputeResolution // ignore: cast_nullable_to_non_nullable
              as String?,
      syncedAt: freezed == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashCollectionModelImpl extends _CashCollectionModel {
  const _$CashCollectionModelImpl(
      {required this.id,
      required this.organizationId,
      required this.collectionNumber,
      required this.shopId,
      required this.shopName,
      @JsonKey(name: 'currency') this.currencyCode = 'USD',
      required this.expectedAmount,
      required this.actualAmount,
      this.confirmedAmount,
      @JsonKey(name: 'status') required this.statusString,
      this.notes,
      final Map<String, int> denominations = const {},
      required this.submittedBy,
      required this.submittedByName,
      required this.submittedAt,
      this.collectedBy,
      this.collectedByName,
      this.collectedAt,
      this.confirmedBy,
      this.confirmedByName,
      this.confirmedAt,
      this.disputeReason,
      this.disputedBy,
      this.disputedAt,
      this.disputeResolution,
      this.syncedAt,
      this.isSynced = false})
      : _denominations = denominations,
        super._();

  factory _$CashCollectionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashCollectionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String collectionNumber;
  @override
  final String shopId;
  @override
  final String shopName;
  @override
  @JsonKey(name: 'currency')
  final String currencyCode;
  @override
  final double expectedAmount;
  @override
  final double actualAmount;
  @override
  final double? confirmedAmount;
  @override
  @JsonKey(name: 'status')
  final String statusString;
  @override
  final String? notes;
// Denominations breakdown
  final Map<String, int> _denominations;
// Denominations breakdown
  @override
  @JsonKey()
  Map<String, int> get denominations {
    if (_denominations is EqualUnmodifiableMapView) return _denominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_denominations);
  }

// Submitted by (cashier)
  @override
  final String submittedBy;
  @override
  final String submittedByName;
  @override
  final DateTime submittedAt;
// Collected by (manager/collector)
  @override
  final String? collectedBy;
  @override
  final String? collectedByName;
  @override
  final DateTime? collectedAt;
// Confirmed by (admin/accountant)
  @override
  final String? confirmedBy;
  @override
  final String? confirmedByName;
  @override
  final DateTime? confirmedAt;
// Dispute
  @override
  final String? disputeReason;
  @override
  final String? disputedBy;
  @override
  final DateTime? disputedAt;
  @override
  final String? disputeResolution;
// Sync
  @override
  final DateTime? syncedAt;
  @override
  @JsonKey()
  final bool isSynced;

  @override
  String toString() {
    return 'CashCollectionModel(id: $id, organizationId: $organizationId, collectionNumber: $collectionNumber, shopId: $shopId, shopName: $shopName, currencyCode: $currencyCode, expectedAmount: $expectedAmount, actualAmount: $actualAmount, confirmedAmount: $confirmedAmount, statusString: $statusString, notes: $notes, denominations: $denominations, submittedBy: $submittedBy, submittedByName: $submittedByName, submittedAt: $submittedAt, collectedBy: $collectedBy, collectedByName: $collectedByName, collectedAt: $collectedAt, confirmedBy: $confirmedBy, confirmedByName: $confirmedByName, confirmedAt: $confirmedAt, disputeReason: $disputeReason, disputedBy: $disputedBy, disputedAt: $disputedAt, disputeResolution: $disputeResolution, syncedAt: $syncedAt, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashCollectionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.collectionNumber, collectionNumber) ||
                other.collectionNumber == collectionNumber) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.expectedAmount, expectedAmount) ||
                other.expectedAmount == expectedAmount) &&
            (identical(other.actualAmount, actualAmount) ||
                other.actualAmount == actualAmount) &&
            (identical(other.confirmedAmount, confirmedAmount) ||
                other.confirmedAmount == confirmedAmount) &&
            (identical(other.statusString, statusString) ||
                other.statusString == statusString) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._denominations, _denominations) &&
            (identical(other.submittedBy, submittedBy) ||
                other.submittedBy == submittedBy) &&
            (identical(other.submittedByName, submittedByName) ||
                other.submittedByName == submittedByName) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.collectedBy, collectedBy) ||
                other.collectedBy == collectedBy) &&
            (identical(other.collectedByName, collectedByName) ||
                other.collectedByName == collectedByName) &&
            (identical(other.collectedAt, collectedAt) ||
                other.collectedAt == collectedAt) &&
            (identical(other.confirmedBy, confirmedBy) ||
                other.confirmedBy == confirmedBy) &&
            (identical(other.confirmedByName, confirmedByName) ||
                other.confirmedByName == confirmedByName) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.disputeReason, disputeReason) ||
                other.disputeReason == disputeReason) &&
            (identical(other.disputedBy, disputedBy) ||
                other.disputedBy == disputedBy) &&
            (identical(other.disputedAt, disputedAt) ||
                other.disputedAt == disputedAt) &&
            (identical(other.disputeResolution, disputeResolution) ||
                other.disputeResolution == disputeResolution) &&
            (identical(other.syncedAt, syncedAt) ||
                other.syncedAt == syncedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        organizationId,
        collectionNumber,
        shopId,
        shopName,
        currencyCode,
        expectedAmount,
        actualAmount,
        confirmedAmount,
        statusString,
        notes,
        const DeepCollectionEquality().hash(_denominations),
        submittedBy,
        submittedByName,
        submittedAt,
        collectedBy,
        collectedByName,
        collectedAt,
        confirmedBy,
        confirmedByName,
        confirmedAt,
        disputeReason,
        disputedBy,
        disputedAt,
        disputeResolution,
        syncedAt,
        isSynced
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CashCollectionModelImplCopyWith<_$CashCollectionModelImpl> get copyWith =>
      __$$CashCollectionModelImplCopyWithImpl<_$CashCollectionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashCollectionModelImplToJson(
      this,
    );
  }
}

abstract class _CashCollectionModel extends CashCollectionModel {
  const factory _CashCollectionModel(
      {required final String id,
      required final String organizationId,
      required final String collectionNumber,
      required final String shopId,
      required final String shopName,
      @JsonKey(name: 'currency') final String currencyCode,
      required final double expectedAmount,
      required final double actualAmount,
      final double? confirmedAmount,
      @JsonKey(name: 'status') required final String statusString,
      final String? notes,
      final Map<String, int> denominations,
      required final String submittedBy,
      required final String submittedByName,
      required final DateTime submittedAt,
      final String? collectedBy,
      final String? collectedByName,
      final DateTime? collectedAt,
      final String? confirmedBy,
      final String? confirmedByName,
      final DateTime? confirmedAt,
      final String? disputeReason,
      final String? disputedBy,
      final DateTime? disputedAt,
      final String? disputeResolution,
      final DateTime? syncedAt,
      final bool isSynced}) = _$CashCollectionModelImpl;
  const _CashCollectionModel._() : super._();

  factory _CashCollectionModel.fromJson(Map<String, dynamic> json) =
      _$CashCollectionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get collectionNumber;
  @override
  String get shopId;
  @override
  String get shopName;
  @override
  @JsonKey(name: 'currency')
  String get currencyCode;
  @override
  double get expectedAmount;
  @override
  double get actualAmount;
  @override
  double? get confirmedAmount;
  @override
  @JsonKey(name: 'status')
  String get statusString;
  @override
  String? get notes;
  @override // Denominations breakdown
  Map<String, int> get denominations;
  @override // Submitted by (cashier)
  String get submittedBy;
  @override
  String get submittedByName;
  @override
  DateTime get submittedAt;
  @override // Collected by (manager/collector)
  String? get collectedBy;
  @override
  String? get collectedByName;
  @override
  DateTime? get collectedAt;
  @override // Confirmed by (admin/accountant)
  String? get confirmedBy;
  @override
  String? get confirmedByName;
  @override
  DateTime? get confirmedAt;
  @override // Dispute
  String? get disputeReason;
  @override
  String? get disputedBy;
  @override
  DateTime? get disputedAt;
  @override
  String? get disputeResolution;
  @override // Sync
  DateTime? get syncedAt;
  @override
  bool get isSynced;
  @override
  @JsonKey(ignore: true)
  _$$CashCollectionModelImplCopyWith<_$CashCollectionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashCollectionSummary _$CashCollectionSummaryFromJson(
    Map<String, dynamic> json) {
  return _CashCollectionSummary.fromJson(json);
}

/// @nodoc
mixin _$CashCollectionSummary {
  DateTime get date => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get shopName => throw _privateConstructorUsedError;
  int get totalCollections => throw _privateConstructorUsedError;
  double get totalExpected => throw _privateConstructorUsedError;
  double get totalActual => throw _privateConstructorUsedError;
  double get totalVariance => throw _privateConstructorUsedError;
  int get shortageCount => throw _privateConstructorUsedError;
  int get overageCount => throw _privateConstructorUsedError;
  int get matchCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CashCollectionSummaryCopyWith<CashCollectionSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashCollectionSummaryCopyWith<$Res> {
  factory $CashCollectionSummaryCopyWith(CashCollectionSummary value,
          $Res Function(CashCollectionSummary) then) =
      _$CashCollectionSummaryCopyWithImpl<$Res, CashCollectionSummary>;
  @useResult
  $Res call(
      {DateTime date,
      String shopId,
      String shopName,
      int totalCollections,
      double totalExpected,
      double totalActual,
      double totalVariance,
      int shortageCount,
      int overageCount,
      int matchCount});
}

/// @nodoc
class _$CashCollectionSummaryCopyWithImpl<$Res,
        $Val extends CashCollectionSummary>
    implements $CashCollectionSummaryCopyWith<$Res> {
  _$CashCollectionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? shopId = null,
    Object? shopName = null,
    Object? totalCollections = null,
    Object? totalExpected = null,
    Object? totalActual = null,
    Object? totalVariance = null,
    Object? shortageCount = null,
    Object? overageCount = null,
    Object? matchCount = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      totalCollections: null == totalCollections
          ? _value.totalCollections
          : totalCollections // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpected: null == totalExpected
          ? _value.totalExpected
          : totalExpected // ignore: cast_nullable_to_non_nullable
              as double,
      totalActual: null == totalActual
          ? _value.totalActual
          : totalActual // ignore: cast_nullable_to_non_nullable
              as double,
      totalVariance: null == totalVariance
          ? _value.totalVariance
          : totalVariance // ignore: cast_nullable_to_non_nullable
              as double,
      shortageCount: null == shortageCount
          ? _value.shortageCount
          : shortageCount // ignore: cast_nullable_to_non_nullable
              as int,
      overageCount: null == overageCount
          ? _value.overageCount
          : overageCount // ignore: cast_nullable_to_non_nullable
              as int,
      matchCount: null == matchCount
          ? _value.matchCount
          : matchCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashCollectionSummaryImplCopyWith<$Res>
    implements $CashCollectionSummaryCopyWith<$Res> {
  factory _$$CashCollectionSummaryImplCopyWith(
          _$CashCollectionSummaryImpl value,
          $Res Function(_$CashCollectionSummaryImpl) then) =
      __$$CashCollectionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      String shopId,
      String shopName,
      int totalCollections,
      double totalExpected,
      double totalActual,
      double totalVariance,
      int shortageCount,
      int overageCount,
      int matchCount});
}

/// @nodoc
class __$$CashCollectionSummaryImplCopyWithImpl<$Res>
    extends _$CashCollectionSummaryCopyWithImpl<$Res,
        _$CashCollectionSummaryImpl>
    implements _$$CashCollectionSummaryImplCopyWith<$Res> {
  __$$CashCollectionSummaryImplCopyWithImpl(_$CashCollectionSummaryImpl _value,
      $Res Function(_$CashCollectionSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? shopId = null,
    Object? shopName = null,
    Object? totalCollections = null,
    Object? totalExpected = null,
    Object? totalActual = null,
    Object? totalVariance = null,
    Object? shortageCount = null,
    Object? overageCount = null,
    Object? matchCount = null,
  }) {
    return _then(_$CashCollectionSummaryImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      totalCollections: null == totalCollections
          ? _value.totalCollections
          : totalCollections // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpected: null == totalExpected
          ? _value.totalExpected
          : totalExpected // ignore: cast_nullable_to_non_nullable
              as double,
      totalActual: null == totalActual
          ? _value.totalActual
          : totalActual // ignore: cast_nullable_to_non_nullable
              as double,
      totalVariance: null == totalVariance
          ? _value.totalVariance
          : totalVariance // ignore: cast_nullable_to_non_nullable
              as double,
      shortageCount: null == shortageCount
          ? _value.shortageCount
          : shortageCount // ignore: cast_nullable_to_non_nullable
              as int,
      overageCount: null == overageCount
          ? _value.overageCount
          : overageCount // ignore: cast_nullable_to_non_nullable
              as int,
      matchCount: null == matchCount
          ? _value.matchCount
          : matchCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashCollectionSummaryImpl implements _CashCollectionSummary {
  const _$CashCollectionSummaryImpl(
      {required this.date,
      required this.shopId,
      required this.shopName,
      required this.totalCollections,
      required this.totalExpected,
      required this.totalActual,
      required this.totalVariance,
      required this.shortageCount,
      required this.overageCount,
      required this.matchCount});

  factory _$CashCollectionSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashCollectionSummaryImplFromJson(json);

  @override
  final DateTime date;
  @override
  final String shopId;
  @override
  final String shopName;
  @override
  final int totalCollections;
  @override
  final double totalExpected;
  @override
  final double totalActual;
  @override
  final double totalVariance;
  @override
  final int shortageCount;
  @override
  final int overageCount;
  @override
  final int matchCount;

  @override
  String toString() {
    return 'CashCollectionSummary(date: $date, shopId: $shopId, shopName: $shopName, totalCollections: $totalCollections, totalExpected: $totalExpected, totalActual: $totalActual, totalVariance: $totalVariance, shortageCount: $shortageCount, overageCount: $overageCount, matchCount: $matchCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashCollectionSummaryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.totalCollections, totalCollections) ||
                other.totalCollections == totalCollections) &&
            (identical(other.totalExpected, totalExpected) ||
                other.totalExpected == totalExpected) &&
            (identical(other.totalActual, totalActual) ||
                other.totalActual == totalActual) &&
            (identical(other.totalVariance, totalVariance) ||
                other.totalVariance == totalVariance) &&
            (identical(other.shortageCount, shortageCount) ||
                other.shortageCount == shortageCount) &&
            (identical(other.overageCount, overageCount) ||
                other.overageCount == overageCount) &&
            (identical(other.matchCount, matchCount) ||
                other.matchCount == matchCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      shopId,
      shopName,
      totalCollections,
      totalExpected,
      totalActual,
      totalVariance,
      shortageCount,
      overageCount,
      matchCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CashCollectionSummaryImplCopyWith<_$CashCollectionSummaryImpl>
      get copyWith => __$$CashCollectionSummaryImplCopyWithImpl<
          _$CashCollectionSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashCollectionSummaryImplToJson(
      this,
    );
  }
}

abstract class _CashCollectionSummary implements CashCollectionSummary {
  const factory _CashCollectionSummary(
      {required final DateTime date,
      required final String shopId,
      required final String shopName,
      required final int totalCollections,
      required final double totalExpected,
      required final double totalActual,
      required final double totalVariance,
      required final int shortageCount,
      required final int overageCount,
      required final int matchCount}) = _$CashCollectionSummaryImpl;

  factory _CashCollectionSummary.fromJson(Map<String, dynamic> json) =
      _$CashCollectionSummaryImpl.fromJson;

  @override
  DateTime get date;
  @override
  String get shopId;
  @override
  String get shopName;
  @override
  int get totalCollections;
  @override
  double get totalExpected;
  @override
  double get totalActual;
  @override
  double get totalVariance;
  @override
  int get shortageCount;
  @override
  int get overageCount;
  @override
  int get matchCount;
  @override
  @JsonKey(ignore: true)
  _$$CashCollectionSummaryImplCopyWith<_$CashCollectionSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
