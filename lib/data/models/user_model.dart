import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    String? phone,
    String? avatarUrl,
    @Default('') String organizationId,
    @JsonKey(name: 'role') @Default('shopkeeper') String roleString,
    @Default(<String>[]) List<String> roles, // RBAC roles from custom claims
    List<String>? shopIds,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    @Default(true) bool isActive,
    @Default(false) bool isBlocked,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserRole get role => UserRole.values.firstWhere(
        (r) => r.name == roleString,
        orElse: () => UserRole.shopkeeper,
      );

  // --- RBAC Permission Helpers ---

  /// Check if user has a specific role
  bool hasRole(String roleName) =>
      roles.contains(roleName) || roleString == roleName;

  bool get isOwner => hasRole('owner');
  bool get isManager => hasRole('manager') || isOwner;
  bool get isAuditor => hasRole('auditor');
  bool get isShopkeeper => hasRole('shopkeeper');

  // Permissions
  bool get canAddStock => isOwner || isManager || isShopkeeper;
  bool get canRecordSales => isOwner || isManager || isShopkeeper;
  bool get canRequestTransfer => isOwner || isManager || isShopkeeper;
  bool get canApproveTransfer => isOwner || isManager;
  bool get canViewLedger => isOwner || isManager || isAuditor;
  bool get canEditLedger => isOwner || isAuditor;
  bool get canManageUsers => isOwner;
  bool get canViewReports => isOwner || isManager || isAuditor;
}

@freezed
class OrganizationModel with _$OrganizationModel {
  const factory OrganizationModel({
    required String id,
    required String name,
    String? logoUrl,
    @Default('') String ownerId,
    @Default('') String ownerEmail,
    @JsonKey(name: 'currency') @Default('USD') String currencyCode,
    @Default('Africa/Harare') String timezone,
    required DateTime createdAt,
    DateTime? trialStartDate,
    @JsonKey(name: 'subscriptionTier') String? subscriptionTierString,
    DateTime? subscriptionExpiresAt,
    @Default({}) Map<String, dynamic> settings,
  }) = _OrganizationModel;

  const OrganizationModel._();

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);

  Currency get currency => Currency.values.firstWhere(
        (c) => c.code == currencyCode,
        orElse: () => Currency.usd,
      );

  SubscriptionTier get subscriptionTier => SubscriptionTier.values.firstWhere(
        (t) => t.name == subscriptionTierString,
        orElse: () => SubscriptionTier.trial,
      );

  bool get isOnTrial => subscriptionTier == SubscriptionTier.trial;

  bool get isTrialExpired {
    if (!isOnTrial || trialStartDate == null) return false;
    final expiryDate = trialStartDate!.add(
      const Duration(days: AppConstants.trialDurationDays),
    );
    return DateTime.now().isAfter(expiryDate);
  }

  int get trialDaysRemaining {
    if (!isOnTrial || trialStartDate == null) return 0;
    final expiryDate = trialStartDate!.add(
      const Duration(days: AppConstants.trialDurationDays),
    );
    final remaining = expiryDate.difference(DateTime.now()).inDays;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isSubscriptionActive {
    if (isOnTrial) return !isTrialExpired;
    if (subscriptionExpiresAt == null) return false;
    return DateTime.now().isBefore(subscriptionExpiresAt!);
  }
}
