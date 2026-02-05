import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'cash_collection_model.freezed.dart';
part 'cash_collection_model.g.dart';

@freezed
class CashCollectionModel with _$CashCollectionModel {
  const factory CashCollectionModel({
    required String id,
    required String organizationId,
    required String collectionNumber,
    required String shopId,
    required String shopName,
    @JsonKey(name: 'currency') @Default('USD') String currencyCode,
    required double expectedAmount,
    required double actualAmount,
    double? confirmedAmount,
    @JsonKey(name: 'status') required String statusString,
    String? notes,
    // Denominations breakdown
    @Default({}) Map<String, int> denominations,
    // Submitted by (cashier)
    required String submittedBy,
    required String submittedByName,
    required DateTime submittedAt,
    // Collected by (manager/collector)
    String? collectedBy,
    String? collectedByName,
    DateTime? collectedAt,
    // Confirmed by (admin/accountant)
    String? confirmedBy,
    String? confirmedByName,
    DateTime? confirmedAt,
    // Dispute
    String? disputeReason,
    String? disputedBy,
    DateTime? disputedAt,
    String? disputeResolution,
    // Sync
    DateTime? syncedAt,
    @Default(false) bool isSynced,
  }) = _CashCollectionModel;

  const CashCollectionModel._();

  factory CashCollectionModel.fromJson(Map<String, dynamic> json) =>
      _$CashCollectionModelFromJson(json);

  Currency get currency => Currency.values.firstWhere(
        (c) => c.code == currencyCode,
        orElse: () => Currency.usd,
      );

  CashCollectionStatus get status => CashCollectionStatus.values.firstWhere(
        (s) => s.name == statusString,
        orElse: () => CashCollectionStatus.pending,
      );

  double get variance => actualAmount - expectedAmount;

  double get confirmedVariance =>
      (confirmedAmount ?? actualAmount) - expectedAmount;

  bool get hasVariance => variance != 0;

  bool get hasShortage => variance < 0;

  bool get hasOverage => variance > 0;

  double get variancePercent {
    if (expectedAmount == 0) return 0;
    return (variance / expectedAmount) * 100;
  }

  bool get canCollect => status == CashCollectionStatus.pending;
  bool get canConfirm => status == CashCollectionStatus.collected;
  bool get canDispute =>
      status == CashCollectionStatus.collected ||
      status == CashCollectionStatus.confirmed;

  bool get isCompleted =>
      status == CashCollectionStatus.confirmed ||
      status == CashCollectionStatus.disputed;
}

/// Standard USD denominations for counting
class UsdDenominations {
  static const Map<String, double> bills = {
    '100': 100.0,
    '50': 50.0,
    '20': 20.0,
    '10': 10.0,
    '5': 5.0,
    '2': 2.0,
    '1': 1.0,
  };

  static const Map<String, double> coins = {
    '0.50': 0.50,
    '0.25': 0.25,
    '0.10': 0.10,
    '0.05': 0.05,
    '0.01': 0.01,
  };

  static double calculateTotal(Map<String, int> denominations) {
    double total = 0;
    denominations.forEach((denom, count) {
      final value = double.tryParse(denom) ?? 0;
      total += value * count;
    });
    return total;
  }
}

@freezed
class CashCollectionSummary with _$CashCollectionSummary {
  const factory CashCollectionSummary({
    required DateTime date,
    required String shopId,
    required String shopName,
    required int totalCollections,
    required double totalExpected,
    required double totalActual,
    required double totalVariance,
    required int shortageCount,
    required int overageCount,
    required int matchCount,
  }) = _CashCollectionSummary;

  factory CashCollectionSummary.fromJson(Map<String, dynamic> json) =>
      _$CashCollectionSummaryFromJson(json);
}
