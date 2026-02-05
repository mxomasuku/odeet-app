// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleModelImpl _$$SaleModelImplFromJson(Map<String, dynamic> json) =>
    _$SaleModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String?,
      saleNumber: json['saleNumber'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      amountPaid: (json['amountPaid'] as num).toDouble(),
      changeGiven: (json['changeGiven'] as num?)?.toDouble() ?? 0,
      paymentMethodString: json['paymentMethod'] as String,
      currencyCode: json['currency'] as String? ?? 'USD',
      paymentReference: json['paymentReference'] as String?,
      statusString: json['status'] as String? ?? 'completed',
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      notes: json['notes'] as String?,
      soldBy: json['soldBy'] as String,
      soldByName: json['soldByName'] as String,
      saleDate: DateTime.parse(json['saleDate'] as String),
      syncedAt: json['syncedAt'] == null
          ? null
          : DateTime.parse(json['syncedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$$SaleModelImplToJson(_$SaleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'saleNumber': instance.saleNumber,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'discountAmount': instance.discountAmount,
      'discountPercent': instance.discountPercent,
      'taxAmount': instance.taxAmount,
      'totalAmount': instance.totalAmount,
      'amountPaid': instance.amountPaid,
      'changeGiven': instance.changeGiven,
      'paymentMethod': instance.paymentMethodString,
      'currency': instance.currencyCode,
      'paymentReference': instance.paymentReference,
      'status': instance.statusString,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'notes': instance.notes,
      'soldBy': instance.soldBy,
      'soldByName': instance.soldByName,
      'saleDate': instance.saleDate.toIso8601String(),
      'syncedAt': instance.syncedAt?.toIso8601String(),
      'isSynced': instance.isSynced,
    };

_$SaleItemModelImpl _$$SaleItemModelImplFromJson(Map<String, dynamic> json) =>
    _$SaleItemModelImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      costPrice: (json['costPrice'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$$SaleItemModelImplToJson(_$SaleItemModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'costPrice': instance.costPrice,
      'discountAmount': instance.discountAmount,
      'totalPrice': instance.totalPrice,
    };

_$DailySalesSummaryImpl _$$DailySalesSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$DailySalesSummaryImpl(
      date: DateTime.parse(json['date'] as String),
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      totalTransactions: (json['totalTransactions'] as num).toInt(),
      totalSales: (json['totalSales'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
      totalItems: (json['totalItems'] as num).toInt(),
      cashSales: (json['cashSales'] as num).toDouble(),
      mobileMoneySales: (json['mobileMoneySales'] as num).toDouble(),
      cardSales: (json['cardSales'] as num).toDouble(),
      averageTransactionValue:
          (json['averageTransactionValue'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailySalesSummaryImplToJson(
        _$DailySalesSummaryImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'totalTransactions': instance.totalTransactions,
      'totalSales': instance.totalSales,
      'totalProfit': instance.totalProfit,
      'totalItems': instance.totalItems,
      'cashSales': instance.cashSales,
      'mobileMoneySales': instance.mobileMoneySales,
      'cardSales': instance.cardSales,
      'averageTransactionValue': instance.averageTransactionValue,
    };
