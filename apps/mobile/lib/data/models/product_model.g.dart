// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      costPrice: (json['costPrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 0,
      unit: json['unit'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      trackInventory: json['trackInventory'] as bool? ?? true,
      allowNegativeStock: json['allowNegativeStock'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'name': instance.name,
      'barcode': instance.barcode,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'costPrice': instance.costPrice,
      'sellingPrice': instance.sellingPrice,
      'lowStockThreshold': instance.lowStockThreshold,
      'unit': instance.unit,
      'imageUrl': instance.imageUrl,
      'isActive': instance.isActive,
      'trackInventory': instance.trackInventory,
      'allowNegativeStock': instance.allowNegativeStock,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      parentId: json['parentId'] as String?,
      iconName: json['iconName'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'name': instance.name,
      'description': instance.description,
      'parentId': instance.parentId,
      'iconName': instance.iconName,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$ProductInventoryImpl _$$ProductInventoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductInventoryImpl(
      productId: json['productId'] as String,
      shopId: json['shopId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      reservedQuantity: (json['reservedQuantity'] as num?)?.toInt(),
      lastCountDate: json['lastCountDate'] == null
          ? null
          : DateTime.parse(json['lastCountDate'] as String),
      lastCountBy: json['lastCountBy'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProductInventoryImplToJson(
        _$ProductInventoryImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'shopId': instance.shopId,
      'quantity': instance.quantity,
      'reservedQuantity': instance.reservedQuantity,
      'lastCountDate': instance.lastCountDate?.toIso8601String(),
      'lastCountBy': instance.lastCountBy,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$PriceHistoryModelImpl _$$PriceHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PriceHistoryModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      oldCostPrice: (json['oldCostPrice'] as num).toDouble(),
      newCostPrice: (json['newCostPrice'] as num).toDouble(),
      oldSellingPrice: (json['oldSellingPrice'] as num).toDouble(),
      newSellingPrice: (json['newSellingPrice'] as num).toDouble(),
      changedBy: json['changedBy'] as String,
      changedByName: json['changedByName'] as String,
      reason: json['reason'] as String?,
      changedAt: DateTime.parse(json['changedAt'] as String),
    );

Map<String, dynamic> _$$PriceHistoryModelImplToJson(
        _$PriceHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'oldCostPrice': instance.oldCostPrice,
      'newCostPrice': instance.newCostPrice,
      'oldSellingPrice': instance.oldSellingPrice,
      'newSellingPrice': instance.newSellingPrice,
      'changedBy': instance.changedBy,
      'changedByName': instance.changedByName,
      'reason': instance.reason,
      'changedAt': instance.changedAt.toIso8601String(),
    };

_$StockAdjustmentModelImpl _$$StockAdjustmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StockAdjustmentModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      shopId: json['shopId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      adjustmentType: json['type'] as String,
      quantityBefore: (json['quantityBefore'] as num).toInt(),
      quantityChange: (json['quantityChange'] as num).toInt(),
      quantityAfter: (json['quantityAfter'] as num).toInt(),
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      adjustedBy: json['adjustedBy'] as String,
      adjustedByName: json['adjustedByName'] as String,
      adjustedAt: DateTime.parse(json['adjustedAt'] as String),
      referenceId: json['referenceId'] as String?,
      referenceType: json['referenceType'] as String?,
    );

Map<String, dynamic> _$$StockAdjustmentModelImplToJson(
        _$StockAdjustmentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'shopId': instance.shopId,
      'productId': instance.productId,
      'productName': instance.productName,
      'type': instance.adjustmentType,
      'quantityBefore': instance.quantityBefore,
      'quantityChange': instance.quantityChange,
      'quantityAfter': instance.quantityAfter,
      'reason': instance.reason,
      'notes': instance.notes,
      'adjustedBy': instance.adjustedBy,
      'adjustedByName': instance.adjustedByName,
      'adjustedAt': instance.adjustedAt.toIso8601String(),
      'referenceId': instance.referenceId,
      'referenceType': instance.referenceType,
    };
