import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/auth_controller.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../providers/theme_mode_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final orgAsync = ref.watch(currentOrganizationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Profile section
          userAsync.when(
            data: (user) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(user?.name.substring(0, 1).toUpperCase() ?? 'U'),
              ),
              title: Text(user?.name ?? 'User'),
              subtitle: Text(user?.email ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            loading: () => const ListTile(title: Text('Loading...')),
            error: (_, __) =>
                const ListTile(title: Text('Error loading profile')),
          ),
          const Divider(),

          // Organization
          _buildSectionHeader('Organization'),
          orgAsync.when(
            data: (org) => Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Business Name'),
                  subtitle: Text(org?.name ?? 'Not set'),
                  onTap: () {},
                ),
                if (userAsync.valueOrNull?.isOwner == true)
                  ListTile(
                    leading: const Icon(Icons.store),
                    title: const Text('Manage Shops'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.shopOnboarding),
                  ),
                if (userAsync.valueOrNull?.isOwner == true ||
                    userAsync.valueOrNull?.isManager == true)
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Manage Users'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.manageUsers),
                  ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(),

          // App settings
          _buildSectionHeader('App Settings'),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Currency'),
            subtitle: const Text('USD'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(
              ref.read(themeModeProvider.notifier).state == ThemeMode.dark
                  ? 'Dark Mode'
                  : 'Light Mode',
            ),
            trailing: Switch(
              value: ref.watch(themeModeProvider) == ThemeMode.dark,
              onChanged: (isDark) {
                ref.read(themeModeProvider.notifier).state =
                    isDark ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          const Divider(),

          // Subscription
          _buildSectionHeader('Subscription'),
          orgAsync.when(
            data: (org) => ListTile(
              leading: const Icon(Icons.card_membership),
              title: const Text('Current Plan'),
              subtitle: Text(
                org?.isOnTrial == true
                    ? 'Trial (${org?.trialDaysRemaining} days left)'
                    : org?.subscriptionTier.name ?? 'Free',
              ),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Upgrade'),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(),

          // Support
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: const Text('Contact Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {},
          ),
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.errorColor),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: AppTheme.errorColor),
            ),
            onTap: () => _handleLogout(context, ref),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmLabel: 'Sign Out',
      isDangerous: true,
    );

    if (confirmed) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }
}
