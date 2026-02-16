import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/sync_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../../theme/app_theme.dart';

/// A compact widget that shows sync status in the app bar
/// Displays badge with pending count and animated sync icon
class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatusAsync = ref.watch(syncStatusStreamProvider);
    final pendingCountAsync = ref.watch(pendingSyncCountStreamProvider);
    final connectivityAsync = ref.watch(connectivityStatusProvider);

    final syncStatus = syncStatusAsync.valueOrNull ?? SyncStatus.idle;
    final pendingCount = pendingCountAsync.valueOrNull ?? 0;
    final isOffline =
        connectivityAsync.valueOrNull == ConnectivityStatus.offline;

    // Don't show widget if no pending items and online
    if (pendingCount == 0 && !isOffline && syncStatus == SyncStatus.idle) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () => _showSyncDetails(context, ref),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildIcon(syncStatus, isOffline),
          if (pendingCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isOffline ? Colors.orange : AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  pendingCount > 99 ? '99+' : pendingCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      tooltip: _getTooltip(syncStatus, pendingCount, isOffline),
    );
  }

  Widget _buildIcon(SyncStatus status, bool isOffline) {
    if (isOffline) {
      return const Icon(Icons.cloud_off, color: Colors.orange);
    }

    switch (status) {
      case SyncStatus.syncing:
        return const _AnimatedSyncIcon();
      case SyncStatus.error:
        return const Icon(Icons.sync_problem, color: Colors.red);
      case SyncStatus.completed:
        return const Icon(Icons.cloud_done, color: AppTheme.successColor);
      case SyncStatus.offline:
        return const Icon(Icons.cloud_off, color: Colors.orange);
      case SyncStatus.idle:
        return const Icon(Icons.sync, color: Colors.grey);
    }
  }

  String _getTooltip(SyncStatus status, int pendingCount, bool isOffline) {
    if (isOffline) {
      return 'Offline - $pendingCount pending';
    }
    switch (status) {
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.error:
        return 'Sync error - $pendingCount pending';
      case SyncStatus.completed:
        return 'Sync completed';
      case SyncStatus.offline:
        return 'Offline - $pendingCount pending';
      case SyncStatus.idle:
        return '$pendingCount pending sync';
    }
  }

  void _showSyncDetails(BuildContext context, WidgetRef ref) {
    // Invalidate and refetch to get fresh data
    ref.invalidate(pendingSyncItemsProvider);
    final pendingItemsAsync = ref.watch(pendingSyncItemsProvider);
    final connectivityAsync = ref.watch(connectivityStatusProvider);
    final isOffline =
        connectivityAsync.valueOrNull == ConnectivityStatus.offline;

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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isOffline ? Icons.cloud_off : Icons.sync,
                    color: isOffline ? Colors.orange : AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pending Sync',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isOffline
                              ? 'Waiting for network connection'
                              : 'Will sync automatically',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isOffline)
                    TextButton.icon(
                      onPressed: () {
                        ref.read(syncServiceProvider).syncNow();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.sync),
                      label: const Text('Sync Now'),
                    ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: pendingItemsAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_done,
                            size: 48,
                            color: AppTheme.successColor,
                          ),
                          SizedBox(height: 16),
                          Text('All synced!'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          onTap: () => _showItemDetails(context, item),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getIconColor(item).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getIconForOperation(item),
                              color: _getIconColor(item),
                              size: 20,
                            ),
                          ),
                          title: Text(item.displayName),
                          subtitle: Row(
                            children: [
                              Text(
                                item.timeAgo,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (item.retryCount > 0) ...[
                                const SizedBox(width: 8),
                                Text(
                                  'Retry ${item.retryCount}/${3}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => _confirmDelete(context, ref, item),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForOperation(SyncQueueItem item) {
    // Determine icon based on collection type
    if (item.collection.contains('sales')) {
      return Icons.point_of_sale;
    } else if (item.collection.contains('transfers')) {
      return Icons.swap_horiz;
    } else if (item.collection.contains('inventory') ||
        item.collection.contains('stock')) {
      return Icons.inventory_2;
    }
    return Icons.sync;
  }

  Color _getIconColor(SyncQueueItem item) {
    if (item.retryCount > 0) return Colors.orange;
    if (item.collection.contains('sales')) return AppTheme.successColor;
    if (item.collection.contains('transfers')) return AppTheme.infoColor;
    return AppTheme.primaryColor;
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, SyncQueueItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from queue?'),
        content: Text(
          'This will remove "${item.displayName}" from the sync queue. '
          'The data will be lost if not already saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(syncServiceProvider).removeFromQueue(item.id);
              ref.invalidate(pendingSyncItemsProvider);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(BuildContext context, SyncQueueItem item) {
    // Build a readable display of the item data
    final dataEntries = item.data.entries
        .where((e) {
          // Filter out very long or technical fields
          final key = e.key;
          return !key.contains('Id') || key == 'shopId' || key == 'productId';
        })
        .take(10)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getIconForOperation(item),
              color: _getIconColor(item),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.displayName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Created: ${item.timeAgo}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'Operation: ${item.operation.name.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...dataEntries.map((entry) {
                  String value = entry.value?.toString() ?? 'N/A';
                  if (value.length > 50) {
                    value = '${value.substring(0, 47)}...';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            '${entry.key}:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Animated rotating sync icon
class _AnimatedSyncIcon extends StatefulWidget {
  const _AnimatedSyncIcon();

  @override
  State<_AnimatedSyncIcon> createState() => _AnimatedSyncIconState();
}

class _AnimatedSyncIconState extends State<_AnimatedSyncIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: const Icon(Icons.sync, color: AppTheme.primaryColor),
    );
  }
}
