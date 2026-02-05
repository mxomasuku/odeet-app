import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../controllers/auth_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/transfer_model.dart';
import '../../../data/repositories/transfer_repository.dart';

/// Provider to fetch a single transfer
final transferDetailProvider =
    FutureProvider.family<TransferModel?, String>((ref, id) async {
  final repository = ref.watch(transferRepositoryProvider);
  return repository.getTransfer(id);
});

class TransferDetailPage extends ConsumerStatefulWidget {
  final String transferId;
  const TransferDetailPage({super.key, required this.transferId});

  @override
  ConsumerState<TransferDetailPage> createState() => _TransferDetailPageState();
}

class _TransferDetailPageState extends ConsumerState<TransferDetailPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final transferAsync = ref.watch(transferDetailProvider(widget.transferId));

    return Scaffold(
      appBar: AppBar(
        title: transferAsync.when(
          data: (t) => Text(t?.transferNumber ?? 'Transfer Details'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Transfer Details'),
        ),
      ),
      body: transferAsync.when(
        data: (transfer) {
          if (transfer == null) {
            return const Center(child: Text('Transfer not found'));
          }
          return _buildContent(context, transfer);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransferModel transfer) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StatusBadge(
                  label: transfer.status.displayName,
                  color: _getStatusColor(transfer.status),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('From', transfer.sourceShopName),
                _buildInfoRow('To', transfer.destinationShopName),
                _buildInfoRow('Created By', transfer.createdByName),
                _buildInfoRow(
                  'Date',
                  DateFormat.yMMMd().add_jm().format(transfer.createdAt),
                ),
                if (transfer.notes != null && transfer.notes!.isNotEmpty)
                  _buildInfoRow('Notes', transfer.notes!),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Items
        Text('Items (${transfer.items.length})', style: AppTextStyles.heading4),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: transfer.items
                .map(
                  (item) => ListTile(
                    title: Text(item.productName),
                    trailing: Text(
                      'Qty: ${item.quantity}',
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 24),

        // Action buttons based on status
        if (_isProcessing)
          const Center(child: CircularProgressIndicator())
        else ...[
          // Approval section - show for managers/owners when transfer needs approval
          if (transfer.needsApproval) ...[
            Builder(
              builder: (context) {
                final user = ref.watch(currentUserProvider).valueOrNull;
                if (user != null && user.canApproveTransfer) {
                  return Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _approveTransfer(context, transfer),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Approve Transfer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.successColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Approval required before dispatch',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }
                return Card(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.hourglass_top, color: AppTheme.warningColor),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Awaiting approval from manager'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
          // Dispatch button - only show if approved
          if (transfer.canDispatch) ...[
            ElevatedButton.icon(
              onPressed: () => _dispatchTransfer(context, transfer),
              icon: const Icon(Icons.local_shipping),
              label: const Text('Dispatch Transfer'),
            ),
          ],
          if (transfer.status == TransferStatus.inTransit) ...[
            ElevatedButton.icon(
              onPressed: () => _markDelivered(context, transfer),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Mark as Delivered'),
            ),
          ],
          if (transfer.status == TransferStatus.delivered) ...[
            ElevatedButton.icon(
              onPressed: () => _confirmTransfer(context, transfer),
              icon: const Icon(Icons.verified),
              label: const Text('Confirm Receipt'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _reportDiscrepancy(context, transfer),
              icon: const Icon(Icons.warning_amber),
              label: const Text('Report Discrepancy'),
            ),
          ],
          if (transfer.status == TransferStatus.confirmed) ...[
            Card(
              color: AppTheme.successColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transfer Completed',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (transfer.receivedByName != null)
                            Text('Received by: ${transfer.receivedByName}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
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
      default:
        return AppTheme.errorColor;
    }
  }

  Future<void> _approveTransfer(
    BuildContext context,
    TransferModel transfer,
  ) async {
    final confirm = await showConfirmDialog(
      context,
      title: 'Approve Transfer',
      message:
          'Approve this transfer request? Once approved, it can be dispatched.',
      confirmLabel: 'Approve',
    );

    if (!confirm) return;

    setState(() => _isProcessing = true);
    try {
      await ref.read(transferRepositoryProvider).approveTransfer(transfer.id);
      ref.invalidate(transferDetailProvider(widget.transferId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer approved'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _dispatchTransfer(
    BuildContext context,
    TransferModel transfer,
  ) async {
    final confirm = await showConfirmDialog(
      context,
      title: 'Dispatch Transfer',
      message: 'Mark this transfer as dispatched and in transit?',
      confirmLabel: 'Dispatch',
    );

    if (!confirm) return;

    setState(() => _isProcessing = true);
    try {
      await ref.read(transferRepositoryProvider).updateTransferStatus(
            transferId: transfer.id,
            newStatus: TransferStatus.inTransit,
          );
      ref.invalidate(transferDetailProvider(widget.transferId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer dispatched'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _markDelivered(
    BuildContext context,
    TransferModel transfer,
  ) async {
    final confirm = await showConfirmDialog(
      context,
      title: 'Mark Delivered',
      message:
          'Confirm that goods have been delivered to ${transfer.destinationShopName}?',
      confirmLabel: 'Mark Delivered',
    );

    if (!confirm) return;

    setState(() => _isProcessing = true);
    try {
      await ref.read(transferRepositoryProvider).updateTransferStatus(
            transferId: transfer.id,
            newStatus: TransferStatus.delivered,
          );
      ref.invalidate(transferDetailProvider(widget.transferId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer marked as delivered'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _confirmTransfer(
    BuildContext context,
    TransferModel transfer,
  ) async {
    final user = ref.read(currentUserProvider).valueOrNull;

    final confirm = await showConfirmDialog(
      context,
      title: 'Confirm Receipt',
      message:
          'Confirm that all items have been received correctly? This will update inventory levels.',
      confirmLabel: 'Confirm',
    );

    if (!confirm) return;

    setState(() => _isProcessing = true);
    try {
      await ref.read(transferRepositoryProvider).updateTransferStatus(
            transferId: transfer.id,
            newStatus: TransferStatus.confirmed,
            receivedBy: user?.id,
            receivedByName: user?.name,
            receivedItems: transfer.items,
          );
      ref.invalidate(transferDetailProvider(widget.transferId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer confirmed and inventory updated'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _reportDiscrepancy(
    BuildContext context,
    TransferModel transfer,
  ) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Discrepancy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Describe the discrepancy in received items:'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'e.g., "Received 8 units of Product A instead of 10"',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (result != true || notesController.text.trim().isEmpty) return;

    setState(() => _isProcessing = true);
    try {
      await ref.read(transferRepositoryProvider).updateTransferStatus(
            transferId: transfer.id,
            newStatus: TransferStatus.confirmed,
            receivedBy: user?.id,
            receivedByName: user?.name,
            receivedItems: transfer.items,
            discrepancyNotes: notesController.text.trim(),
          );
      ref.invalidate(transferDetailProvider(widget.transferId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Discrepancy reported and transfer confirmed'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
