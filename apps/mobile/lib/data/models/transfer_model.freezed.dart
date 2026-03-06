// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferModel _$TransferModelFromJson(Map<String, dynamic> json) {
  return _TransferModel.fromJson(json);
}

/// @nodoc
mixin _$TransferModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get transferNumber => throw _privateConstructorUsedError;
  String get sourceShopId => throw _privateConstructorUsedError;
  String get sourceShopName => throw _privateConstructorUsedError;
  String get destinationShopId => throw _privateConstructorUsedError;
  String get destinationShopName => throw _privateConstructorUsedError;
  List<TransferItemModel> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get statusString => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // Created by
  String get createdBy => throw _privateConstructorUsedError;
  String get createdByName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError; // Dispatched
  String? get dispatchedBy => throw _privateConstructorUsedError;
  String? get dispatchedByName => throw _privateConstructorUsedError;
  DateTime? get dispatchedAt => throw _privateConstructorUsedError; // Received
  String? get receivedBy => throw _privateConstructorUsedError;
  String? get receivedByName => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError; // Confirmed
  String? get confirmedBy => throw _privateConstructorUsedError;
  String? get confirmedByName => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError; // Rejection
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get rejectedBy => throw _privateConstructorUsedError;
  DateTime? get rejectedAt =>
      throw _privateConstructorUsedError; // Approved (by manager/owner)
  String? get approvedBy => throw _privateConstructorUsedError;
  String? get approvedByName => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError; // Sync
  DateTime? get syncedAt => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferModelCopyWith<TransferModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferModelCopyWith<$Res> {
  factory $TransferModelCopyWith(
          TransferModel value, $Res Function(TransferModel) then) =
      _$TransferModelCopyWithImpl<$Res, TransferModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String transferNumber,
      String sourceShopId,
      String sourceShopName,
      String destinationShopId,
      String destinationShopName,
      List<TransferItemModel> items,
      @JsonKey(name: 'status') String statusString,
      String? notes,
      String createdBy,
      String createdByName,
      DateTime createdAt,
      String? dispatchedBy,
      String? dispatchedByName,
      DateTime? dispatchedAt,
      String? receivedBy,
      String? receivedByName,
      DateTime? receivedAt,
      String? confirmedBy,
      String? confirmedByName,
      DateTime? confirmedAt,
      String? rejectionReason,
      String? rejectedBy,
      DateTime? rejectedAt,
      String? approvedBy,
      String? approvedByName,
      DateTime? approvedAt,
      DateTime? syncedAt,
      bool isSynced});
}

/// @nodoc
class _$TransferModelCopyWithImpl<$Res, $Val extends TransferModel>
    implements $TransferModelCopyWith<$Res> {
  _$TransferModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? transferNumber = null,
    Object? sourceShopId = null,
    Object? sourceShopName = null,
    Object? destinationShopId = null,
    Object? destinationShopName = null,
    Object? items = null,
    Object? statusString = null,
    Object? notes = freezed,
    Object? createdBy = null,
    Object? createdByName = null,
    Object? createdAt = null,
    Object? dispatchedBy = freezed,
    Object? dispatchedByName = freezed,
    Object? dispatchedAt = freezed,
    Object? receivedBy = freezed,
    Object? receivedByName = freezed,
    Object? receivedAt = freezed,
    Object? confirmedBy = freezed,
    Object? confirmedByName = freezed,
    Object? confirmedAt = freezed,
    Object? rejectionReason = freezed,
    Object? rejectedBy = freezed,
    Object? rejectedAt = freezed,
    Object? approvedBy = freezed,
    Object? approvedByName = freezed,
    Object? approvedAt = freezed,
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
      transferNumber: null == transferNumber
          ? _value.transferNumber
          : transferNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sourceShopId: null == sourceShopId
          ? _value.sourceShopId
          : sourceShopId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceShopName: null == sourceShopName
          ? _value.sourceShopName
          : sourceShopName // ignore: cast_nullable_to_non_nullable
              as String,
      destinationShopId: null == destinationShopId
          ? _value.destinationShopId
          : destinationShopId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationShopName: null == destinationShopName
          ? _value.destinationShopName
          : destinationShopName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransferItemModel>,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dispatchedBy: freezed == dispatchedBy
          ? _value.dispatchedBy
          : dispatchedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      dispatchedByName: freezed == dispatchedByName
          ? _value.dispatchedByName
          : dispatchedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      dispatchedAt: freezed == dispatchedAt
          ? _value.dispatchedAt
          : dispatchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      receivedBy: freezed == receivedBy
          ? _value.receivedBy
          : receivedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedByName: freezed == receivedByName
          ? _value.receivedByName
          : receivedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
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
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedBy: freezed == rejectedBy
          ? _value.rejectedBy
          : rejectedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedByName: freezed == approvedByName
          ? _value.approvedByName
          : approvedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$TransferModelImplCopyWith<$Res>
    implements $TransferModelCopyWith<$Res> {
  factory _$$TransferModelImplCopyWith(
          _$TransferModelImpl value, $Res Function(_$TransferModelImpl) then) =
      __$$TransferModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String transferNumber,
      String sourceShopId,
      String sourceShopName,
      String destinationShopId,
      String destinationShopName,
      List<TransferItemModel> items,
      @JsonKey(name: 'status') String statusString,
      String? notes,
      String createdBy,
      String createdByName,
      DateTime createdAt,
      String? dispatchedBy,
      String? dispatchedByName,
      DateTime? dispatchedAt,
      String? receivedBy,
      String? receivedByName,
      DateTime? receivedAt,
      String? confirmedBy,
      String? confirmedByName,
      DateTime? confirmedAt,
      String? rejectionReason,
      String? rejectedBy,
      DateTime? rejectedAt,
      String? approvedBy,
      String? approvedByName,
      DateTime? approvedAt,
      DateTime? syncedAt,
      bool isSynced});
}

/// @nodoc
class __$$TransferModelImplCopyWithImpl<$Res>
    extends _$TransferModelCopyWithImpl<$Res, _$TransferModelImpl>
    implements _$$TransferModelImplCopyWith<$Res> {
  __$$TransferModelImplCopyWithImpl(
      _$TransferModelImpl _value, $Res Function(_$TransferModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? transferNumber = null,
    Object? sourceShopId = null,
    Object? sourceShopName = null,
    Object? destinationShopId = null,
    Object? destinationShopName = null,
    Object? items = null,
    Object? statusString = null,
    Object? notes = freezed,
    Object? createdBy = null,
    Object? createdByName = null,
    Object? createdAt = null,
    Object? dispatchedBy = freezed,
    Object? dispatchedByName = freezed,
    Object? dispatchedAt = freezed,
    Object? receivedBy = freezed,
    Object? receivedByName = freezed,
    Object? receivedAt = freezed,
    Object? confirmedBy = freezed,
    Object? confirmedByName = freezed,
    Object? confirmedAt = freezed,
    Object? rejectionReason = freezed,
    Object? rejectedBy = freezed,
    Object? rejectedAt = freezed,
    Object? approvedBy = freezed,
    Object? approvedByName = freezed,
    Object? approvedAt = freezed,
    Object? syncedAt = freezed,
    Object? isSynced = null,
  }) {
    return _then(_$TransferModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      transferNumber: null == transferNumber
          ? _value.transferNumber
          : transferNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sourceShopId: null == sourceShopId
          ? _value.sourceShopId
          : sourceShopId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceShopName: null == sourceShopName
          ? _value.sourceShopName
          : sourceShopName // ignore: cast_nullable_to_non_nullable
              as String,
      destinationShopId: null == destinationShopId
          ? _value.destinationShopId
          : destinationShopId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationShopName: null == destinationShopName
          ? _value.destinationShopName
          : destinationShopName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransferItemModel>,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dispatchedBy: freezed == dispatchedBy
          ? _value.dispatchedBy
          : dispatchedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      dispatchedByName: freezed == dispatchedByName
          ? _value.dispatchedByName
          : dispatchedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      dispatchedAt: freezed == dispatchedAt
          ? _value.dispatchedAt
          : dispatchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      receivedBy: freezed == receivedBy
          ? _value.receivedBy
          : receivedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedByName: freezed == receivedByName
          ? _value.receivedByName
          : receivedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
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
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedBy: freezed == rejectedBy
          ? _value.rejectedBy
          : rejectedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedByName: freezed == approvedByName
          ? _value.approvedByName
          : approvedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$TransferModelImpl extends _TransferModel {
  const _$TransferModelImpl(
      {required this.id,
      required this.organizationId,
      required this.transferNumber,
      required this.sourceShopId,
      required this.sourceShopName,
      required this.destinationShopId,
      required this.destinationShopName,
      required final List<TransferItemModel> items,
      @JsonKey(name: 'status') required this.statusString,
      this.notes,
      required this.createdBy,
      required this.createdByName,
      required this.createdAt,
      this.dispatchedBy,
      this.dispatchedByName,
      this.dispatchedAt,
      this.receivedBy,
      this.receivedByName,
      this.receivedAt,
      this.confirmedBy,
      this.confirmedByName,
      this.confirmedAt,
      this.rejectionReason,
      this.rejectedBy,
      this.rejectedAt,
      this.approvedBy,
      this.approvedByName,
      this.approvedAt,
      this.syncedAt,
      this.isSynced = false})
      : _items = items,
        super._();

  factory _$TransferModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String transferNumber;
  @override
  final String sourceShopId;
  @override
  final String sourceShopName;
  @override
  final String destinationShopId;
  @override
  final String destinationShopName;
  final List<TransferItemModel> _items;
  @override
  List<TransferItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'status')
  final String statusString;
  @override
  final String? notes;
// Created by
  @override
  final String createdBy;
  @override
  final String createdByName;
  @override
  final DateTime createdAt;
// Dispatched
  @override
  final String? dispatchedBy;
  @override
  final String? dispatchedByName;
  @override
  final DateTime? dispatchedAt;
// Received
  @override
  final String? receivedBy;
  @override
  final String? receivedByName;
  @override
  final DateTime? receivedAt;
// Confirmed
  @override
  final String? confirmedBy;
  @override
  final String? confirmedByName;
  @override
  final DateTime? confirmedAt;
// Rejection
  @override
  final String? rejectionReason;
  @override
  final String? rejectedBy;
  @override
  final DateTime? rejectedAt;
// Approved (by manager/owner)
  @override
  final String? approvedBy;
  @override
  final String? approvedByName;
  @override
  final DateTime? approvedAt;
// Sync
  @override
  final DateTime? syncedAt;
  @override
  @JsonKey()
  final bool isSynced;

  @override
  String toString() {
    return 'TransferModel(id: $id, organizationId: $organizationId, transferNumber: $transferNumber, sourceShopId: $sourceShopId, sourceShopName: $sourceShopName, destinationShopId: $destinationShopId, destinationShopName: $destinationShopName, items: $items, statusString: $statusString, notes: $notes, createdBy: $createdBy, createdByName: $createdByName, createdAt: $createdAt, dispatchedBy: $dispatchedBy, dispatchedByName: $dispatchedByName, dispatchedAt: $dispatchedAt, receivedBy: $receivedBy, receivedByName: $receivedByName, receivedAt: $receivedAt, confirmedBy: $confirmedBy, confirmedByName: $confirmedByName, confirmedAt: $confirmedAt, rejectionReason: $rejectionReason, rejectedBy: $rejectedBy, rejectedAt: $rejectedAt, approvedBy: $approvedBy, approvedByName: $approvedByName, approvedAt: $approvedAt, syncedAt: $syncedAt, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.transferNumber, transferNumber) ||
                other.transferNumber == transferNumber) &&
            (identical(other.sourceShopId, sourceShopId) ||
                other.sourceShopId == sourceShopId) &&
            (identical(other.sourceShopName, sourceShopName) ||
                other.sourceShopName == sourceShopName) &&
            (identical(other.destinationShopId, destinationShopId) ||
                other.destinationShopId == destinationShopId) &&
            (identical(other.destinationShopName, destinationShopName) ||
                other.destinationShopName == destinationShopName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.statusString, statusString) ||
                other.statusString == statusString) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.dispatchedBy, dispatchedBy) ||
                other.dispatchedBy == dispatchedBy) &&
            (identical(other.dispatchedByName, dispatchedByName) ||
                other.dispatchedByName == dispatchedByName) &&
            (identical(other.dispatchedAt, dispatchedAt) ||
                other.dispatchedAt == dispatchedAt) &&
            (identical(other.receivedBy, receivedBy) ||
                other.receivedBy == receivedBy) &&
            (identical(other.receivedByName, receivedByName) ||
                other.receivedByName == receivedByName) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.confirmedBy, confirmedBy) ||
                other.confirmedBy == confirmedBy) &&
            (identical(other.confirmedByName, confirmedByName) ||
                other.confirmedByName == confirmedByName) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.rejectedBy, rejectedBy) ||
                other.rejectedBy == rejectedBy) &&
            (identical(other.rejectedAt, rejectedAt) ||
                other.rejectedAt == rejectedAt) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedByName, approvedByName) ||
                other.approvedByName == approvedByName) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
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
        transferNumber,
        sourceShopId,
        sourceShopName,
        destinationShopId,
        destinationShopName,
        const DeepCollectionEquality().hash(_items),
        statusString,
        notes,
        createdBy,
        createdByName,
        createdAt,
        dispatchedBy,
        dispatchedByName,
        dispatchedAt,
        receivedBy,
        receivedByName,
        receivedAt,
        confirmedBy,
        confirmedByName,
        confirmedAt,
        rejectionReason,
        rejectedBy,
        rejectedAt,
        approvedBy,
        approvedByName,
        approvedAt,
        syncedAt,
        isSynced
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferModelImplCopyWith<_$TransferModelImpl> get copyWith =>
      __$$TransferModelImplCopyWithImpl<_$TransferModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferModelImplToJson(
      this,
    );
  }
}

abstract class _TransferModel extends TransferModel {
  const factory _TransferModel(
      {required final String id,
      required final String organizationId,
      required final String transferNumber,
      required final String sourceShopId,
      required final String sourceShopName,
      required final String destinationShopId,
      required final String destinationShopName,
      required final List<TransferItemModel> items,
      @JsonKey(name: 'status') required final String statusString,
      final String? notes,
      required final String createdBy,
      required final String createdByName,
      required final DateTime createdAt,
      final String? dispatchedBy,
      final String? dispatchedByName,
      final DateTime? dispatchedAt,
      final String? receivedBy,
      final String? receivedByName,
      final DateTime? receivedAt,
      final String? confirmedBy,
      final String? confirmedByName,
      final DateTime? confirmedAt,
      final String? rejectionReason,
      final String? rejectedBy,
      final DateTime? rejectedAt,
      final String? approvedBy,
      final String? approvedByName,
      final DateTime? approvedAt,
      final DateTime? syncedAt,
      final bool isSynced}) = _$TransferModelImpl;
  const _TransferModel._() : super._();

  factory _TransferModel.fromJson(Map<String, dynamic> json) =
      _$TransferModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get transferNumber;
  @override
  String get sourceShopId;
  @override
  String get sourceShopName;
  @override
  String get destinationShopId;
  @override
  String get destinationShopName;
  @override
  List<TransferItemModel> get items;
  @override
  @JsonKey(name: 'status')
  String get statusString;
  @override
  String? get notes;
  @override // Created by
  String get createdBy;
  @override
  String get createdByName;
  @override
  DateTime get createdAt;
  @override // Dispatched
  String? get dispatchedBy;
  @override
  String? get dispatchedByName;
  @override
  DateTime? get dispatchedAt;
  @override // Received
  String? get receivedBy;
  @override
  String? get receivedByName;
  @override
  DateTime? get receivedAt;
  @override // Confirmed
  String? get confirmedBy;
  @override
  String? get confirmedByName;
  @override
  DateTime? get confirmedAt;
  @override // Rejection
  String? get rejectionReason;
  @override
  String? get rejectedBy;
  @override
  DateTime? get rejectedAt;
  @override // Approved (by manager/owner)
  String? get approvedBy;
  @override
  String? get approvedByName;
  @override
  DateTime? get approvedAt;
  @override // Sync
  DateTime? get syncedAt;
  @override
  bool get isSynced;
  @override
  @JsonKey(ignore: true)
  _$$TransferModelImplCopyWith<_$TransferModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferItemModel _$TransferItemModelFromJson(Map<String, dynamic> json) {
  return _TransferItemModel.fromJson(json);
}

/// @nodoc
mixin _$TransferItemModel {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitCost => throw _privateConstructorUsedError;
  int? get receivedQuantity => throw _privateConstructorUsedError;
  String? get receivedNotes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferItemModelCopyWith<TransferItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferItemModelCopyWith<$Res> {
  factory $TransferItemModelCopyWith(
          TransferItemModel value, $Res Function(TransferItemModel) then) =
      _$TransferItemModelCopyWithImpl<$Res, TransferItemModel>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? barcode,
      int quantity,
      double unitCost,
      int? receivedQuantity,
      String? receivedNotes});
}

/// @nodoc
class _$TransferItemModelCopyWithImpl<$Res, $Val extends TransferItemModel>
    implements $TransferItemModelCopyWith<$Res> {
  _$TransferItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? quantity = null,
    Object? unitCost = null,
    Object? receivedQuantity = freezed,
    Object? receivedNotes = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      receivedQuantity: freezed == receivedQuantity
          ? _value.receivedQuantity
          : receivedQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      receivedNotes: freezed == receivedNotes
          ? _value.receivedNotes
          : receivedNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferItemModelImplCopyWith<$Res>
    implements $TransferItemModelCopyWith<$Res> {
  factory _$$TransferItemModelImplCopyWith(_$TransferItemModelImpl value,
          $Res Function(_$TransferItemModelImpl) then) =
      __$$TransferItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? barcode,
      int quantity,
      double unitCost,
      int? receivedQuantity,
      String? receivedNotes});
}

/// @nodoc
class __$$TransferItemModelImplCopyWithImpl<$Res>
    extends _$TransferItemModelCopyWithImpl<$Res, _$TransferItemModelImpl>
    implements _$$TransferItemModelImplCopyWith<$Res> {
  __$$TransferItemModelImplCopyWithImpl(_$TransferItemModelImpl _value,
      $Res Function(_$TransferItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? quantity = null,
    Object? unitCost = null,
    Object? receivedQuantity = freezed,
    Object? receivedNotes = freezed,
  }) {
    return _then(_$TransferItemModelImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      receivedQuantity: freezed == receivedQuantity
          ? _value.receivedQuantity
          : receivedQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      receivedNotes: freezed == receivedNotes
          ? _value.receivedNotes
          : receivedNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferItemModelImpl extends _TransferItemModel {
  const _$TransferItemModelImpl(
      {required this.productId,
      required this.productName,
      this.sku,
      this.barcode,
      required this.quantity,
      required this.unitCost,
      this.receivedQuantity,
      this.receivedNotes})
      : super._();

  factory _$TransferItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferItemModelImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;
  @override
  final String? barcode;
  @override
  final int quantity;
  @override
  final double unitCost;
  @override
  final int? receivedQuantity;
  @override
  final String? receivedNotes;

  @override
  String toString() {
    return 'TransferItemModel(productId: $productId, productName: $productName, sku: $sku, barcode: $barcode, quantity: $quantity, unitCost: $unitCost, receivedQuantity: $receivedQuantity, receivedNotes: $receivedNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferItemModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitCost, unitCost) ||
                other.unitCost == unitCost) &&
            (identical(other.receivedQuantity, receivedQuantity) ||
                other.receivedQuantity == receivedQuantity) &&
            (identical(other.receivedNotes, receivedNotes) ||
                other.receivedNotes == receivedNotes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName, sku,
      barcode, quantity, unitCost, receivedQuantity, receivedNotes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferItemModelImplCopyWith<_$TransferItemModelImpl> get copyWith =>
      __$$TransferItemModelImplCopyWithImpl<_$TransferItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferItemModelImplToJson(
      this,
    );
  }
}

abstract class _TransferItemModel extends TransferItemModel {
  const factory _TransferItemModel(
      {required final String productId,
      required final String productName,
      final String? sku,
      final String? barcode,
      required final int quantity,
      required final double unitCost,
      final int? receivedQuantity,
      final String? receivedNotes}) = _$TransferItemModelImpl;
  const _TransferItemModel._() : super._();

  factory _TransferItemModel.fromJson(Map<String, dynamic> json) =
      _$TransferItemModelImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;
  @override
  String? get barcode;
  @override
  int get quantity;
  @override
  double get unitCost;
  @override
  int? get receivedQuantity;
  @override
  String? get receivedNotes;
  @override
  @JsonKey(ignore: true)
  _$$TransferItemModelImplCopyWith<_$TransferItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
