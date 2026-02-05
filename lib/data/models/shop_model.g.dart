// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShopModelImpl _$$ShopModelImplFromJson(Map<String, dynamic> json) =>
    _$ShopModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      name: json['name'] as String,
      code: json['code'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isHeadOffice: json['isHeadOffice'] as bool? ?? false,
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
      assignedUserIds: (json['assignedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ShopModelImplToJson(_$ShopModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'name': instance.name,
      'code': instance.code,
      'address': instance.address,
      'city': instance.city,
      'phone': instance.phone,
      'email': instance.email,
      'isActive': instance.isActive,
      'isHeadOffice': instance.isHeadOffice,
      'managerId': instance.managerId,
      'managerName': instance.managerName,
      'assignedUserIds': instance.assignedUserIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'settings': instance.settings,
    };

_$ShopInventorySummaryImpl _$$ShopInventorySummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ShopInventorySummaryImpl(
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      totalProducts: (json['totalProducts'] as num).toInt(),
      lowStockCount: (json['lowStockCount'] as num).toInt(),
      outOfStockCount: (json['outOfStockCount'] as num).toInt(),
      totalStockValue: (json['totalStockValue'] as num).toDouble(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$ShopInventorySummaryImplToJson(
        _$ShopInventorySummaryImpl instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'totalProducts': instance.totalProducts,
      'lowStockCount': instance.lowStockCount,
      'outOfStockCount': instance.outOfStockCount,
      'totalStockValue': instance.totalStockValue,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
