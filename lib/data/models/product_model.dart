import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String organizationId,
    required String name,
    String? barcode,
    String? description,
    String? categoryId,
    String? categoryName,
    required double costPrice,
    required double sellingPrice,
    @Default(0) int lowStockThreshold,
    String? unit,
    String? imageUrl,
    @Default(true) bool isActive,
    @Default(true) bool trackInventory,
    @Default(false) bool allowNegativeStock,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _ProductModel;

  const ProductModel._();

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  double get profitMargin {
    if (sellingPrice == 0) return 0;
    return ((sellingPrice - costPrice) / sellingPrice) * 100;
  }

  double get markup {
    if (costPrice == 0) return 0;
    return ((sellingPrice - costPrice) / costPrice) * 100;
  }

  double get profit => sellingPrice - costPrice;
}

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String organizationId,
    required String name,
    String? description,
    String? parentId,
    String? iconName,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

@freezed
class ProductInventory with _$ProductInventory {
  const factory ProductInventory({
    required String productId,
    required String shopId,
    required int quantity,
    int? reservedQuantity,
    DateTime? lastCountDate,
    String? lastCountBy,
    DateTime? updatedAt,
  }) = _ProductInventory;

  const ProductInventory._();

  factory ProductInventory.fromJson(Map<String, dynamic> json) =>
      _$ProductInventoryFromJson(json);

  int get availableQuantity => quantity - (reservedQuantity ?? 0);
}

@freezed
class PriceHistoryModel with _$PriceHistoryModel {
  const factory PriceHistoryModel({
    required String id,
    required String productId,
    required String productName,
    required double oldCostPrice,
    required double newCostPrice,
    required double oldSellingPrice,
    required double newSellingPrice,
    required String changedBy,
    required String changedByName,
    String? reason,
    required DateTime changedAt,
  }) = _PriceHistoryModel;

  factory PriceHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$PriceHistoryModelFromJson(json);
}

@freezed
class StockAdjustmentModel with _$StockAdjustmentModel {
  const factory StockAdjustmentModel({
    required String id,
    required String organizationId,
    required String shopId,
    required String productId,
    required String productName,
    @JsonKey(name: 'type') required String adjustmentType,
    required int quantityBefore,
    required int quantityChange,
    required int quantityAfter,
    String? reason,
    String? notes,
    required String adjustedBy,
    required String adjustedByName,
    required DateTime adjustedAt,
    String? referenceId,
    String? referenceType,
  }) = _StockAdjustmentModel;

  const StockAdjustmentModel._();

  factory StockAdjustmentModel.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustmentModelFromJson(json);

  bool get isIncrease => quantityChange > 0;
  bool get isDecrease => quantityChange < 0;
}

/// Stock adjustment types
enum StockAdjustmentType {
  received('Stock Received'),
  sold('Sold'),
  damaged('Damaged'),
  expired('Expired'),
  lost('Lost'),
  found('Found'),
  transferIn('Transfer In'),
  transferOut('Transfer Out'),
  correction('Correction'),
  opening('Opening Stock'),
  returned('Customer Return');

  final String displayName;
  const StockAdjustmentType(this.displayName);
}
