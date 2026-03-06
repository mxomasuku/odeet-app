// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InviteModelImpl _$$InviteModelImplFromJson(Map<String, dynamic> json) =>
    _$InviteModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      code: json['code'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      shopIds: (json['shopIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdBy: json['createdBy'] as String,
      createdByName: json['createdByName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      status: json['status'] as String? ?? 'pending',
      acceptedBy: json['acceptedBy'] as String?,
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
    );

Map<String, dynamic> _$$InviteModelImplToJson(_$InviteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'code': instance.code,
      'email': instance.email,
      'role': instance.role,
      'shopIds': instance.shopIds,
      'createdBy': instance.createdBy,
      'createdByName': instance.createdByName,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'status': instance.status,
      'acceptedBy': instance.acceptedBy,
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
    };
