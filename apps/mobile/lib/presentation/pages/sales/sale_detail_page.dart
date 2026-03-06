import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../../data/repositories/sale_repository.dart';
import '../../../data/models/sale_model.dart';

class SaleDetailPage extends ConsumerWidget {
  final String saleId;
  const SaleDetailPage({super.key, required this.saleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleAsync = ref.watch(saleProvider(saleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: saleAsync.when(
        data: (sale) {
          if (sale == null) {
            return const Center(child: Text('Sale not found'));
          }
          return _buildContent(context, sale);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SaleModel sale) {
    final saleDate = DateTime.tryParse(sale.saleDate.toString());
    final formattedDate = saleDate != null
        ? DateFormat('MMM d, yyyy • h:mm a').format(saleDate)
        : 'Unknown Date';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Sale info card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${sale.saleNumber}',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.grey[700]),
                    ),
                    StatusBadge(
                      label: sale.status.name.toUpperCase(),
                      color: sale.status == SaleStatus.completed
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(formattedDate, style: AppTextStyles.caption),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Payment Method'),
                    Text(
                      sale.paymentMethod.displayName.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shop'),
                    Text(
                      sale.shopName ?? 'Unknown Shop',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sold By'),
                    Text(
                      sale.soldByName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (sale.customerName != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Customer'),
                      Text(
                        sale.customerName!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
                if (sale.notes != null && sale.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(sale.notes!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Items
        const Text('Items', style: AppTextStyles.heading4),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: sale.items.map((item) {
              return ListTile(
                title: Text(item.productName),
                subtitle: Text(
                  '\$${item.unitPrice.toStringAsFixed(2)} × ${item.quantity}',
                ),
                trailing: Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Summary
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Subtotal',
                  '\$${sale.subtotal.toStringAsFixed(2)}',
                ),
                if (sale.discountAmount > 0)
                  _buildSummaryRow(
                    'Discount',
                    '-\$${sale.discountAmount.toStringAsFixed(2)}',
                    color: AppTheme.errorColor,
                  ),
                if (sale.taxAmount > 0)
                  _buildSummaryRow(
                    'Tax',
                    '\$${sale.taxAmount.toStringAsFixed(2)}',
                  ),
                const Divider(),
                _buildSummaryRow(
                  'Total',
                  '\$${sale.totalAmount.toStringAsFixed(2)}',
                  isBold: true,
                ),
                _buildSummaryRow(
                  'Amount Paid',
                  '\$${sale.amountPaid.toStringAsFixed(2)}',
                ),
                if (sale.changeGiven > 0)
                  _buildSummaryRow(
                    'Change',
                    '\$${sale.changeGiven.toStringAsFixed(2)}',
                    color: AppTheme.successColor,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                : null,
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : null,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
