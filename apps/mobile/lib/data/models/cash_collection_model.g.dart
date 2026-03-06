// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CashCollectionModelImpl _$$CashCollectionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CashCollectionModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      collectionNumber: json['collectionNumber'] as String,
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      currencyCode: json['currency'] as String? ?? 'USD',
      expectedAmount: (json['expectedAmount'] as num).toDouble(),
      actualAmount: (json['actualAmount'] as num).toDouble(),
      confirmedAmount: (json['confirmedAmount'] as num?)?.toDouble(),
      statusString: json['status'] as String,
      notes: json['notes'] as String?,
      denominations: (json['denominations'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      submittedBy: json['submittedBy'] as String,
      submittedByName: json['submittedByName'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      collectedBy: json['collectedBy'] as String?,
      collectedByName: json['collectedByName'] as String?,
      collectedAt: json['collectedAt'] == null
          ? null
          : DateTime.parse(json['collectedAt'] as String),
      confirmedBy: json['confirmedBy'] as String?,
      confirmedByName: json['confirmedByName'] as String?,
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      disputeReason: json['disputeReason'] as String?,
      disputedBy: json['disputedBy'] as String?,
      disputedAt: json['disputedAt'] == null
          ? null
          : DateTime.parse(json['disputedAt'] as String),
      disputeResolution: json['disputeResolution'] as String?,
      syncedAt: json['syncedAt'] == null
          ? null
          : DateTime.parse(json['syncedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$$CashCollectionModelImplToJson(
        _$CashCollectionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'collectionNumber': instance.collectionNumber,
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'currency': instance.currencyCode,
      'expectedAmount': instance.expectedAmount,
      'actualAmount': instance.actualAmount,
      'confirmedAmount': instance.confirmedAmount,
      'status': instance.statusString,
      'notes': instance.notes,
      'denominations': instance.denominations,
      'submittedBy': instance.submittedBy,
      'submittedByName': instance.submittedByName,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'collectedBy': instance.collectedBy,
      'collectedByName': instance.collectedByName,
      'collectedAt': instance.collectedAt?.toIso8601String(),
      'confirmedBy': instance.confirmedBy,
      'confirmedByName': instance.confirmedByName,
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'disputeReason': instance.disputeReason,
      'disputedBy': instance.disputedBy,
      'disputedAt': instance.disputedAt?.toIso8601String(),
      'disputeResolution': instance.disputeResolution,
      'syncedAt': instance.syncedAt?.toIso8601String(),
      'isSynced': instance.isSynced,
    };

_$CashCollectionSummaryImpl _$$CashCollectionSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$CashCollectionSummaryImpl(
      date: DateTime.parse(json['date'] as String),
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      totalCollections: (json['totalCollections'] as num).toInt(),
      totalExpected: (json['totalExpected'] as num).toDouble(),
      totalActual: (json['totalActual'] as num).toDouble(),
      totalVariance: (json['totalVariance'] as num).toDouble(),
      shortageCount: (json['shortageCount'] as num).toInt(),
      overageCount: (json['overageCount'] as num).toInt(),
      matchCount: (json['matchCount'] as num).toInt(),
    );

Map<String, dynamic> _$$CashCollectionSummaryImplToJson(
        _$CashCollectionSummaryImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'totalCollections': instance.totalCollections,
      'totalExpected': instance.totalExpected,
      'totalActual': instance.totalActual,
      'totalVariance': instance.totalVariance,
      'shortageCount': instance.shortageCount,
      'overageCount': instance.overageCount,
      'matchCount': instance.matchCount,
    };
