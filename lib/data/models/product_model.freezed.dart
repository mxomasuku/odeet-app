// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  double get costPrice => throw _privateConstructorUsedError;
  double get sellingPrice => throw _privateConstructorUsedError;
  int get lowStockThreshold => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get trackInventory => throw _privateConstructorUsedError;
  bool get allowNegativeStock => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String name,
      String? barcode,
      String? description,
      String? categoryId,
      String? categoryName,
      double costPrice,
      double sellingPrice,
      int lowStockThreshold,
      String? unit,
      String? imageUrl,
      bool isActive,
      bool trackInventory,
      bool allowNegativeStock,
      DateTime createdAt,
      DateTime? updatedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? name = null,
    Object? barcode = freezed,
    Object? description = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? costPrice = null,
    Object? sellingPrice = null,
    Object? lowStockThreshold = null,
    Object? unit = freezed,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? trackInventory = null,
    Object? allowNegativeStock = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      costPrice: null == costPrice
          ? _value.costPrice
          : costPrice // ignore: cast_nullable_to_non_nullable
              as double,
      sellingPrice: null == sellingPrice
          ? _value.sellingPrice
          : sellingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lowStockThreshold: null == lowStockThreshold
          ? _value.lowStockThreshold
          : lowStockThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      trackInventory: null == trackInventory
          ? _value.trackInventory
          : trackInventory // ignore: cast_nullable_to_non_nullable
              as bool,
      allowNegativeStock: null == allowNegativeStock
          ? _value.allowNegativeStock
          : allowNegativeStock // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String name,
      String? barcode,
      String? description,
      String? categoryId,
      String? categoryName,
      double costPrice,
      double sellingPrice,
      int lowStockThreshold,
      String? unit,
      String? imageUrl,
      bool isActive,
      bool trackInventory,
      bool allowNegativeStock,
      DateTime createdAt,
      DateTime? updatedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? name = null,
    Object? barcode = freezed,
    Object? description = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? costPrice = null,
    Object? sellingPrice = null,
    Object? lowStockThreshold = null,
    Object? unit = freezed,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? trackInventory = null,
    Object? allowNegativeStock = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      costPrice: null == costPrice
          ? _value.costPrice
          : costPrice // ignore: cast_nullable_to_non_nullable
              as double,
      sellingPrice: null == sellingPrice
          ? _value.sellingPrice
          : sellingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lowStockThreshold: null == lowStockThreshold
          ? _value.lowStockThreshold
          : lowStockThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      trackInventory: null == trackInventory
          ? _value.trackInventory
          : trackInventory // ignore: cast_nullable_to_non_nullable
              as bool,
      allowNegativeStock: null == allowNegativeStock
          ? _value.allowNegativeStock
          : allowNegativeStock // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl extends _ProductModel {
  const _$ProductModelImpl(
      {required this.id,
      required this.organizationId,
      required this.name,
      this.barcode,
      this.description,
      this.categoryId,
      this.categoryName,
      required this.costPrice,
      required this.sellingPrice,
      this.lowStockThreshold = 0,
      this.unit,
      this.imageUrl,
      this.isActive = true,
      this.trackInventory = true,
      this.allowNegativeStock = false,
      required this.createdAt,
      this.updatedAt,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata,
        super._();

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String name;
  @override
  final String? barcode;
  @override
  final String? description;
  @override
  final String? categoryId;
  @override
  final String? categoryName;
  @override
  final double costPrice;
  @override
  final double sellingPrice;
  @override
  @JsonKey()
  final int lowStockThreshold;
  @override
  final String? unit;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool trackInventory;
  @override
  @JsonKey()
  final bool allowNegativeStock;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, organizationId: $organizationId, name: $name, barcode: $barcode, description: $description, categoryId: $categoryId, categoryName: $categoryName, costPrice: $costPrice, sellingPrice: $sellingPrice, lowStockThreshold: $lowStockThreshold, unit: $unit, imageUrl: $imageUrl, isActive: $isActive, trackInventory: $trackInventory, allowNegativeStock: $allowNegativeStock, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.costPrice, costPrice) ||
                other.costPrice == costPrice) &&
            (identical(other.sellingPrice, sellingPrice) ||
                other.sellingPrice == sellingPrice) &&
            (identical(other.lowStockThreshold, lowStockThreshold) ||
                other.lowStockThreshold == lowStockThreshold) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.trackInventory, trackInventory) ||
                other.trackInventory == trackInventory) &&
            (identical(other.allowNegativeStock, allowNegativeStock) ||
                other.allowNegativeStock == allowNegativeStock) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      name,
      barcode,
      description,
      categoryId,
      categoryName,
      costPrice,
      sellingPrice,
      lowStockThreshold,
      unit,
      imageUrl,
      isActive,
      trackInventory,
      allowNegativeStock,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(
      this,
    );
  }
}

abstract class _ProductModel extends ProductModel {
  const factory _ProductModel(
      {required final String id,
      required final String organizationId,
      required final String name,
      final String? barcode,
      final String? description,
      final String? categoryId,
      final String? categoryName,
      required final double costPrice,
      required final double sellingPrice,
      final int lowStockThreshold,
      final String? unit,
      final String? imageUrl,
      final bool isActive,
      final bool trackInventory,
      final bool allowNegativeStock,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final Map<String, dynamic> metadata}) = _$ProductModelImpl;
  const _ProductModel._() : super._();

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get name;
  @override
  String? get barcode;
  @override
  String? get description;
  @override
  String? get categoryId;
  @override
  String? get categoryName;
  @override
  double get costPrice;
  @override
  double get sellingPrice;
  @override
  int get lowStockThreshold;
  @override
  String? get unit;
  @override
  String? get imageUrl;
  @override
  bool get isActive;
  @override
  bool get trackInventory;
  @override
  bool get allowNegativeStock;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return _CategoryModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  String? get iconName => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
          CategoryModel value, $Res Function(CategoryModel) then) =
      _$CategoryModelCopyWithImpl<$Res, CategoryModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String name,
      String? description,
      String? parentId,
      String? iconName,
      int sortOrder,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res, $Val extends CategoryModel>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? name = null,
    Object? description = freezed,
    Object? parentId = freezed,
    Object? iconName = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryModelImplCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$$CategoryModelImplCopyWith(
          _$CategoryModelImpl value, $Res Function(_$CategoryModelImpl) then) =
      __$$CategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String name,
      String? description,
      String? parentId,
      String? iconName,
      int sortOrder,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class __$$CategoryModelImplCopyWithImpl<$Res>
    extends _$CategoryModelCopyWithImpl<$Res, _$CategoryModelImpl>
    implements _$$CategoryModelImplCopyWith<$Res> {
  __$$CategoryModelImplCopyWithImpl(
      _$CategoryModelImpl _value, $Res Function(_$CategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? name = null,
    Object? description = freezed,
    Object? parentId = freezed,
    Object? iconName = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_$CategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryModelImpl implements _CategoryModel {
  const _$CategoryModelImpl(
      {required this.id,
      required this.organizationId,
      required this.name,
      this.description,
      this.parentId,
      this.iconName,
      this.sortOrder = 0,
      this.isActive = true,
      required this.createdAt});

  factory _$CategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? parentId;
  @override
  final String? iconName;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CategoryModel(id: $id, organizationId: $organizationId, name: $name, description: $description, parentId: $parentId, iconName: $iconName, sortOrder: $sortOrder, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, organizationId, name,
      description, parentId, iconName, sortOrder, isActive, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      __$$CategoryModelImplCopyWithImpl<_$CategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryModel implements CategoryModel {
  const factory _CategoryModel(
      {required final String id,
      required final String organizationId,
      required final String name,
      final String? description,
      final String? parentId,
      final String? iconName,
      final int sortOrder,
      final bool isActive,
      required final DateTime createdAt}) = _$CategoryModelImpl;

  factory _CategoryModel.fromJson(Map<String, dynamic> json) =
      _$CategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get parentId;
  @override
  String? get iconName;
  @override
  int get sortOrder;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductInventory _$ProductInventoryFromJson(Map<String, dynamic> json) {
  return _ProductInventory.fromJson(json);
}

/// @nodoc
mixin _$ProductInventory {
  String get productId => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int? get reservedQuantity => throw _privateConstructorUsedError;
  DateTime? get lastCountDate => throw _privateConstructorUsedError;
  String? get lastCountBy => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductInventoryCopyWith<ProductInventory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductInventoryCopyWith<$Res> {
  factory $ProductInventoryCopyWith(
          ProductInventory value, $Res Function(ProductInventory) then) =
      _$ProductInventoryCopyWithImpl<$Res, ProductInventory>;
  @useResult
  $Res call(
      {String productId,
      String shopId,
      int quantity,
      int? reservedQuantity,
      DateTime? lastCountDate,
      String? lastCountBy,
      DateTime? updatedAt});
}

/// @nodoc
class _$ProductInventoryCopyWithImpl<$Res, $Val extends ProductInventory>
    implements $ProductInventoryCopyWith<$Res> {
  _$ProductInventoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? shopId = null,
    Object? quantity = null,
    Object? reservedQuantity = freezed,
    Object? lastCountDate = freezed,
    Object? lastCountBy = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      reservedQuantity: freezed == reservedQuantity
          ? _value.reservedQuantity
          : reservedQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      lastCountDate: freezed == lastCountDate
          ? _value.lastCountDate
          : lastCountDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastCountBy: freezed == lastCountBy
          ? _value.lastCountBy
          : lastCountBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductInventoryImplCopyWith<$Res>
    implements $ProductInventoryCopyWith<$Res> {
  factory _$$ProductInventoryImplCopyWith(_$ProductInventoryImpl value,
          $Res Function(_$ProductInventoryImpl) then) =
      __$$ProductInventoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String shopId,
      int quantity,
      int? reservedQuantity,
      DateTime? lastCountDate,
      String? lastCountBy,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ProductInventoryImplCopyWithImpl<$Res>
    extends _$ProductInventoryCopyWithImpl<$Res, _$ProductInventoryImpl>
    implements _$$ProductInventoryImplCopyWith<$Res> {
  __$$ProductInventoryImplCopyWithImpl(_$ProductInventoryImpl _value,
      $Res Function(_$ProductInventoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? shopId = null,
    Object? quantity = null,
    Object? reservedQuantity = freezed,
    Object? lastCountDate = freezed,
    Object? lastCountBy = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProductInventoryImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      reservedQuantity: freezed == reservedQuantity
          ? _value.reservedQuantity
          : reservedQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      lastCountDate: freezed == lastCountDate
          ? _value.lastCountDate
          : lastCountDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastCountBy: freezed == lastCountBy
          ? _value.lastCountBy
          : lastCountBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductInventoryImpl extends _ProductInventory {
  const _$ProductInventoryImpl(
      {required this.productId,
      required this.shopId,
      required this.quantity,
      this.reservedQuantity,
      this.lastCountDate,
      this.lastCountBy,
      this.updatedAt})
      : super._();

  factory _$ProductInventoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductInventoryImplFromJson(json);

  @override
  final String productId;
  @override
  final String shopId;
  @override
  final int quantity;
  @override
  final int? reservedQuantity;
  @override
  final DateTime? lastCountDate;
  @override
  final String? lastCountBy;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProductInventory(productId: $productId, shopId: $shopId, quantity: $quantity, reservedQuantity: $reservedQuantity, lastCountDate: $lastCountDate, lastCountBy: $lastCountBy, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductInventoryImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.reservedQuantity, reservedQuantity) ||
                other.reservedQuantity == reservedQuantity) &&
            (identical(other.lastCountDate, lastCountDate) ||
                other.lastCountDate == lastCountDate) &&
            (identical(other.lastCountBy, lastCountBy) ||
                other.lastCountBy == lastCountBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, productId, shopId, quantity,
      reservedQuantity, lastCountDate, lastCountBy, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductInventoryImplCopyWith<_$ProductInventoryImpl> get copyWith =>
      __$$ProductInventoryImplCopyWithImpl<_$ProductInventoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductInventoryImplToJson(
      this,
    );
  }
}

abstract class _ProductInventory extends ProductInventory {
  const factory _ProductInventory(
      {required final String productId,
      required final String shopId,
      required final int quantity,
      final int? reservedQuantity,
      final DateTime? lastCountDate,
      final String? lastCountBy,
      final DateTime? updatedAt}) = _$ProductInventoryImpl;
  const _ProductInventory._() : super._();

  factory _ProductInventory.fromJson(Map<String, dynamic> json) =
      _$ProductInventoryImpl.fromJson;

  @override
  String get productId;
  @override
  String get shopId;
  @override
  int get quantity;
  @override
  int? get reservedQuantity;
  @override
  DateTime? get lastCountDate;
  @override
  String? get lastCountBy;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProductInventoryImplCopyWith<_$ProductInventoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceHistoryModel _$PriceHistoryModelFromJson(Map<String, dynamic> json) {
  return _PriceHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$PriceHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  double get oldCostPrice => throw _privateConstructorUsedError;
  double get newCostPrice => throw _privateConstructorUsedError;
  double get oldSellingPrice => throw _privateConstructorUsedError;
  double get newSellingPrice => throw _privateConstructorUsedError;
  String get changedBy => throw _privateConstructorUsedError;
  String get changedByName => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  DateTime get changedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PriceHistoryModelCopyWith<PriceHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceHistoryModelCopyWith<$Res> {
  factory $PriceHistoryModelCopyWith(
          PriceHistoryModel value, $Res Function(PriceHistoryModel) then) =
      _$PriceHistoryModelCopyWithImpl<$Res, PriceHistoryModel>;
  @useResult
  $Res call(
      {String id,
      String productId,
      String productName,
      double oldCostPrice,
      double newCostPrice,
      double oldSellingPrice,
      double newSellingPrice,
      String changedBy,
      String changedByName,
      String? reason,
      DateTime changedAt});
}

/// @nodoc
class _$PriceHistoryModelCopyWithImpl<$Res, $Val extends PriceHistoryModel>
    implements $PriceHistoryModelCopyWith<$Res> {
  _$PriceHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? oldCostPrice = null,
    Object? newCostPrice = null,
    Object? oldSellingPrice = null,
    Object? newSellingPrice = null,
    Object? changedBy = null,
    Object? changedByName = null,
    Object? reason = freezed,
    Object? changedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      oldCostPrice: null == oldCostPrice
          ? _value.oldCostPrice
          : oldCostPrice // ignore: cast_nullable_to_non_nullable
              as double,
      newCostPrice: null == newCostPrice
          ? _value.newCostPrice
          : newCostPrice // ignore: cast_nullable_to_non_nullable
              as double,
      oldSellingPrice: null == oldSellingPrice
          ? _value.oldSellingPrice
          : oldSellingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      newSellingPrice: null == newSellingPrice
          ? _value.newSellingPrice
          : newSellingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      changedBy: null == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String,
      changedByName: null == changedByName
          ? _value.changedByName
          : changedByName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceHistoryModelImplCopyWith<$Res>
    implements $PriceHistoryModelCopyWith<$Res> {
  factory _$$PriceHistoryModelImplCopyWith(_$PriceHistoryModelImpl value,
          $Res Function(_$PriceHistoryModelImpl) then) =
      __$$PriceHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String productName,
      double oldCostPrice,
      double newCostPrice,
      double oldSellingPrice,
      double newSellingPrice,
      String changedBy,
      String changedByName,
      String? reason,
      DateTime changedAt});
}

/// @nodoc
class __$$PriceHistoryModelImplCopyWithImpl<$Res>
    extends _$PriceHistoryModelCopyWithImpl<$Res, _$PriceHistoryModelImpl>
    implements _$$PriceHistoryModelImplCopyWith<$Res> {
  __$$PriceHistoryModelImplCopyWithImpl(_$PriceHistoryModelImpl _value,
      $Res Function(_$PriceHistoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? oldCostPrice = null,
    Object? newCostPrice = null,
    Object? oldSellingPrice = null,
    Object? newSellingPrice = null,
    Object? changedBy = null,
    Object? changedByName = null,
    Object? reason = freezed,
    Object? changedAt = null,
  }) {
    return _then(_$PriceHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      oldCostPrice: null == oldCostPrice
          ? _value.oldCostPrice
          : oldCostPrice // ignore: cast_nullable_to_non_nullable
              as double,
      newCostPrice: null == newCostPrice
          ? _value.newCostPrice
          : newCostPrice // ignore: cast_nullable_to_non_nullable
              as double,
      oldSellingPrice: null == oldSellingPrice
          ? _value.oldSellingPrice
          : oldSellingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      newSellingPrice: null == newSellingPrice
          ? _value.newSellingPrice
          : newSellingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      changedBy: null == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String,
      changedByName: null == changedByName
          ? _value.changedByName
          : changedByName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceHistoryModelImpl implements _PriceHistoryModel {
  const _$PriceHistoryModelImpl(
      {required this.id,
      required this.productId,
      required this.productName,
      required this.oldCostPrice,
      required this.newCostPrice,
      required this.oldSellingPrice,
      required this.newSellingPrice,
      required this.changedBy,
      required this.changedByName,
      this.reason,
      required this.changedAt});

  factory _$PriceHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String productName;
  @override
  final double oldCostPrice;
  @override
  final double newCostPrice;
  @override
  final double oldSellingPrice;
  @override
  final double newSellingPrice;
  @override
  final String changedBy;
  @override
  final String changedByName;
  @override
  final String? reason;
  @override
  final DateTime changedAt;

  @override
  String toString() {
    return 'PriceHistoryModel(id: $id, productId: $productId, productName: $productName, oldCostPrice: $oldCostPrice, newCostPrice: $newCostPrice, oldSellingPrice: $oldSellingPrice, newSellingPrice: $newSellingPrice, changedBy: $changedBy, changedByName: $changedByName, reason: $reason, changedAt: $changedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.oldCostPrice, oldCostPrice) ||
                other.oldCostPrice == oldCostPrice) &&
            (identical(other.newCostPrice, newCostPrice) ||
                other.newCostPrice == newCostPrice) &&
            (identical(other.oldSellingPrice, oldSellingPrice) ||
                other.oldSellingPrice == oldSellingPrice) &&
            (identical(other.newSellingPrice, newSellingPrice) ||
                other.newSellingPrice == newSellingPrice) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy) &&
            (identical(other.changedByName, changedByName) ||
                other.changedByName == changedByName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      productName,
      oldCostPrice,
      newCostPrice,
      oldSellingPrice,
      newSellingPrice,
      changedBy,
      changedByName,
      reason,
      changedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceHistoryModelImplCopyWith<_$PriceHistoryModelImpl> get copyWith =>
      __$$PriceHistoryModelImplCopyWithImpl<_$PriceHistoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _PriceHistoryModel implements PriceHistoryModel {
  const factory _PriceHistoryModel(
      {required final String id,
      required final String productId,
      required final String productName,
      required final double oldCostPrice,
      required final double newCostPrice,
      required final double oldSellingPrice,
      required final double newSellingPrice,
      required final String changedBy,
      required final String changedByName,
      final String? reason,
      required final DateTime changedAt}) = _$PriceHistoryModelImpl;

  factory _PriceHistoryModel.fromJson(Map<String, dynamic> json) =
      _$PriceHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get productName;
  @override
  double get oldCostPrice;
  @override
  double get newCostPrice;
  @override
  double get oldSellingPrice;
  @override
  double get newSellingPrice;
  @override
  String get changedBy;
  @override
  String get changedByName;
  @override
  String? get reason;
  @override
  DateTime get changedAt;
  @override
  @JsonKey(ignore: true)
  _$$PriceHistoryModelImplCopyWith<_$PriceHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockAdjustmentModel _$StockAdjustmentModelFromJson(Map<String, dynamic> json) {
  return _StockAdjustmentModel.fromJson(json);
}

/// @nodoc
mixin _$StockAdjustmentModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get adjustmentType => throw _privateConstructorUsedError;
  int get quantityBefore => throw _privateConstructorUsedError;
  int get quantityChange => throw _privateConstructorUsedError;
  int get quantityAfter => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get adjustedBy => throw _privateConstructorUsedError;
  String get adjustedByName => throw _privateConstructorUsedError;
  DateTime get adjustedAt => throw _privateConstructorUsedError;
  String? get referenceId => throw _privateConstructorUsedError;
  String? get referenceType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockAdjustmentModelCopyWith<StockAdjustmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockAdjustmentModelCopyWith<$Res> {
  factory $StockAdjustmentModelCopyWith(StockAdjustmentModel value,
          $Res Function(StockAdjustmentModel) then) =
      _$StockAdjustmentModelCopyWithImpl<$Res, StockAdjustmentModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String shopId,
      String productId,
      String productName,
      @JsonKey(name: 'type') String adjustmentType,
      int quantityBefore,
      int quantityChange,
      int quantityAfter,
      String? reason,
      String? notes,
      String adjustedBy,
      String adjustedByName,
      DateTime adjustedAt,
      String? referenceId,
      String? referenceType});
}

/// @nodoc
class _$StockAdjustmentModelCopyWithImpl<$Res,
        $Val extends StockAdjustmentModel>
    implements $StockAdjustmentModelCopyWith<$Res> {
  _$StockAdjustmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? shopId = null,
    Object? productId = null,
    Object? productName = null,
    Object? adjustmentType = null,
    Object? quantityBefore = null,
    Object? quantityChange = null,
    Object? quantityAfter = null,
    Object? reason = freezed,
    Object? notes = freezed,
    Object? adjustedBy = null,
    Object? adjustedByName = null,
    Object? adjustedAt = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      adjustmentType: null == adjustmentType
          ? _value.adjustmentType
          : adjustmentType // ignore: cast_nullable_to_non_nullable
              as String,
      quantityBefore: null == quantityBefore
          ? _value.quantityBefore
          : quantityBefore // ignore: cast_nullable_to_non_nullable
              as int,
      quantityChange: null == quantityChange
          ? _value.quantityChange
          : quantityChange // ignore: cast_nullable_to_non_nullable
              as int,
      quantityAfter: null == quantityAfter
          ? _value.quantityAfter
          : quantityAfter // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      adjustedBy: null == adjustedBy
          ? _value.adjustedBy
          : adjustedBy // ignore: cast_nullable_to_non_nullable
              as String,
      adjustedByName: null == adjustedByName
          ? _value.adjustedByName
          : adjustedByName // ignore: cast_nullable_to_non_nullable
              as String,
      adjustedAt: null == adjustedAt
          ? _value.adjustedAt
          : adjustedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceType: freezed == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockAdjustmentModelImplCopyWith<$Res>
    implements $StockAdjustmentModelCopyWith<$Res> {
  factory _$$StockAdjustmentModelImplCopyWith(_$StockAdjustmentModelImpl value,
          $Res Function(_$StockAdjustmentModelImpl) then) =
      __$$StockAdjustmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String shopId,
      String productId,
      String productName,
      @JsonKey(name: 'type') String adjustmentType,
      int quantityBefore,
      int quantityChange,
      int quantityAfter,
      String? reason,
      String? notes,
      String adjustedBy,
      String adjustedByName,
      DateTime adjustedAt,
      String? referenceId,
      String? referenceType});
}

/// @nodoc
class __$$StockAdjustmentModelImplCopyWithImpl<$Res>
    extends _$StockAdjustmentModelCopyWithImpl<$Res, _$StockAdjustmentModelImpl>
    implements _$$StockAdjustmentModelImplCopyWith<$Res> {
  __$$StockAdjustmentModelImplCopyWithImpl(_$StockAdjustmentModelImpl _value,
      $Res Function(_$StockAdjustmentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? shopId = null,
    Object? productId = null,
    Object? productName = null,
    Object? adjustmentType = null,
    Object? quantityBefore = null,
    Object? quantityChange = null,
    Object? quantityAfter = null,
    Object? reason = freezed,
    Object? notes = freezed,
    Object? adjustedBy = null,
    Object? adjustedByName = null,
    Object? adjustedAt = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
  }) {
    return _then(_$StockAdjustmentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      adjustmentType: null == adjustmentType
          ? _value.adjustmentType
          : adjustmentType // ignore: cast_nullable_to_non_nullable
              as String,
      quantityBefore: null == quantityBefore
          ? _value.quantityBefore
          : quantityBefore // ignore: cast_nullable_to_non_nullable
              as int,
      quantityChange: null == quantityChange
          ? _value.quantityChange
          : quantityChange // ignore: cast_nullable_to_non_nullable
              as int,
      quantityAfter: null == quantityAfter
          ? _value.quantityAfter
          : quantityAfter // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      adjustedBy: null == adjustedBy
          ? _value.adjustedBy
          : adjustedBy // ignore: cast_nullable_to_non_nullable
              as String,
      adjustedByName: null == adjustedByName
          ? _value.adjustedByName
          : adjustedByName // ignore: cast_nullable_to_non_nullable
              as String,
      adjustedAt: null == adjustedAt
          ? _value.adjustedAt
          : adjustedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceType: freezed == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockAdjustmentModelImpl extends _StockAdjustmentModel {
  const _$StockAdjustmentModelImpl(
      {required this.id,
      required this.organizationId,
      required this.shopId,
      required this.productId,
      required this.productName,
      @JsonKey(name: 'type') required this.adjustmentType,
      required this.quantityBefore,
      required this.quantityChange,
      required this.quantityAfter,
      this.reason,
      this.notes,
      required this.adjustedBy,
      required this.adjustedByName,
      required this.adjustedAt,
      this.referenceId,
      this.referenceType})
      : super._();

  factory _$StockAdjustmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockAdjustmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String shopId;
  @override
  final String productId;
  @override
  final String productName;
  @override
  @JsonKey(name: 'type')
  final String adjustmentType;
  @override
  final int quantityBefore;
  @override
  final int quantityChange;
  @override
  final int quantityAfter;
  @override
  final String? reason;
  @override
  final String? notes;
  @override
  final String adjustedBy;
  @override
  final String adjustedByName;
  @override
  final DateTime adjustedAt;
  @override
  final String? referenceId;
  @override
  final String? referenceType;

  @override
  String toString() {
    return 'StockAdjustmentModel(id: $id, organizationId: $organizationId, shopId: $shopId, productId: $productId, productName: $productName, adjustmentType: $adjustmentType, quantityBefore: $quantityBefore, quantityChange: $quantityChange, quantityAfter: $quantityAfter, reason: $reason, notes: $notes, adjustedBy: $adjustedBy, adjustedByName: $adjustedByName, adjustedAt: $adjustedAt, referenceId: $referenceId, referenceType: $referenceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockAdjustmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.adjustmentType, adjustmentType) ||
                other.adjustmentType == adjustmentType) &&
            (identical(other.quantityBefore, quantityBefore) ||
                other.quantityBefore == quantityBefore) &&
            (identical(other.quantityChange, quantityChange) ||
                other.quantityChange == quantityChange) &&
            (identical(other.quantityAfter, quantityAfter) ||
                other.quantityAfter == quantityAfter) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.adjustedBy, adjustedBy) ||
                other.adjustedBy == adjustedBy) &&
            (identical(other.adjustedByName, adjustedByName) ||
                other.adjustedByName == adjustedByName) &&
            (identical(other.adjustedAt, adjustedAt) ||
                other.adjustedAt == adjustedAt) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      shopId,
      productId,
      productName,
      adjustmentType,
      quantityBefore,
      quantityChange,
      quantityAfter,
      reason,
      notes,
      adjustedBy,
      adjustedByName,
      adjustedAt,
      referenceId,
      referenceType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockAdjustmentModelImplCopyWith<_$StockAdjustmentModelImpl>
      get copyWith =>
          __$$StockAdjustmentModelImplCopyWithImpl<_$StockAdjustmentModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockAdjustmentModelImplToJson(
      this,
    );
  }
}

abstract class _StockAdjustmentModel extends StockAdjustmentModel {
  const factory _StockAdjustmentModel(
      {required final String id,
      required final String organizationId,
      required final String shopId,
      required final String productId,
      required final String productName,
      @JsonKey(name: 'type') required final String adjustmentType,
      required final int quantityBefore,
      required final int quantityChange,
      required final int quantityAfter,
      final String? reason,
      final String? notes,
      required final String adjustedBy,
      required final String adjustedByName,
      required final DateTime adjustedAt,
      final String? referenceId,
      final String? referenceType}) = _$StockAdjustmentModelImpl;
  const _StockAdjustmentModel._() : super._();

  factory _StockAdjustmentModel.fromJson(Map<String, dynamic> json) =
      _$StockAdjustmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get shopId;
  @override
  String get productId;
  @override
  String get productName;
  @override
  @JsonKey(name: 'type')
  String get adjustmentType;
  @override
  int get quantityBefore;
  @override
  int get quantityChange;
  @override
  int get quantityAfter;
  @override
  String? get reason;
  @override
  String? get notes;
  @override
  String get adjustedBy;
  @override
  String get adjustedByName;
  @override
  DateTime get adjustedAt;
  @override
  String? get referenceId;
  @override
  String? get referenceType;
  @override
  @JsonKey(ignore: true)
  _$$StockAdjustmentModelImplCopyWith<_$StockAdjustmentModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
