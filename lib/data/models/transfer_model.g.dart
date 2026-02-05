// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferModelImpl _$$TransferModelImplFromJson(Map<String, dynamic> json) =>
    _$TransferModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      transferNumber: json['transferNumber'] as String,
      sourceShopId: json['sourceShopId'] as String,
      sourceShopName: json['sourceShopName'] as String,
      destinationShopId: json['destinationShopId'] as String,
      destinationShopName: json['destinationShopName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => TransferItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      statusString: json['status'] as String,
      notes: json['notes'] as String?,
      createdBy: json['createdBy'] as String,
      createdByName: json['createdByName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dispatchedBy: json['dispatchedBy'] as String?,
      dispatchedByName: json['dispatchedByName'] as String?,
      dispatchedAt: json['dispatchedAt'] == null
          ? null
          : DateTime.parse(json['dispatchedAt'] as String),
      receivedBy: json['receivedBy'] as String?,
      receivedByName: json['receivedByName'] as String?,
      receivedAt: json['receivedAt'] == null
          ? null
          : DateTime.parse(json['receivedAt'] as String),
      confirmedBy: json['confirmedBy'] as String?,
      confirmedByName: json['confirmedByName'] as String?,
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      rejectionReason: json['rejectionReason'] as String?,
      rejectedBy: json['rejectedBy'] as String?,
      rejectedAt: json['rejectedAt'] == null
          ? null
          : DateTime.parse(json['rejectedAt'] as String),
      approvedBy: json['approvedBy'] as String?,
      approvedByName: json['approvedByName'] as String?,
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      syncedAt: json['syncedAt'] == null
          ? null
          : DateTime.parse(json['syncedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$$TransferModelImplToJson(_$TransferModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'transferNumber': instance.transferNumber,
      'sourceShopId': instance.sourceShopId,
      'sourceShopName': instance.sourceShopName,
      'destinationShopId': instance.destinationShopId,
      'destinationShopName': instance.destinationShopName,
      'items': instance.items,
      'status': instance.statusString,
      'notes': instance.notes,
      'createdBy': instance.createdBy,
      'createdByName': instance.createdByName,
      'createdAt': instance.createdAt.toIso8601String(),
      'dispatchedBy': instance.dispatchedBy,
      'dispatchedByName': instance.dispatchedByName,
      'dispatchedAt': instance.dispatchedAt?.toIso8601String(),
      'receivedBy': instance.receivedBy,
      'receivedByName': instance.receivedByName,
      'receivedAt': instance.receivedAt?.toIso8601String(),
      'confirmedBy': instance.confirmedBy,
      'confirmedByName': instance.confirmedByName,
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'rejectionReason': instance.rejectionReason,
      'rejectedBy': instance.rejectedBy,
      'rejectedAt': instance.rejectedAt?.toIso8601String(),
      'approvedBy': instance.approvedBy,
      'approvedByName': instance.approvedByName,
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'syncedAt': instance.syncedAt?.toIso8601String(),
      'isSynced': instance.isSynced,
    };

_$TransferItemModelImpl _$$TransferItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferItemModelImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitCost: (json['unitCost'] as num).toDouble(),
      receivedQuantity: (json['receivedQuantity'] as num?)?.toInt(),
      receivedNotes: json['receivedNotes'] as String?,
    );

Map<String, dynamic> _$$TransferItemModelImplToJson(
        _$TransferItemModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'quantity': instance.quantity,
      'unitCost': instance.unitCost,
      'receivedQuantity': instance.receivedQuantity,
      'receivedNotes': instance.receivedNotes,
    };
