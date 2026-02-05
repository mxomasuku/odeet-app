import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'sale_model.freezed.dart';
part 'sale_model.g.dart';

@freezed
class SaleModel with _$SaleModel {
  const factory SaleModel({
    required String id,
    required String organizationId,
    required String shopId,
    String? shopName,
    required String saleNumber,
    required List<SaleItemModel> items,
    required double subtotal,
    @Default(0) double discountAmount,
    @Default(0) double discountPercent,
    @Default(0) double taxAmount,
    required double totalAmount,
    required double amountPaid,
    @Default(0) double changeGiven,
    @JsonKey(name: 'paymentMethod') required String paymentMethodString,
    @JsonKey(name: 'currency') @Default('USD') String currencyCode,
    String? paymentReference,
    @JsonKey(name: 'status') @Default('completed') String statusString,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? notes,
    required String soldBy,
    required String soldByName,
    required DateTime saleDate,
    DateTime? syncedAt,
    @Default(false) bool isSynced,
  }) = _SaleModel;

  const SaleModel._();

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);

  PaymentMethod get paymentMethod => PaymentMethod.values.firstWhere(
        (p) => p.code == paymentMethodString,
        orElse: () => PaymentMethod.cash,
      );

  Currency get currency => Currency.values.firstWhere(
        (c) => c.code == currencyCode,
        orElse: () => Currency.usd,
      );

  SaleStatus get status => SaleStatus.values.firstWhere(
        (s) => s.name == statusString,
        orElse: () => SaleStatus.completed,
      );

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalProfit =>
      items.fold(0.0, (sum, item) => sum + item.totalProfit);

  bool get isFullyPaid => amountPaid >= totalAmount;
}

@freezed
class SaleItemModel with _$SaleItemModel {
  const factory SaleItemModel({
    required String productId,
    required String productName,
    String? sku,
    String? barcode,
    required int quantity,
    required double unitPrice,
    required double costPrice,
    @Default(0) double discountAmount,
    required double totalPrice,
  }) = _SaleItemModel;

  const SaleItemModel._();

  factory SaleItemModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemModelFromJson(json);

  double get profit => (unitPrice - costPrice) * quantity - discountAmount;
  double get totalProfit => profit;
  double get profitMargin {
    if (totalPrice == 0) return 0;
    return (profit / totalPrice) * 100;
  }
}

enum SaleStatus {
  pending,
  completed,
  cancelled,
  refunded,
  partialRefund,
}

@freezed
class DailySalesSummary with _$DailySalesSummary {
  const factory DailySalesSummary({
    required DateTime date,
    required String shopId,
    required String shopName,
    required int totalTransactions,
    required double totalSales,
    required double totalProfit,
    required int totalItems,
    required double cashSales,
    required double mobileMoneySales,
    required double cardSales,
    required double averageTransactionValue,
  }) = _DailySalesSummary;

  factory DailySalesSummary.fromJson(Map<String, dynamic> json) =>
      _$DailySalesSummaryFromJson(json);
}
