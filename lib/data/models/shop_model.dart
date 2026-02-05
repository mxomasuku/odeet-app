import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_model.freezed.dart';
part 'shop_model.g.dart';

@freezed
class ShopModel with _$ShopModel {
  const factory ShopModel({
    required String id,
    required String organizationId,
    required String name,
    String? code,
    String? address,
    String? city,
    String? phone,
    String? email,
    @Default(true) bool isActive,
    @Default(false) bool isHeadOffice,
    String? managerId,
    String? managerName,
    @Default([]) List<String> assignedUserIds,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default({}) Map<String, dynamic> settings,
  }) = _ShopModel;

  const ShopModel._();

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);

  String get displayName => code != null ? '$name ($code)' : name;

  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    return parts.join(', ');
  }
}

@freezed
class ShopInventorySummary with _$ShopInventorySummary {
  const factory ShopInventorySummary({
    required String shopId,
    required String shopName,
    required int totalProducts,
    required int lowStockCount,
    required int outOfStockCount,
    required double totalStockValue,
    DateTime? lastUpdated,
  }) = _ShopInventorySummary;

  factory ShopInventorySummary.fromJson(Map<String, dynamic> json) =>
      _$ShopInventorySummaryFromJson(json);
}
