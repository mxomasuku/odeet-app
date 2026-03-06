import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../widgets/common/loading_button.dart';
import '../../../core/utils/validators.dart';

import '../../controllers/auth_controller.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';

import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/transfer_repository.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../data/models/shop_model.dart';
import '../../widgets/tutorial/tutorial_overlay.dart';
import '../../widgets/common/sync_status_widget.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final orgAsync = ref.watch(currentOrganizationProvider);
    final shopsAsync = ref.watch(shopsStreamProvider);
    final lowStockCountAsync = ref.watch(lowStockCountProvider);
    final pendingTransfersAsync = ref.watch(pendingTransfersCountProvider);

    // Show loading if user or organization is not yet loaded
    if (userAsync.valueOrNull == null || orgAsync.valueOrNull == null) {
      if (userAsync.isLoading || orgAsync.isLoading) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading your profile...'),
              ],
            ),
          ),
        );
      }

      if (userAsync.hasError || orgAsync.hasError) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Unable to load profile',
                    style: AppTextStyles.heading3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This may be due to a poor internet connection.\nWe are trying to synchronize your data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(currentUserProvider);
                      ref.invalidate(currentOrganizationProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).signOut(),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Only show SetupAccountView if we are NOT loading AND have NO error, logic implies "User exists in Auth but not in Firestore"
      return const SetupAccountView();
    }

    // Check if user has shops - if not, show onboarding prompt (or empty state for non-owners)
    final shops = shopsAsync.valueOrNull ?? [];
    if (shops.isEmpty && !shopsAsync.isLoading) {
      final isOwnerOrManager = userAsync.valueOrNull?.isOwner == true ||
          userAsync.valueOrNull?.isManager == true;

      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isOwnerOrManager
                        ? AppTheme.primaryColor.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isOwnerOrManager ? Icons.store : Icons.store_mall_directory,
                    size: 64,
                    color:
                        isOwnerOrManager ? AppTheme.primaryColor : Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isOwnerOrManager ? 'Welcome to Odeet!' : 'No Shops Assigned',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isOwnerOrManager
                      ? 'To get started, add your first shop'
                      : 'You haven\'t been assigned to any shops yet.\nPlease contact your organization owner.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (isOwnerOrManager)
                  ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.shopOnboarding),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Your First Shop'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: () {
                      // Optional: Add refresh or logout
                      ref.invalidate(shopsStreamProvider);
                      ref.read(authControllerProvider.notifier).signOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // Check if tutorial should be shown
    final tutorialShown = ref.watch(tutorialShownProvider).valueOrNull ?? true;
    final showTutorial = !tutorialShown && shops.isNotEmpty;

    final dashboardScaffold = Scaffold(
      appBar: AppBar(
        title: Text(orgAsync.valueOrNull?.name ?? 'My Organization'),
        actions: [
          const SyncStatusWidget(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showAlertsBottomSheet(context, ref),
          ),
        ],
      ),
      body: shopsAsync.when(
        data: (shops) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(shopsStreamProvider);
            ref.invalidate(lowStockCountProvider);
            ref.invalidate(pendingTransfersCountProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Select a shop to manage inventory and sales',
                style:
                    AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              if (shops.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No shops found. Contact admin to create one.'),
                  ),
                )
              else
                ...shops.map((shop) => _buildShopCard(context, shop)),

              const SizedBox(height: 24),

              // Alerts
              if ((lowStockCountAsync.valueOrNull ?? 0) > 0 ||
                  (pendingTransfersAsync.valueOrNull ?? 0) > 0) ...[
                SectionHeader(
                  title: 'Alerts',
                  trailing: const Text('View All'),
                  onTrailingTap: () => _showAlertsBottomSheet(context, ref),
                ),
                const SizedBox(height: 12),
                _buildAlerts(
                  context,
                  ref,
                  lowStockCountAsync,
                  pendingTransfersAsync,
                ),
              ],
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: (userAsync.valueOrNull?.isOwner == true ||
              userAsync.valueOrNull?.isManager == true)
          ? FloatingActionButton.extended(
              onPressed: () => _showMultiShopAddDialog(context, shops),
              icon: const Icon(Icons.add_business),
              label: const Text('Add to Shops'),
            )
          : null,
    );

    // If tutorial needs to be shown, overlay it
    if (showTutorial) {
      return Stack(
        children: [
          dashboardScaffold,
          TutorialOverlay(
            onComplete: () {
              // Tutorial marking is handled internally, just need callback for rebuild
            },
          ),
        ],
      );
    }

    return dashboardScaffold;
  }

  Widget _buildAlerts(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<int> lowStockAsync,
    AsyncValue<int> pendingTransfersAsync,
  ) {
    final lowStockCount = lowStockAsync.valueOrNull ?? 0;
    final pendingCount = pendingTransfersAsync.valueOrNull ?? 0;

    if (lowStockCount == 0 && pendingCount == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.successColor),
              SizedBox(width: 12),
              Text('No alerts at this time'),
            ],
          ),
        ),
      );
    }

    final alerts = <({
      IconData icon,
      Color color,
      String title,
      String subtitle,
      VoidCallback onTap
    })>[];

    if (lowStockCount > 0) {
      alerts.add(
        (
          icon: Icons.warning_amber,
          color: AppTheme.warningColor,
          title: 'Low Stock Alert',
          subtitle:
              '$lowStockCount product${lowStockCount > 1 ? 's' : ''} below threshold',
          onTap: () => context.go(AppRoutes.inventory),
        ),
      );
    }

    if (pendingCount > 0) {
      alerts.add(
        (
          icon: Icons.swap_horiz,
          color: AppTheme.infoColor,
          title: 'Pending Transfers',
          subtitle:
              '$pendingCount transfer${pendingCount > 1 ? 's' : ''} awaiting action',
          onTap: () => context.go(AppRoutes.transfers),
        ),
      );
    }

    return Column(
      children: alerts
          .map(
            (alert) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: alert.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(alert.icon, color: alert.color),
                ),
                title: Text(alert.title),
                subtitle: Text(alert.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: alert.onTap,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildShopCard(BuildContext context, dynamic shop) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/shop/${shop.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        const Icon(Icons.store, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.name,
                          style: AppTextStyles.heading4,
                        ),
                        if (shop.code != null)
                          Text(
                            shop.code!,
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShopStat(Icons.inventory_2_outlined, 'Manage', 'Stock'),
                  _buildShopStat(Icons.point_of_sale_outlined, 'View', 'Sales'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  void _showAlertsBottomSheet(BuildContext context, WidgetRef ref) {
    final lowStockAsync = ref.read(lowStockProductsProvider);
    final pendingTransfersAsync = ref.read(pendingTransfersCountProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Alerts & Notifications',
                style: AppTextStyles.heading4,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  if ((lowStockAsync.valueOrNull?.length ?? 0) > 0) ...[
                    const Text(
                      'Low Stock Items',
                      style: AppTextStyles.heading5,
                    ),
                    const SizedBox(height: 8),
                    ...lowStockAsync.valueOrNull!.map(
                      (product) => ListTile(
                        leading: const Icon(
                          Icons.warning_amber,
                          color: AppTheme.warningColor,
                        ),
                        title: Text(product.name),
                        subtitle:
                            Text('Threshold: ${product.lowStockThreshold}'),
                        onTap: () {
                          Navigator.pop(context);
                          context.push('${AppRoutes.inventory}/${product.id}');
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if ((pendingTransfersAsync.valueOrNull ?? 0) > 0) ...[
                    const Text(
                      'Pending Transfers',
                      style: AppTextStyles.heading5,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(
                        Icons.swap_horiz,
                        color: AppTheme.infoColor,
                      ),
                      title: Text(
                        '${pendingTransfersAsync.valueOrNull} pending transfer(s)',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.transfers);
                      },
                    ),
                  ],
                  if ((lowStockAsync.valueOrNull?.length ?? 0) == 0 &&
                      (pendingTransfersAsync.valueOrNull ?? 0) == 0)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No alerts at this time'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiShopAddDialog(BuildContext context, List<ShopModel> shops) {
    if (shops.isEmpty) return;

    final selectedShops = <String>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Select Shops'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];
                final isSelected = selectedShops.contains(shop.id);
                return CheckboxListTile(
                  title: Text(shop.name),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedShops.add(shop.id);
                      } else {
                        selectedShops.remove(shop.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedShops.isEmpty
                  ? null
                  : () {
                      Navigator.pop(context);
                      final shopIdsParam = selectedShops.join(',');
                      final uri = Uri(
                        path: '${AppRoutes.inventory}/bulk-add',
                        queryParameters: {'shopIds': shopIdsParam},
                      );
                      context.push(uri.toString());
                    },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class SetupAccountView extends ConsumerStatefulWidget {
  const SetupAccountView({super.key});

  @override
  ConsumerState<SetupAccountView> createState() => _SetupAccountViewState();
}

class _SetupAccountViewState extends ConsumerState<SetupAccountView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _orgController = TextEditingController();
  bool _isLoading = false;

  final _inviteCodeController = TextEditingController();
  bool _hasInviteCode = false;

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      if (_hasInviteCode) {
        // Redeem invite code
        final callable =
            FirebaseFunctions.instance.httpsCallable('redeemInvite');
        await callable.call({
          'code': _inviteCodeController.text.toUpperCase().trim(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Joined organization successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } else {
        // Create new organization
        await ref.read(authControllerProvider.notifier).createProfile(
              uid: user.uid,
              email: user.email ?? '',
              name: _nameController.text,
              organizationName: _orgController.text,
            );
      }

      // Explicitly invalidate providers to force refresh
      ref.invalidate(currentUserProvider);
      ref.invalidate(currentOrganizationProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Account Setup Incomplete',
                  style: AppTextStyles.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please complete your profile to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                SwitchListTile(
                  value: _hasInviteCode,
                  onChanged: (value) => setState(() => _hasInviteCode = value),
                  title: const Text('I have an invite code'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                if (_hasInviteCode)
                  TextFormField(
                    controller: _inviteCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Invite Code',
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                    validator: (v) => _hasInviteCode
                        ? Validators.required(v, fieldName: 'Invite Code')
                        : null,
                  )
                else ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => Validators.required(v, fieldName: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _orgController,
                    decoration: const InputDecoration(
                      labelText: 'Business Name',
                      prefixIcon: Icon(Icons.business),
                    ),
                    validator: (v) =>
                        Validators.required(v, fieldName: 'Business Name'),
                  ),
                ],
                const SizedBox(height: 24),
                LoadingButton(
                  onPressed: _handleSubmit,
                  isLoading: _isLoading,
                  child: const Text('Complete Setup'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).signOut(),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
