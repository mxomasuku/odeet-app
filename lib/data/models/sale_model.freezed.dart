// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) {
  return _SaleModel.fromJson(json);
}

/// @nodoc
mixin _$SaleModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String? get shopName => throw _privateConstructorUsedError;
  String get saleNumber => throw _privateConstructorUsedError;
  List<SaleItemModel> get items => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get discountPercent => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get amountPaid => throw _privateConstructorUsedError;
  double get changeGiven => throw _privateConstructorUsedError;
  @JsonKey(name: 'paymentMethod')
  String get paymentMethodString => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String get currencyCode => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get statusString => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get soldBy => throw _privateConstructorUsedError;
  String get soldByName => throw _privateConstructorUsedError;
  DateTime get saleDate => throw _privateConstructorUsedError;
  DateTime? get syncedAt => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SaleModelCopyWith<SaleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleModelCopyWith<$Res> {
  factory $SaleModelCopyWith(SaleModel value, $Res Function(SaleModel) then) =
      _$SaleModelCopyWithImpl<$Res, SaleModel>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String shopId,
      String? shopName,
      String saleNumber,
      List<SaleItemModel> items,
      double subtotal,
      double discountAmount,
      double discountPercent,
      double taxAmount,
      double totalAmount,
      double amountPaid,
      double changeGiven,
      @JsonKey(name: 'paymentMethod') String paymentMethodString,
      @JsonKey(name: 'currency') String currencyCode,
      String? paymentReference,
      @JsonKey(name: 'status') String statusString,
      String? customerId,
      String? customerName,
      String? customerPhone,
      String? notes,
      String soldBy,
      String soldByName,
      DateTime saleDate,
      DateTime? syncedAt,
      bool isSynced});
}

/// @nodoc
class _$SaleModelCopyWithImpl<$Res, $Val extends SaleModel>
    implements $SaleModelCopyWith<$Res> {
  _$SaleModelCopyWithImpl(this._value, this._then);

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
    Object? shopName = freezed,
    Object? saleNumber = null,
    Object? items = null,
    Object? subtotal = null,
    Object? discountAmount = null,
    Object? discountPercent = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? amountPaid = null,
    Object? changeGiven = null,
    Object? paymentMethodString = null,
    Object? currencyCode = null,
    Object? paymentReference = freezed,
    Object? statusString = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? notes = freezed,
    Object? soldBy = null,
    Object? soldByName = null,
    Object? saleDate = null,
    Object? syncedAt = freezed,
    Object? isSynced = null,
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
      shopName: freezed == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String?,
      saleNumber: null == saleNumber
          ? _value.saleNumber
          : saleNumber // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SaleItemModel>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      amountPaid: null == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as double,
      changeGiven: null == changeGiven
          ? _value.changeGiven
          : changeGiven // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethodString: null == paymentMethodString
          ? _value.paymentMethodString
          : paymentMethodString // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      soldBy: null == soldBy
          ? _value.soldBy
          : soldBy // ignore: cast_nullable_to_non_nullable
              as String,
      soldByName: null == soldByName
          ? _value.soldByName
          : soldByName // ignore: cast_nullable_to_non_nullable
              as String,
      saleDate: null == saleDate
          ? _value.saleDate
          : saleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncedAt: freezed == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaleModelImplCopyWith<$Res>
    implements $SaleModelCopyWith<$Res> {
  factory _$$SaleModelImplCopyWith(
          _$SaleModelImpl value, $Res Function(_$SaleModelImpl) then) =
      __$$SaleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String shopId,
      String? shopName,
      String saleNumber,
      List<SaleItemModel> items,
      double subtotal,
      double discountAmount,
      double discountPercent,
      double taxAmount,
      double totalAmount,
      double amountPaid,
      double changeGiven,
      @JsonKey(name: 'paymentMethod') String paymentMethodString,
      @JsonKey(name: 'currency') String currencyCode,
      String? paymentReference,
      @JsonKey(name: 'status') String statusString,
      String? customerId,
      String? customerName,
      String? customerPhone,
      String? notes,
      String soldBy,
      String soldByName,
      DateTime saleDate,
      DateTime? syncedAt,
      bool isSynced});
}

/// @nodoc
class __$$SaleModelImplCopyWithImpl<$Res>
    extends _$SaleModelCopyWithImpl<$Res, _$SaleModelImpl>
    implements _$$SaleModelImplCopyWith<$Res> {
  __$$SaleModelImplCopyWithImpl(
      _$SaleModelImpl _value, $Res Function(_$SaleModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? shopId = null,
    Object? shopName = freezed,
    Object? saleNumber = null,
    Object? items = null,
    Object? subtotal = null,
    Object? discountAmount = null,
    Object? discountPercent = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? amountPaid = null,
    Object? changeGiven = null,
    Object? paymentMethodString = null,
    Object? currencyCode = null,
    Object? paymentReference = freezed,
    Object? statusString = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? notes = freezed,
    Object? soldBy = null,
    Object? soldByName = null,
    Object? saleDate = null,
    Object? syncedAt = freezed,
    Object? isSynced = null,
  }) {
    return _then(_$SaleModelImpl(
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
      shopName: freezed == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String?,
      saleNumber: null == saleNumber
          ? _value.saleNumber
          : saleNumber // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SaleItemModel>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      amountPaid: null == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as double,
      changeGiven: null == changeGiven
          ? _value.changeGiven
          : changeGiven // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethodString: null == paymentMethodString
          ? _value.paymentMethodString
          : paymentMethodString // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
      statusString: null == statusString
          ? _value.statusString
          : statusString // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      soldBy: null == soldBy
          ? _value.soldBy
          : soldBy // ignore: cast_nullable_to_non_nullable
              as String,
      soldByName: null == soldByName
          ? _value.soldByName
          : soldByName // ignore: cast_nullable_to_non_nullable
              as String,
      saleDate: null == saleDate
          ? _value.saleDate
          : saleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncedAt: freezed == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleModelImpl extends _SaleModel {
  const _$SaleModelImpl(
      {required this.id,
      required this.organizationId,
      required this.shopId,
      this.shopName,
      required this.saleNumber,
      required final List<SaleItemModel> items,
      required this.subtotal,
      this.discountAmount = 0,
      this.discountPercent = 0,
      this.taxAmount = 0,
      required this.totalAmount,
      required this.amountPaid,
      this.changeGiven = 0,
      @JsonKey(name: 'paymentMethod') required this.paymentMethodString,
      @JsonKey(name: 'currency') this.currencyCode = 'USD',
      this.paymentReference,
      @JsonKey(name: 'status') this.statusString = 'completed',
      this.customerId,
      this.customerName,
      this.customerPhone,
      this.notes,
      required this.soldBy,
      required this.soldByName,
      required this.saleDate,
      this.syncedAt,
      this.isSynced = false})
      : _items = items,
        super._();

  factory _$SaleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String shopId;
  @override
  final String? shopName;
  @override
  final String saleNumber;
  final List<SaleItemModel> _items;
  @override
  List<SaleItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double subtotal;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double discountPercent;
  @override
  @JsonKey()
  final double taxAmount;
  @override
  final double totalAmount;
  @override
  final double amountPaid;
  @override
  @JsonKey()
  final double changeGiven;
  @override
  @JsonKey(name: 'paymentMethod')
  final String paymentMethodString;
  @override
  @JsonKey(name: 'currency')
  final String currencyCode;
  @override
  final String? paymentReference;
  @override
  @JsonKey(name: 'status')
  final String statusString;
  @override
  final String? customerId;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? notes;
  @override
  final String soldBy;
  @override
  final String soldByName;
  @override
  final DateTime saleDate;
  @override
  final DateTime? syncedAt;
  @override
  @JsonKey()
  final bool isSynced;

  @override
  String toString() {
    return 'SaleModel(id: $id, organizationId: $organizationId, shopId: $shopId, shopName: $shopName, saleNumber: $saleNumber, items: $items, subtotal: $subtotal, discountAmount: $discountAmount, discountPercent: $discountPercent, taxAmount: $taxAmount, totalAmount: $totalAmount, amountPaid: $amountPaid, changeGiven: $changeGiven, paymentMethodString: $paymentMethodString, currencyCode: $currencyCode, paymentReference: $paymentReference, statusString: $statusString, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, notes: $notes, soldBy: $soldBy, soldByName: $soldByName, saleDate: $saleDate, syncedAt: $syncedAt, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.saleNumber, saleNumber) ||
                other.saleNumber == saleNumber) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.changeGiven, changeGiven) ||
                other.changeGiven == changeGiven) &&
            (identical(other.paymentMethodString, paymentMethodString) ||
                other.paymentMethodString == paymentMethodString) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference) &&
            (identical(other.statusString, statusString) ||
                other.statusString == statusString) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.soldBy, soldBy) || other.soldBy == soldBy) &&
            (identical(other.soldByName, soldByName) ||
                other.soldByName == soldByName) &&
            (identical(other.saleDate, saleDate) ||
                other.saleDate == saleDate) &&
            (identical(other.syncedAt, syncedAt) ||
                other.syncedAt == syncedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        organizationId,
        shopId,
        shopName,
        saleNumber,
        const DeepCollectionEquality().hash(_items),
        subtotal,
        discountAmount,
        discountPercent,
        taxAmount,
        totalAmount,
        amountPaid,
        changeGiven,
        paymentMethodString,
        currencyCode,
        paymentReference,
        statusString,
        customerId,
        customerName,
        customerPhone,
        notes,
        soldBy,
        soldByName,
        saleDate,
        syncedAt,
        isSynced
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleModelImplCopyWith<_$SaleModelImpl> get copyWith =>
      __$$SaleModelImplCopyWithImpl<_$SaleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleModelImplToJson(
      this,
    );
  }
}

abstract class _SaleModel extends SaleModel {
  const factory _SaleModel(
      {required final String id,
      required final String organizationId,
      required final String shopId,
      final String? shopName,
      required final String saleNumber,
      required final List<SaleItemModel> items,
      required final double subtotal,
      final double discountAmount,
      final double discountPercent,
      final double taxAmount,
      required final double totalAmount,
      required final double amountPaid,
      final double changeGiven,
      @JsonKey(name: 'paymentMethod') required final String paymentMethodString,
      @JsonKey(name: 'currency') final String currencyCode,
      final String? paymentReference,
      @JsonKey(name: 'status') final String statusString,
      final String? customerId,
      final String? customerName,
      final String? customerPhone,
      final String? notes,
      required final String soldBy,
      required final String soldByName,
      required final DateTime saleDate,
      final DateTime? syncedAt,
      final bool isSynced}) = _$SaleModelImpl;
  const _SaleModel._() : super._();

  factory _SaleModel.fromJson(Map<String, dynamic> json) =
      _$SaleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get shopId;
  @override
  String? get shopName;
  @override
  String get saleNumber;
  @override
  List<SaleItemModel> get items;
  @override
  double get subtotal;
  @override
  double get discountAmount;
  @override
  double get discountPercent;
  @override
  double get taxAmount;
  @override
  double get totalAmount;
  @override
  double get amountPaid;
  @override
  double get changeGiven;
  @override
  @JsonKey(name: 'paymentMethod')
  String get paymentMethodString;
  @override
  @JsonKey(name: 'currency')
  String get currencyCode;
  @override
  String? get paymentReference;
  @override
  @JsonKey(name: 'status')
  String get statusString;
  @override
  String? get customerId;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get notes;
  @override
  String get soldBy;
  @override
  String get soldByName;
  @override
  DateTime get saleDate;
  @override
  DateTime? get syncedAt;
  @override
  bool get isSynced;
  @override
  @JsonKey(ignore: true)
  _$$SaleModelImplCopyWith<_$SaleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleItemModel _$SaleItemModelFromJson(Map<String, dynamic> json) {
  return _SaleItemModel.fromJson(json);
}

/// @nodoc
mixin _$SaleItemModel {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get costPrice => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SaleItemModelCopyWith<SaleItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleItemModelCopyWith<$Res> {
  factory $SaleItemModelCopyWith(
          SaleItemModel value, $Res Function(SaleItemModel) then) =
      _$SaleItemModelCopyWithImpl<$Res, SaleItemModel>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? barcode,
      int quantity,
      double unitPrice,
      double costPrice,
      double discountAmount,
      double totalPrice});
}

/// @nodoc
class _$SaleItemModelCopyWithImpl<$Res, $Val extends SaleItemModel>
    implements $SaleItemModelCopyWith<$Res> {
  _$SaleItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? costPrice = null,
    Object? discountAmount = null,
    Object? totalPrice = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      costPrice: null == costPrice
          ? _value.costPrice
          : costPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaleItemModelImplCopyWith<$Res>
    implements $SaleItemModelCopyWith<$Res> {
  factory _$$SaleItemModelImplCopyWith(
          _$SaleItemModelImpl value, $Res Function(_$SaleItemModelImpl) then) =
      __$$SaleItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String? sku,
      String? barcode,
      int quantity,
      double unitPrice,
      double costPrice,
      double discountAmount,
      double totalPrice});
}

/// @nodoc
class __$$SaleItemModelImplCopyWithImpl<$Res>
    extends _$SaleItemModelCopyWithImpl<$Res, _$SaleItemModelImpl>
    implements _$$SaleItemModelImplCopyWith<$Res> {
  __$$SaleItemModelImplCopyWithImpl(
      _$SaleItemModelImpl _value, $Res Function(_$SaleItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? costPrice = null,
    Object? discountAmount = null,
    Object? totalPrice = null,
  }) {
    return _then(_$SaleItemModelImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      costPrice: null == costPrice
          ? _value.costPrice
          : costPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleItemModelImpl extends _SaleItemModel {
  const _$SaleItemModelImpl(
      {required this.productId,
      required this.productName,
      this.sku,
      this.barcode,
      required this.quantity,
      required this.unitPrice,
      required this.costPrice,
      this.discountAmount = 0,
      required this.totalPrice})
      : super._();

  factory _$SaleItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleItemModelImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? sku;
  @override
  final String? barcode;
  @override
  final int quantity;
  @override
  final double unitPrice;
  @override
  final double costPrice;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  final double totalPrice;

  @override
  String toString() {
    return 'SaleItemModel(productId: $productId, productName: $productName, sku: $sku, barcode: $barcode, quantity: $quantity, unitPrice: $unitPrice, costPrice: $costPrice, discountAmount: $discountAmount, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleItemModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.costPrice, costPrice) ||
                other.costPrice == costPrice) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName, sku,
      barcode, quantity, unitPrice, costPrice, discountAmount, totalPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleItemModelImplCopyWith<_$SaleItemModelImpl> get copyWith =>
      __$$SaleItemModelImplCopyWithImpl<_$SaleItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleItemModelImplToJson(
      this,
    );
  }
}

abstract class _SaleItemModel extends SaleItemModel {
  const factory _SaleItemModel(
      {required final String productId,
      required final String productName,
      final String? sku,
      final String? barcode,
      required final int quantity,
      required final double unitPrice,
      required final double costPrice,
      final double discountAmount,
      required final double totalPrice}) = _$SaleItemModelImpl;
  const _SaleItemModel._() : super._();

  factory _SaleItemModel.fromJson(Map<String, dynamic> json) =
      _$SaleItemModelImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get sku;
  @override
  String? get barcode;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get costPrice;
  @override
  double get discountAmount;
  @override
  double get totalPrice;
  @override
  @JsonKey(ignore: true)
  _$$SaleItemModelImplCopyWith<_$SaleItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailySalesSummary _$DailySalesSummaryFromJson(Map<String, dynamic> json) {
  return _DailySalesSummary.fromJson(json);
}

/// @nodoc
mixin _$DailySalesSummary {
  DateTime get date => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  String get shopName => throw _privateConstructorUsedError;
  int get totalTransactions => throw _privateConstructorUsedError;
  double get totalSales => throw _privateConstructorUsedError;
  double get totalProfit => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  double get cashSales => throw _privateConstructorUsedError;
  double get mobileMoneySales => throw _privateConstructorUsedError;
  double get cardSales => throw _privateConstructorUsedError;
  double get averageTransactionValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailySalesSummaryCopyWith<DailySalesSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailySalesSummaryCopyWith<$Res> {
  factory $DailySalesSummaryCopyWith(
          DailySalesSummary value, $Res Function(DailySalesSummary) then) =
      _$DailySalesSummaryCopyWithImpl<$Res, DailySalesSummary>;
  @useResult
  $Res call(
      {DateTime date,
      String shopId,
      String shopName,
      int totalTransactions,
      double totalSales,
      double totalProfit,
      int totalItems,
      double cashSales,
      double mobileMoneySales,
      double cardSales,
      double averageTransactionValue});
}

/// @nodoc
class _$DailySalesSummaryCopyWithImpl<$Res, $Val extends DailySalesSummary>
    implements $DailySalesSummaryCopyWith<$Res> {
  _$DailySalesSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? shopId = null,
    Object? shopName = null,
    Object? totalTransactions = null,
    Object? totalSales = null,
    Object? totalProfit = null,
    Object? totalItems = null,
    Object? cashSales = null,
    Object? mobileMoneySales = null,
    Object? cardSales = null,
    Object? averageTransactionValue = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      totalTransactions: null == totalTransactions
          ? _value.totalTransactions
          : totalTransactions // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalProfit: null == totalProfit
          ? _value.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as double,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      cashSales: null == cashSales
          ? _value.cashSales
          : cashSales // ignore: cast_nullable_to_non_nullable
              as double,
      mobileMoneySales: null == mobileMoneySales
          ? _value.mobileMoneySales
          : mobileMoneySales // ignore: cast_nullable_to_non_nullable
              as double,
      cardSales: null == cardSales
          ? _value.cardSales
          : cardSales // ignore: cast_nullable_to_non_nullable
              as double,
      averageTransactionValue: null == averageTransactionValue
          ? _value.averageTransactionValue
          : averageTransactionValue // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailySalesSummaryImplCopyWith<$Res>
    implements $DailySalesSummaryCopyWith<$Res> {
  factory _$$DailySalesSummaryImplCopyWith(_$DailySalesSummaryImpl value,
          $Res Function(_$DailySalesSummaryImpl) then) =
      __$$DailySalesSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      String shopId,
      String shopName,
      int totalTransactions,
      double totalSales,
      double totalProfit,
      int totalItems,
      double cashSales,
      double mobileMoneySales,
      double cardSales,
      double averageTransactionValue});
}

/// @nodoc
class __$$DailySalesSummaryImplCopyWithImpl<$Res>
    extends _$DailySalesSummaryCopyWithImpl<$Res, _$DailySalesSummaryImpl>
    implements _$$DailySalesSummaryImplCopyWith<$Res> {
  __$$DailySalesSummaryImplCopyWithImpl(_$DailySalesSummaryImpl _value,
      $Res Function(_$DailySalesSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? shopId = null,
    Object? shopName = null,
    Object? totalTransactions = null,
    Object? totalSales = null,
    Object? totalProfit = null,
    Object? totalItems = null,
    Object? cashSales = null,
    Object? mobileMoneySales = null,
    Object? cardSales = null,
    Object? averageTransactionValue = null,
  }) {
    return _then(_$DailySalesSummaryImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      totalTransactions: null == totalTransactions
          ? _value.totalTransactions
          : totalTransactions // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalProfit: null == totalProfit
          ? _value.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as double,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      cashSales: null == cashSales
          ? _value.cashSales
          : cashSales // ignore: cast_nullable_to_non_nullable
              as double,
      mobileMoneySales: null == mobileMoneySales
          ? _value.mobileMoneySales
          : mobileMoneySales // ignore: cast_nullable_to_non_nullable
              as double,
      cardSales: null == cardSales
          ? _value.cardSales
          : cardSales // ignore: cast_nullable_to_non_nullable
              as double,
      averageTransactionValue: null == averageTransactionValue
          ? _value.averageTransactionValue
          : averageTransactionValue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailySalesSummaryImpl implements _DailySalesSummary {
  const _$DailySalesSummaryImpl(
      {required this.date,
      required this.shopId,
      required this.shopName,
      required this.totalTransactions,
      required this.totalSales,
      required this.totalProfit,
      required this.totalItems,
      required this.cashSales,
      required this.mobileMoneySales,
      required this.cardSales,
      required this.averageTransactionValue});

  factory _$DailySalesSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailySalesSummaryImplFromJson(json);

  @override
  final DateTime date;
  @override
  final String shopId;
  @override
  final String shopName;
  @override
  final int totalTransactions;
  @override
  final double totalSales;
  @override
  final double totalProfit;
  @override
  final int totalItems;
  @override
  final double cashSales;
  @override
  final double mobileMoneySales;
  @override
  final double cardSales;
  @override
  final double averageTransactionValue;

  @override
  String toString() {
    return 'DailySalesSummary(date: $date, shopId: $shopId, shopName: $shopName, totalTransactions: $totalTransactions, totalSales: $totalSales, totalProfit: $totalProfit, totalItems: $totalItems, cashSales: $cashSales, mobileMoneySales: $mobileMoneySales, cardSales: $cardSales, averageTransactionValue: $averageTransactionValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailySalesSummaryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.totalTransactions, totalTransactions) ||
                other.totalTransactions == totalTransactions) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.cashSales, cashSales) ||
                other.cashSales == cashSales) &&
            (identical(other.mobileMoneySales, mobileMoneySales) ||
                other.mobileMoneySales == mobileMoneySales) &&
            (identical(other.cardSales, cardSales) ||
                other.cardSales == cardSales) &&
            (identical(
                    other.averageTransactionValue, averageTransactionValue) ||
                other.averageTransactionValue == averageTransactionValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      shopId,
      shopName,
      totalTransactions,
      totalSales,
      totalProfit,
      totalItems,
      cashSales,
      mobileMoneySales,
      cardSales,
      averageTransactionValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailySalesSummaryImplCopyWith<_$DailySalesSummaryImpl> get copyWith =>
      __$$DailySalesSummaryImplCopyWithImpl<_$DailySalesSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailySalesSummaryImplToJson(
      this,
    );
  }
}

abstract class _DailySalesSummary implements DailySalesSummary {
  const factory _DailySalesSummary(
      {required final DateTime date,
      required final String shopId,
      required final String shopName,
      required final int totalTransactions,
      required final double totalSales,
      required final double totalProfit,
      required final int totalItems,
      required final double cashSales,
      required final double mobileMoneySales,
      required final double cardSales,
      required final double averageTransactionValue}) = _$DailySalesSummaryImpl;

  factory _DailySalesSummary.fromJson(Map<String, dynamic> json) =
      _$DailySalesSummaryImpl.fromJson;

  @override
  DateTime get date;
  @override
  String get shopId;
  @override
  String get shopName;
  @override
  int get totalTransactions;
  @override
  double get totalSales;
  @override
  double get totalProfit;
  @override
  int get totalItems;
  @override
  double get cashSales;
  @override
  double get mobileMoneySales;
  @override
  double get cardSales;
  @override
  double get averageTransactionValue;
  @override
  @JsonKey(ignore: true)
  _$$DailySalesSummaryImplCopyWith<_$DailySalesSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
