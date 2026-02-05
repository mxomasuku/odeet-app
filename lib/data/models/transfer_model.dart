import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

@freezed
class TransferModel with _$TransferModel {
  const factory TransferModel({
    required String id,
    required String organizationId,
    required String transferNumber,
    required String sourceShopId,
    required String sourceShopName,
    required String destinationShopId,
    required String destinationShopName,
    required List<TransferItemModel> items,
    @JsonKey(name: 'status') required String statusString,
    String? notes,
    // Created by
    required String createdBy,
    required String createdByName,
    required DateTime createdAt,
    // Dispatched
    String? dispatchedBy,
    String? dispatchedByName,
    DateTime? dispatchedAt,
    // Received
    String? receivedBy,
    String? receivedByName,
    DateTime? receivedAt,
    // Confirmed
    String? confirmedBy,
    String? confirmedByName,
    DateTime? confirmedAt,
    // Rejection
    String? rejectionReason,
    String? rejectedBy,
    DateTime? rejectedAt,
    // Approved (by manager/owner)
    String? approvedBy,
    String? approvedByName,
    DateTime? approvedAt,
    // Sync
    DateTime? syncedAt,
    @Default(false) bool isSynced,
  }) = _TransferModel;

  const TransferModel._();

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);

  TransferStatus get status => TransferStatus.values.firstWhere(
        (s) => s.name == statusString,
        orElse: () => TransferStatus.pending,
      );

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalValue =>
      items.fold(0.0, (sum, item) => sum + item.totalValue);

  bool get canDispatch =>
      status == TransferStatus.pending && approvedBy != null;
  bool get canReceive => status == TransferStatus.inTransit;
  bool get canConfirm => status == TransferStatus.delivered;
  bool get canReject =>
      status == TransferStatus.pending || status == TransferStatus.inTransit;
  bool get canCancel => status == TransferStatus.pending;

  bool get isApproved => approvedBy != null;
  bool get needsApproval =>
      status == TransferStatus.pending && approvedBy == null;

  bool get isCompleted =>
      status == TransferStatus.confirmed ||
      status == TransferStatus.rejected ||
      status == TransferStatus.cancelled;
}

@freezed
class TransferItemModel with _$TransferItemModel {
  const factory TransferItemModel({
    required String productId,
    required String productName,
    String? sku,
    String? barcode,
    required int quantity,
    required double unitCost,
    int? receivedQuantity,
    String? receivedNotes,
  }) = _TransferItemModel;

  const TransferItemModel._();

  factory TransferItemModel.fromJson(Map<String, dynamic> json) =>
      _$TransferItemModelFromJson(json);

  double get totalValue => quantity * unitCost;

  bool get hasDiscrepancy =>
      receivedQuantity != null && receivedQuantity != quantity;

  int get discrepancy => (receivedQuantity ?? quantity) - quantity;
}
