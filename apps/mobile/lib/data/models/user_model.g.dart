// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      organizationId: json['organizationId'] as String? ?? '',
      roleString: json['role'] as String? ?? 'shopkeeper',
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      shopIds:
          (json['shopIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      isBlocked: json['isBlocked'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
      'organizationId': instance.organizationId,
      'role': instance.roleString,
      'roles': instance.roles,
      'shopIds': instance.shopIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'isActive': instance.isActive,
      'isBlocked': instance.isBlocked,
    };

_$OrganizationModelImpl _$$OrganizationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      ownerId: json['ownerId'] as String? ?? '',
      ownerEmail: json['ownerEmail'] as String? ?? '',
      currencyCode: json['currency'] as String? ?? 'USD',
      timezone: json['timezone'] as String? ?? 'Africa/Harare',
      createdAt: DateTime.parse(json['createdAt'] as String),
      trialStartDate: json['trialStartDate'] == null
          ? null
          : DateTime.parse(json['trialStartDate'] as String),
      subscriptionTierString: json['subscriptionTier'] as String?,
      subscriptionExpiresAt: json['subscriptionExpiresAt'] == null
          ? null
          : DateTime.parse(json['subscriptionExpiresAt'] as String),
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$OrganizationModelImplToJson(
        _$OrganizationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'ownerId': instance.ownerId,
      'ownerEmail': instance.ownerEmail,
      'currency': instance.currencyCode,
      'timezone': instance.timezone,
      'createdAt': instance.createdAt.toIso8601String(),
      'trialStartDate': instance.trialStartDate?.toIso8601String(),
      'subscriptionTier': instance.subscriptionTierString,
      'subscriptionExpiresAt':
          instance.subscriptionExpiresAt?.toIso8601String(),
      'settings': instance.settings,
    };
