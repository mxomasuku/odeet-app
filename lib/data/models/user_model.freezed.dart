// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role')
  String get roleString => throw _privateConstructorUsedError;
  List<String> get roles =>
      throw _privateConstructorUsedError; // RBAC roles from custom claims
  List<String>? get shopIds => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      String? phone,
      String? avatarUrl,
      String organizationId,
      @JsonKey(name: 'role') String roleString,
      List<String> roles,
      List<String>? shopIds,
      DateTime? createdAt,
      DateTime? lastLoginAt,
      bool isActive,
      bool isBlocked});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? organizationId = null,
    Object? roleString = null,
    Object? roles = null,
    Object? shopIds = freezed,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
    Object? isActive = null,
    Object? isBlocked = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      roleString: null == roleString
          ? _value.roleString
          : roleString // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      shopIds: freezed == shopIds
          ? _value.shopIds
          : shopIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      String? phone,
      String? avatarUrl,
      String organizationId,
      @JsonKey(name: 'role') String roleString,
      List<String> roles,
      List<String>? shopIds,
      DateTime? createdAt,
      DateTime? lastLoginAt,
      bool isActive,
      bool isBlocked});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? organizationId = null,
    Object? roleString = null,
    Object? roles = null,
    Object? shopIds = freezed,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
    Object? isActive = null,
    Object? isBlocked = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      roleString: null == roleString
          ? _value.roleString
          : roleString // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      shopIds: freezed == shopIds
          ? _value._shopIds
          : shopIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.email,
      required this.name,
      this.phone,
      this.avatarUrl,
      this.organizationId = '',
      @JsonKey(name: 'role') this.roleString = 'shopkeeper',
      final List<String> roles = const <String>[],
      final List<String>? shopIds,
      this.createdAt,
      this.lastLoginAt,
      this.isActive = true,
      this.isBlocked = false})
      : _roles = roles,
        _shopIds = shopIds,
        super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final String organizationId;
  @override
  @JsonKey(name: 'role')
  final String roleString;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

// RBAC roles from custom claims
  final List<String>? _shopIds;
// RBAC roles from custom claims
  @override
  List<String>? get shopIds {
    final value = _shopIds;
    if (value == null) return null;
    if (_shopIds is EqualUnmodifiableListView) return _shopIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastLoginAt;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isBlocked;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, phone: $phone, avatarUrl: $avatarUrl, organizationId: $organizationId, roleString: $roleString, roles: $roles, shopIds: $shopIds, createdAt: $createdAt, lastLoginAt: $lastLoginAt, isActive: $isActive, isBlocked: $isBlocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.roleString, roleString) ||
                other.roleString == roleString) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            const DeepCollectionEquality().equals(other._shopIds, _shopIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      phone,
      avatarUrl,
      organizationId,
      roleString,
      const DeepCollectionEquality().hash(_roles),
      const DeepCollectionEquality().hash(_shopIds),
      createdAt,
      lastLoginAt,
      isActive,
      isBlocked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {required final String id,
      required final String email,
      required final String name,
      final String? phone,
      final String? avatarUrl,
      final String organizationId,
      @JsonKey(name: 'role') final String roleString,
      final List<String> roles,
      final List<String>? shopIds,
      final DateTime? createdAt,
      final DateTime? lastLoginAt,
      final bool isActive,
      final bool isBlocked}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get avatarUrl;
  @override
  String get organizationId;
  @override
  @JsonKey(name: 'role')
  String get roleString;
  @override
  List<String> get roles;
  @override // RBAC roles from custom claims
  List<String>? get shopIds;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastLoginAt;
  @override
  bool get isActive;
  @override
  bool get isBlocked;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) {
  return _OrganizationModel.fromJson(json);
}

/// @nodoc
mixin _$OrganizationModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get ownerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String get currencyCode => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get trialStartDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscriptionTier')
  String? get subscriptionTierString => throw _privateConstructorUsedError;
  DateTime? get subscriptionExpiresAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizationModelCopyWith<OrganizationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationModelCopyWith<$Res> {
  factory $OrganizationModelCopyWith(
          OrganizationModel value, $Res Function(OrganizationModel) then) =
      _$OrganizationModelCopyWithImpl<$Res, OrganizationModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? logoUrl,
      String ownerId,
      String ownerEmail,
      @JsonKey(name: 'currency') String currencyCode,
      String timezone,
      DateTime createdAt,
      DateTime? trialStartDate,
      @JsonKey(name: 'subscriptionTier') String? subscriptionTierString,
      DateTime? subscriptionExpiresAt,
      Map<String, dynamic> settings});
}

/// @nodoc
class _$OrganizationModelCopyWithImpl<$Res, $Val extends OrganizationModel>
    implements $OrganizationModelCopyWith<$Res> {
  _$OrganizationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? ownerId = null,
    Object? ownerEmail = null,
    Object? currencyCode = null,
    Object? timezone = null,
    Object? createdAt = null,
    Object? trialStartDate = freezed,
    Object? subscriptionTierString = freezed,
    Object? subscriptionExpiresAt = freezed,
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerEmail: null == ownerEmail
          ? _value.ownerEmail
          : ownerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      trialStartDate: freezed == trialStartDate
          ? _value.trialStartDate
          : trialStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionTierString: freezed == subscriptionTierString
          ? _value.subscriptionTierString
          : subscriptionTierString // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionExpiresAt: freezed == subscriptionExpiresAt
          ? _value.subscriptionExpiresAt
          : subscriptionExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationModelImplCopyWith<$Res>
    implements $OrganizationModelCopyWith<$Res> {
  factory _$$OrganizationModelImplCopyWith(_$OrganizationModelImpl value,
          $Res Function(_$OrganizationModelImpl) then) =
      __$$OrganizationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? logoUrl,
      String ownerId,
      String ownerEmail,
      @JsonKey(name: 'currency') String currencyCode,
      String timezone,
      DateTime createdAt,
      DateTime? trialStartDate,
      @JsonKey(name: 'subscriptionTier') String? subscriptionTierString,
      DateTime? subscriptionExpiresAt,
      Map<String, dynamic> settings});
}

/// @nodoc
class __$$OrganizationModelImplCopyWithImpl<$Res>
    extends _$OrganizationModelCopyWithImpl<$Res, _$OrganizationModelImpl>
    implements _$$OrganizationModelImplCopyWith<$Res> {
  __$$OrganizationModelImplCopyWithImpl(_$OrganizationModelImpl _value,
      $Res Function(_$OrganizationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? ownerId = null,
    Object? ownerEmail = null,
    Object? currencyCode = null,
    Object? timezone = null,
    Object? createdAt = null,
    Object? trialStartDate = freezed,
    Object? subscriptionTierString = freezed,
    Object? subscriptionExpiresAt = freezed,
    Object? settings = null,
  }) {
    return _then(_$OrganizationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerEmail: null == ownerEmail
          ? _value.ownerEmail
          : ownerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      trialStartDate: freezed == trialStartDate
          ? _value.trialStartDate
          : trialStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionTierString: freezed == subscriptionTierString
          ? _value.subscriptionTierString
          : subscriptionTierString // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionExpiresAt: freezed == subscriptionExpiresAt
          ? _value.subscriptionExpiresAt
          : subscriptionExpiresAt // ignore: cast_nullable_to_non_nullable
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
class _$OrganizationModelImpl extends _OrganizationModel {
  const _$OrganizationModelImpl(
      {required this.id,
      required this.name,
      this.logoUrl,
      this.ownerId = '',
      this.ownerEmail = '',
      @JsonKey(name: 'currency') this.currencyCode = 'USD',
      this.timezone = 'Africa/Harare',
      required this.createdAt,
      this.trialStartDate,
      @JsonKey(name: 'subscriptionTier') this.subscriptionTierString,
      this.subscriptionExpiresAt,
      final Map<String, dynamic> settings = const {}})
      : _settings = settings,
        super._();

  factory _$OrganizationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  @JsonKey()
  final String ownerId;
  @override
  @JsonKey()
  final String ownerEmail;
  @override
  @JsonKey(name: 'currency')
  final String currencyCode;
  @override
  @JsonKey()
  final String timezone;
  @override
  final DateTime createdAt;
  @override
  final DateTime? trialStartDate;
  @override
  @JsonKey(name: 'subscriptionTier')
  final String? subscriptionTierString;
  @override
  final DateTime? subscriptionExpiresAt;
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
    return 'OrganizationModel(id: $id, name: $name, logoUrl: $logoUrl, ownerId: $ownerId, ownerEmail: $ownerEmail, currencyCode: $currencyCode, timezone: $timezone, createdAt: $createdAt, trialStartDate: $trialStartDate, subscriptionTierString: $subscriptionTierString, subscriptionExpiresAt: $subscriptionExpiresAt, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerEmail, ownerEmail) ||
                other.ownerEmail == ownerEmail) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.trialStartDate, trialStartDate) ||
                other.trialStartDate == trialStartDate) &&
            (identical(other.subscriptionTierString, subscriptionTierString) ||
                other.subscriptionTierString == subscriptionTierString) &&
            (identical(other.subscriptionExpiresAt, subscriptionExpiresAt) ||
                other.subscriptionExpiresAt == subscriptionExpiresAt) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      logoUrl,
      ownerId,
      ownerEmail,
      currencyCode,
      timezone,
      createdAt,
      trialStartDate,
      subscriptionTierString,
      subscriptionExpiresAt,
      const DeepCollectionEquality().hash(_settings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationModelImplCopyWith<_$OrganizationModelImpl> get copyWith =>
      __$$OrganizationModelImplCopyWithImpl<_$OrganizationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationModelImplToJson(
      this,
    );
  }
}

abstract class _OrganizationModel extends OrganizationModel {
  const factory _OrganizationModel(
      {required final String id,
      required final String name,
      final String? logoUrl,
      final String ownerId,
      final String ownerEmail,
      @JsonKey(name: 'currency') final String currencyCode,
      final String timezone,
      required final DateTime createdAt,
      final DateTime? trialStartDate,
      @JsonKey(name: 'subscriptionTier') final String? subscriptionTierString,
      final DateTime? subscriptionExpiresAt,
      final Map<String, dynamic> settings}) = _$OrganizationModelImpl;
  const _OrganizationModel._() : super._();

  factory _OrganizationModel.fromJson(Map<String, dynamic> json) =
      _$OrganizationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get logoUrl;
  @override
  String get ownerId;
  @override
  String get ownerEmail;
  @override
  @JsonKey(name: 'currency')
  String get currencyCode;
  @override
  String get timezone;
  @override
  DateTime get createdAt;
  @override
  DateTime? get trialStartDate;
  @override
  @JsonKey(name: 'subscriptionTier')
  String? get subscriptionTierString;
  @override
  DateTime? get subscriptionExpiresAt;
  @override
  Map<String, dynamic> get settings;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationModelImplCopyWith<_$OrganizationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
