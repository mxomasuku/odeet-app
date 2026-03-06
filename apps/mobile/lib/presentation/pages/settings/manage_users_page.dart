import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../widgets/common/requires_network_widget.dart';

/// Provider for fetching organization invites
/// Provider for fetching organization invites
final orgInvitesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null || user.organizationId.isEmpty) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('organizations')
      .doc(user.organizationId)
      .collection('invites')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            ...data,
            // Convert timestamps to ISO strings for consistency with UI
            'createdAt':
                (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
            'expiresAt':
                (data['expiresAt'] as Timestamp?)?.toDate().toIso8601String(),
            'acceptedAt':
                (data['acceptedAt'] as Timestamp?)?.toDate().toIso8601String(),
          };
        }).toList(),
      );
});

/// Provider for fetching organization users
final orgUsersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null || user.organizationId.isEmpty) return [];

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('organizationId', isEqualTo: user.organizationId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'],
        'email': data['email'],
        'role': data['role'] ?? 'shopkeeper',
        'isCurrentUser': doc.id == user.id,
        'isBlocked': data['isBlocked'] ?? false,
      };
    }).toList();
  } catch (e) {
    debugPrint('Error fetching org users: $e');
    return [];
  }
});

class ManageUsersPage extends ConsumerStatefulWidget {
  const ManageUsersPage({super.key});

  @override
  ConsumerState<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends ConsumerState<ManageUsersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final canInvite = user?.isOwner == true || user?.isManager == true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Team'),
            Tab(text: 'Invites'),
          ],
        ),
      ),
      body: RequiresNetworkWidget(
        message: 'Managing users requires an internet connection',
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTeamTab(),
            _buildInvitesTab(),
          ],
        ),
      ),
      floatingActionButton: canInvite
          ? FloatingActionButton.extended(
              onPressed: () => _showInviteDialog(context),
              icon: const Icon(Icons.person_add),
              label: const Text('Invite'),
            )
          : null,
    );
  }

  Widget _buildTeamTab() {
    final usersAsync = ref.watch(orgUsersProvider);
    final user =
        ref.watch(currentUserProvider).valueOrNull; // Re-fetch user here
    final canInvite = user?.isOwner == true || user?.isManager == true;

    return usersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(child: Text('No team members yet'));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final member = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  (member['name'] as String? ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    member['name'] ?? 'Unknown',
                    style: member['isBlocked'] == true
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  if (member['isBlocked'] == true)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'BLOCKED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Text(member['email'] ?? ''),
              onTap: () {
                if (user?.isOwner == true && member['id'] != user?.id) {
                  _showUserActions(context, member);
                }
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chip(
                    label: Text(
                      (member['role'] as String? ?? 'user').toUpperCase(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  if (user?.isOwner == true && member['id'] != user?.id)
                    Icon(Icons.more_vert, color: Colors.grey[400]),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildInvitesTab() {
    final invitesAsync = ref.watch(orgInvitesProvider);

    return invitesAsync.when(
      data: (invites) {
        if (invites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text('No invites sent yet'),
                const SizedBox(height: 8),
                Text(
                  'Tap the button below to invite team members',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: invites.length,
          itemBuilder: (context, index) {
            final invite = invites[index];
            final status = invite['status'] as String? ?? 'pending';
            final isPending = status == 'pending';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isPending
                      ? AppTheme.warningColor
                      : status == 'accepted'
                          ? AppTheme.successColor
                          : Colors.grey,
                  child: Icon(
                    isPending
                        ? Icons.hourglass_top
                        : status == 'accepted'
                            ? Icons.check
                            : Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(invite['email'] ?? ''),
                subtitle:
                    Text('Role: ${invite['role']} • ${status.toUpperCase()}'),
                trailing: isPending
                    ? IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () =>
                            _copyInviteCode(invite['code'] as String?),
                        tooltip: 'Copy invite code',
                      )
                    : null,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  void _copyInviteCode(String? code) {
    if (code == null) return;
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invite code copied: $code'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  Future<void> _showInviteDialog(BuildContext context) async {
    final emailController = TextEditingController();
    String selectedRole = 'shopkeeper';
    final List<String> selectedShopIds = [];
    bool isLoading = false;
    String? resultCode;

    // Fetch shops for selection
    final shopsFn = ref.read(shopRepositoryProvider).getShops();
    // We'll await this in the builder or future builder, but for dialog simplicity,
    // let's fetch it if we switch to shopkeeper role or just fetch upfront.
    // Actually, let's use a FutureBuilder inside the dialog content if possible,
    // or just fetch it here before showing dialog (simpler UI).
    // Given the context is async, let's try fetching first for smoother UX.
    LoadingOverlay.show(context);
    List<ShopModel> availableShops = [];
    try {
      availableShops = await shopsFn;
    } catch (e) {
      debugPrint('Error fetching shops: $e');
    } finally {
      if (context.mounted) LoadingOverlay.hide(context); // Dismiss loading
    }

    if (!context.mounted) return;

    final user = ref.read(currentUserProvider).valueOrNull;
    final isOwner = user?.isOwner ?? false;

    final availableRoles = isOwner
        ? ['manager', 'shopkeeper', 'auditor']
        : ['shopkeeper', 'auditor'];

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Invite Team Member'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (resultCode != null) ...[
                    // Show result
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.successColor,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          const Text('Invite Created!'),
                          const SizedBox(height: 16),
                          Text(
                            resultCode!,
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Share this code with the invitee',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Input form
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: availableRoles
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(r[0].toUpperCase() + r.substring(1)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedRole = v);
                        }
                      },
                    ),
                    if (selectedRole == 'shopkeeper') ...[
                      const SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Assign to Shops',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 150),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: availableShops.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('No shops available'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: availableShops.length,
                                itemBuilder: (context, index) {
                                  final shop = availableShops[index];
                                  final isSelected =
                                      selectedShopIds.contains(shop.id);
                                  return CheckboxListTile(
                                    title: Text(shop.name),
                                    value: isSelected,
                                    dense: true,
                                    onChanged: (checked) {
                                      setDialogState(() {
                                        if (checked == true) {
                                          selectedShopIds.add(shop.id);
                                        } else {
                                          selectedShopIds.remove(shop.id);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(resultCode != null ? 'Done' : 'Cancel'),
            ),
            if (resultCode != null)
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: resultCode!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied!')),
                  );
                },
                child: const Text('Copy Code'),
              )
            else
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (emailController.text.isEmpty) return;

                        setDialogState(() => isLoading = true);
                        try {
                          final callable = FirebaseFunctions.instance
                              .httpsCallable('createInvite');
                          final result = await callable.call({
                            'email': emailController.text,
                            'role': selectedRole,
                            'shopIds': selectedRole == 'shopkeeper'
                                ? selectedShopIds
                                : [],
                          });

                          final data = result.data as Map<String, dynamic>;
                          setDialogState(() {
                            resultCode = data['code'] as String?;
                            isLoading = false;
                          });

                          // Refresh not needed with StreamProvider
                          // ref.invalidate(orgInvitesProvider);
                        } catch (e) {
                          // Close dialog first so user can see the error
                          setDialogState(() => isLoading = false);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: AppTheme.errorColor,
                              ),
                            );
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Generate Invite'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showUserActions(
    BuildContext context,
    Map<String, dynamic> userMap,
  ) async {
    final userId = userMap['id'] as String;
    final userName = userMap['name'] as String;
    final userEmail = userMap['email'] as String;
    final currentRole = userMap['role'] as String;
    final isBlocked = userMap['isBlocked'] as bool? ?? false;

    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(userName),
              subtitle: Text(userEmail),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Change Role'),
              onTap: () {
                Navigator.pop(context);
                _showChangeRoleDialog(context, userId, userName, currentRole);
              },
            ),
            ListTile(
              leading: Icon(
                isBlocked ? Icons.check_circle_outline : Icons.block_outlined,
                color: isBlocked ? Colors.green : AppTheme.errorColor,
              ),
              title: Text(
                isBlocked ? 'Unblock User' : 'Block User from Organization',
                style: TextStyle(
                  color: isBlocked ? Colors.green : AppTheme.errorColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmToggleBlockUser(context, userId, userName, !isBlocked);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showChangeRoleDialog(
    BuildContext context,
    String userId,
    String userName,
    String currentRole,
  ) async {
    String selectedRole = currentRole;
    bool isLoading = false;
    List<String> selectedShopIds = [];
    List<ShopModel> availableShops = [];
    bool isFetchingShops = true;

    // Fetch shops and user's current shops
    try {
      final shops = await ref.read(shopRepositoryProvider).getShops();
      availableShops = shops;

      // Get target user's current shop assignments
      // We can't get this from the list tile easily as it's not in the map
      // So we fetch the user doc specifically or just default to empty
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final data = userDoc.data();
      if (data != null && data['shopIds'] != null) {
        selectedShopIds = List<String>.from(data['shopIds']);
      }
    } catch (e) {
      debugPrint('Error fetching user details or shops: $e');
    } finally {
      if (context.mounted) {
        // This update will happen inside the StatefulBuilder of the dialog if we move this logic there
        // But since we are PRE-fetching before showing dialog, we are fine.
        isFetchingShops = false;
      }
    }

    // Available roles
    final roles = ['manager', 'shopkeeper', 'auditor'];

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Change Role for $userName'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: roles.contains(selectedRole)
                        ? selectedRole
                        : roles.first,
                    decoration: const InputDecoration(labelText: 'New Role'),
                    items: roles
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(r[0].toUpperCase() + r.substring(1)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setDialogState(() => selectedRole = v!),
                  ),
                  if (selectedRole == 'shopkeeper' ||
                      selectedRole == 'auditor') ...[
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Assign to Shops',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: isFetchingShops
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : availableShops.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('No shops available'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: availableShops.length,
                                  itemBuilder: (context, index) {
                                    final shop = availableShops[index];
                                    final isSelected =
                                        selectedShopIds.contains(shop.id);
                                    return CheckboxListTile(
                                      title: Text(shop.name),
                                      value: isSelected,
                                      dense: true,
                                      onChanged: (checked) {
                                        setDialogState(() {
                                          if (checked == true) {
                                            selectedShopIds.add(shop.id);
                                          } else {
                                            selectedShopIds.remove(shop.id);
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading || isFetchingShops
                  ? null
                  : () async {
                      setDialogState(() => isLoading = true);
                      try {
                        final callable = FirebaseFunctions.instance
                            .httpsCallable('setUserRoles');
                        await callable.call({
                          'uid': userId,
                          'roles': [selectedRole],
                          'shopIds': (selectedRole == 'shopkeeper' ||
                                  selectedRole == 'auditor')
                              ? selectedShopIds
                              : [],
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Role and access updated successfully',
                              ),
                              backgroundColor: AppTheme.successColor,
                            ),
                          );
                          ref.invalidate(orgUsersProvider);
                        }
                      } catch (e) {
                        setDialogState(() => isLoading = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: AppTheme.errorColor,
                            ),
                          );
                        }
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmToggleBlockUser(
    BuildContext context,
    String userId,
    String userName,
    bool shouldBlock,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(shouldBlock ? 'Block User?' : 'Unblock User?'),
        content: Text(
          shouldBlock
              ? 'Are you sure you want to block $userName? They will remain in the list but lose all access immediately.'
              : 'Are you sure you want to unblock $userName? They will regain access to the organization.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: shouldBlock ? AppTheme.errorColor : Colors.green,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(shouldBlock ? 'Block' : 'Unblock'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      LoadingOverlay.show(context);
      try {
        final callable =
            FirebaseFunctions.instance.httpsCallable('toggleUserBlockStatus');
        await callable.call({
          'uid': userId,
          'isBlocked': shouldBlock,
        });

        if (context.mounted) {
          LoadingOverlay.hide(context); // Dismiss loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'User ${shouldBlock ? 'blocked' : 'unblocked'} successfully',
              ),
              backgroundColor: AppTheme.successColor,
            ),
          );
          ref.invalidate(orgUsersProvider);
        }
      } catch (e) {
        if (context.mounted) {
          LoadingOverlay.hide(context); // Dismiss loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }
}
