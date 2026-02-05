// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) {
  return _ShopModel.fromJson(json);
}

/// @nodoc
mixin _$ShopModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isHeadOffice => throw _privateConstructorUsedError;
  String? get managerId => throw _privateConstructorUsedError;
  String? get managerName => throw _privateConstructorUsedError;
  List<String> get assignedUserIds => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShopModelCopyWith<ShopModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopModelCopyWith<$Res> {
  factory $ShopModelCopyWith(ShopModel value, $Res Function(ShopModel) then) =
      _$ShopModelCopyWithImpl<$Res, ShopModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String name,
      String? code,
      String? address,
      String? city,
      String? phone,
      String? email,
      bool isActive,
      bool isHeadOffice,
      String? managerId,
      String? managerName,
      List<String> assignedUserIds,
      DateTime createdAt,
      DateTime? updatedAt,
      Map<String, dynamic> settings});
}

/// @nodoc
class _$ShopModelCopyWithImpl<$Res, $Val extends ShopModel>
    implements $ShopModelCopyWith<$Res> {
  _$ShopModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? name = null,
    Object? code = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? isActive = null,
    Object? isHeadOffice = null,
    Object? managerId = freezed,
    Object? managerName = freezed,
    Object? assignedUserIds = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? settings = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isHeadOffice: null == isHeadOffice
          ? _value.isHeadOffice
          : isHeadOffice // ignore: cast_nullable_to_non_nullable
              as bool,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedUserIds: null == assignedUserIds
          ? _value.assignedUserIds
          : assignedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShopModelImplCopyWith<$Res>
    implements $ShopModelCopyWith<$Res> {
  factory _$$ShopModelImplCopyWith(
          _$ShopModelImpl value, $Res Function(_$ShopModelImpl) then) =
      __$$ShopModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String name,
      String? code,
      String? address,
      String? city,
      String? phone,
      String? email,
      bool isActive,
      bool isHeadOffice,
      String? managerId,
      String? managerName,
      List<String> assignedUserIds,
      DateTime createdAt,
      DateTime? updatedAt,
      Map<String, dynamic> settings});
}

/// @nodoc
class __$$ShopModelImplCopyWithImpl<$Res>
    extends _$ShopModelCopyWithImpl<$Res, _$ShopModelImpl>
    implements _$$ShopModelImplCopyWith<$Res> {
  __$$ShopModelImplCopyWithImpl(
      _$ShopModelImpl _value, $Res Function(_$ShopModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? name = null,
    Object? code = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? isActive = null,
    Object? isHeadOffice = null,
    Object? managerId = freezed,
    Object? managerName = freezed,
    Object? assignedUserIds = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? settings = null,
  }) {
    return _then(_$ShopModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isHeadOffice: null == isHeadOffice
          ? _value.isHeadOffice
          : isHeadOffice // ignore: cast_nullable_to_non_nullable
              as bool,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedUserIds: null == assignedUserIds
          ? _value._assignedUserIds
          : assignedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopModelImpl extends _ShopModel {
  const _$ShopModelImpl(
      {required this.id,
      required this.organizationId,
      required this.name,
      this.code,
      this.address,
      this.city,
      this.phone,
      this.email,
      this.isActive = true,
      this.isHeadOffice = false,
      this.managerId,
      this.managerName,
      final List<String> assignedUserIds = const [],
      required this.createdAt,
      this.updatedAt,
      final Map<String, dynamic> settings = const {}})
      : _assignedUserIds = assignedUserIds,
        _settings = settings,
        super._();

  factory _$ShopModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String name;
  @override
  final String? code;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isHeadOffice;
  @override
  final String? managerId;
  @override
  final String? managerName;
  final List<String> _assignedUserIds;
  @override
  @JsonKey()
  List<String> get assignedUserIds {
    if (_assignedUserIds is EqualUnmodifiableListView) return _assignedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedUserIds);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  @override
  String toString() {
    return 'ShopModel(id: $id, organizationId: $organizationId, name: $name, code: $code, address: $address, city: $city, phone: $phone, email: $email, isActive: $isActive, isHeadOffice: $isHeadOffice, managerId: $managerId, managerName: $managerName, assignedUserIds: $assignedUserIds, createdAt: $createdAt, updatedAt: $updatedAt, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isHeadOffice, isHeadOffice) ||
                other.isHeadOffice == isHeadOffice) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName) &&
            const DeepCollectionEquality()
                .equals(other._assignedUserIds, _assignedUserIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      name,
      code,
      address,
      city,
      phone,
      email,
      isActive,
      isHeadOffice,
      managerId,
      managerName,
      const DeepCollectionEquality().hash(_assignedUserIds),
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_settings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopModelImplCopyWith<_$ShopModelImpl> get copyWith =>
      __$$ShopModelImplCopyWithImpl<_$ShopModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopModelImplToJson(
      this,
    );
  }
}

abstract class _ShopModel extends ShopModel {
  const factory _ShopModel(
      {required final String id,
      required final String organizationId,
      required final String name,
      final String? code,
      final String? address,
      final String? city,
      final String? phone,
      final String? email,
      final bool isActive,
      final bool isHeadOffice,
      final String? managerId,
      final String? managerName,
      final List<String> assignedUserIds,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final Map<String, dynamic> settings}) = _$ShopModelImpl;
  const _ShopModel._() : super._();

  factory _ShopModel.fromJson(Map<String, dynamic> json) =
      _$ShopModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get name;
  @override
  String? get code;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  bool get isActive;
  @override
  bool get isHeadOffice;
  @override
  String? get managerId;
  @override
  String? get managerName;
  @override
  List<String> get assignedUserIds;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  Map<String, dynamic> get settings;
  @override
  @JsonKey(ignore: true)
  _$$ShopModelImplCopyWith<_$ShopModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShopInventorySummary _$ShopInventorySummaryFromJson(Map<String, dynamic> json) {
  return _ShopInventorySummary.fromJson(json);
}

/// @nodoc
mixin _$ShopInventorySummary {
  String get shopId => throw _privateConstructorUsedError;
  String get shopName => throw _privateConstructorUsedError;
  int get totalProducts => throw _privateConstructorUsedError;
  int get lowStockCount => throw _privateConstructorUsedError;
  int get outOfStockCount => throw _privateConstructorUsedError;
  double get totalStockValue => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShopInventorySummaryCopyWith<ShopInventorySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopInventorySummaryCopyWith<$Res> {
  factory $ShopInventorySummaryCopyWith(ShopInventorySummary value,
          $Res Function(ShopInventorySummary) then) =
      _$ShopInventorySummaryCopyWithImpl<$Res, ShopInventorySummary>;
  @useResult
  $Res call(
      {String shopId,
      String shopName,
      int totalProducts,
      int lowStockCount,
      int outOfStockCount,
      double totalStockValue,
      DateTime? lastUpdated});
}

/// @nodoc
class _$ShopInventorySummaryCopyWithImpl<$Res,
        $Val extends ShopInventorySummary>
    implements $ShopInventorySummaryCopyWith<$Res> {
  _$ShopInventorySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopId = null,
    Object? shopName = null,
    Object? totalProducts = null,
    Object? lowStockCount = null,
    Object? outOfStockCount = null,
    Object? totalStockValue = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      lowStockCount: null == lowStockCount
          ? _value.lowStockCount
          : lowStockCount // ignore: cast_nullable_to_non_nullable
              as int,
      outOfStockCount: null == outOfStockCount
          ? _value.outOfStockCount
          : outOfStockCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalStockValue: null == totalStockValue
          ? _value.totalStockValue
          : totalStockValue // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShopInventorySummaryImplCopyWith<$Res>
    implements $ShopInventorySummaryCopyWith<$Res> {
  factory _$$ShopInventorySummaryImplCopyWith(_$ShopInventorySummaryImpl value,
          $Res Function(_$ShopInventorySummaryImpl) then) =
      __$$ShopInventorySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shopId,
      String shopName,
      int totalProducts,
      int lowStockCount,
      int outOfStockCount,
      double totalStockValue,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$ShopInventorySummaryImplCopyWithImpl<$Res>
    extends _$ShopInventorySummaryCopyWithImpl<$Res, _$ShopInventorySummaryImpl>
    implements _$$ShopInventorySummaryImplCopyWith<$Res> {
  __$$ShopInventorySummaryImplCopyWithImpl(_$ShopInventorySummaryImpl _value,
      $Res Function(_$ShopInventorySummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopId = null,
    Object? shopName = null,
    Object? totalProducts = null,
    Object? lowStockCount = null,
    Object? outOfStockCount = null,
    Object? totalStockValue = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$ShopInventorySummaryImpl(
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      lowStockCount: null == lowStockCount
          ? _value.lowStockCount
          : lowStockCount // ignore: cast_nullable_to_non_nullable
              as int,
      outOfStockCount: null == outOfStockCount
          ? _value.outOfStockCount
          : outOfStockCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalStockValue: null == totalStockValue
          ? _value.totalStockValue
          : totalStockValue // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopInventorySummaryImpl implements _ShopInventorySummary {
  const _$ShopInventorySummaryImpl(
      {required this.shopId,
      required this.shopName,
      required this.totalProducts,
      required this.lowStockCount,
      required this.outOfStockCount,
      required this.totalStockValue,
      this.lastUpdated});

  factory _$ShopInventorySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopInventorySummaryImplFromJson(json);

  @override
  final String shopId;
  @override
  final String shopName;
  @override
  final int totalProducts;
  @override
  final int lowStockCount;
  @override
  final int outOfStockCount;
  @override
  final double totalStockValue;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'ShopInventorySummary(shopId: $shopId, shopName: $shopName, totalProducts: $totalProducts, lowStockCount: $lowStockCount, outOfStockCount: $outOfStockCount, totalStockValue: $totalStockValue, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopInventorySummaryImpl &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.lowStockCount, lowStockCount) ||
                other.lowStockCount == lowStockCount) &&
            (identical(other.outOfStockCount, outOfStockCount) ||
                other.outOfStockCount == outOfStockCount) &&
            (identical(other.totalStockValue, totalStockValue) ||
                other.totalStockValue == totalStockValue) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, shopId, shopName, totalProducts,
      lowStockCount, outOfStockCount, totalStockValue, lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopInventorySummaryImplCopyWith<_$ShopInventorySummaryImpl>
      get copyWith =>
          __$$ShopInventorySummaryImplCopyWithImpl<_$ShopInventorySummaryImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopInventorySummaryImplToJson(
      this,
    );
  }
}

abstract class _ShopInventorySummary implements ShopInventorySummary {
  const factory _ShopInventorySummary(
      {required final String shopId,
      required final String shopName,
      required final int totalProducts,
      required final int lowStockCount,
      required final int outOfStockCount,
      required final double totalStockValue,
      final DateTime? lastUpdated}) = _$ShopInventorySummaryImpl;

  factory _ShopInventorySummary.fromJson(Map<String, dynamic> json) =
      _$ShopInventorySummaryImpl.fromJson;

  @override
  String get shopId;
  @override
  String get shopName;
  @override
  int get totalProducts;
  @override
  int get lowStockCount;
  @override
  int get outOfStockCount;
  @override
  double get totalStockValue;
  @override
  DateTime? get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$ShopInventorySummaryImplCopyWith<_$ShopInventorySummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
