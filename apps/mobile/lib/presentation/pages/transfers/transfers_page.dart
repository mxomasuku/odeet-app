import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/transfer_repository.dart';

class TransfersPage extends ConsumerWidget {
  const TransfersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stock Transfers'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Outgoing'),
              Tab(text: 'Incoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTransferList(context, ref, isOutgoing: true),
            _buildTransferList(context, ref, isOutgoing: false),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.newTransfer),
          icon: const Icon(Icons.add),
          label: const Text('New Transfer'),
        ),
      ),
    );
  }

  Widget _buildTransferList(
    BuildContext context,
    WidgetRef ref, {
    required bool isOutgoing,
  }) {
    final transfersAsync = ref.watch(transfersStreamProvider);

    return transfersAsync.when(
      data: (allTransfers) {
        // Filter based on outgoing/incoming
        final transfers = allTransfers.where((transfer) {
          // This would need proper logic based on your transfer model
          // For now, showing all in both tabs
          return true;
        }).toList();

        if (transfers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swap_horiz,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  isOutgoing
                      ? 'No outgoing transfers'
                      : 'No incoming transfers',
                  style: AppTextStyles.heading4.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a new transfer to get started',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(transfersStreamProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final transfer = transfers[index];
              final transferDate = transfer.createdAt;
              final dateStr = _formatDate(transferDate);

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(transfer.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.swap_horiz,
                      color: _getStatusColor(transfer.status),
                    ),
                  ),
                  title: Text(transfer.transferNumber),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${transfer.sourceShopName} → ${transfer.destinationShopName}',
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(
                        label: transfer.status.displayName,
                        color: _getStatusColor(transfer.status),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${transfer.totalItems} items'),
                      Text(
                        dateStr,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => context.push('/transfers/${transfer.id}'),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(transfersStreamProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TransferStatus status) {
    switch (status) {
      case TransferStatus.pending:
        return AppTheme.warningColor;
      case TransferStatus.inTransit:
        return AppTheme.infoColor;
      case TransferStatus.delivered:
        return AppTheme.primaryColor;
      case TransferStatus.confirmed:
        return AppTheme.successColor;
      case TransferStatus.rejected:
      case TransferStatus.cancelled:
        return AppTheme.errorColor;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    }
    if (date.day == now.day - 1 &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Yesterday';
    }
    return DateFormat('MMM d').format(date);
  }
}
