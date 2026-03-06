import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_model.freezed.dart';
part 'invite_model.g.dart';

enum InviteStatus {
  pending('Pending'),
  accepted('Accepted'),
  expired('Expired'),
  cancelled('Cancelled');

  final String displayName;
  const InviteStatus(this.displayName);
}

@freezed
class InviteModel with _$InviteModel {
  const factory InviteModel({
    required String id,
    required String organizationId,
    required String code,
    required String email,
    required String role,
    @Default(<String>[]) List<String> shopIds,
    required String createdBy,
    required String createdByName,
    required DateTime createdAt,
    required DateTime expiresAt,
    @Default('pending') String status,
    String? acceptedBy,
    DateTime? acceptedAt,
  }) = _InviteModel;

  const InviteModel._();

  factory InviteModel.fromJson(Map<String, dynamic> json) =>
      _$InviteModelFromJson(json);

  InviteStatus get inviteStatus => InviteStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => InviteStatus.pending,
      );

  bool get isPending => inviteStatus == InviteStatus.pending;
  bool get isAccepted => inviteStatus == InviteStatus.accepted;
  bool get isExpired =>
      inviteStatus == InviteStatus.expired || DateTime.now().isAfter(expiresAt);
  bool get isValid => isPending && !isExpired;

  String get inviteLink => 'stocktake://invite?code=$code';

  /// Days until expiration (or 0 if expired)
  int get daysRemaining {
    final diff = expiresAt.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }
}
