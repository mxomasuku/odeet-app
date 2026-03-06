import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/sale_model.dart';
import '../../../../data/models/shop_model.dart';
import '../../../../data/repositories/sale_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/common/common_widgets.dart';

class ShopSalesView extends ConsumerWidget {
  final ShopModel shop;

  const ShopSalesView({super.key, required this.shop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(shopSalesProvider(shop.id));

    return salesAsync.when(
      data: (sales) {
        if (sales.isEmpty) {
          return const Center(child: Text('No sales found for this shop'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sales.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final sale = sales[index];
            return SalesListItem(
              sale: sale,
              onTap: () => context.push('/sales/${sale.id}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading sales: $e')),
    );
  }
}

class SalesListItem extends StatelessWidget {
  final SaleModel sale;
  final VoidCallback onTap;

  const SalesListItem({
    super.key,
    required this.sale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Text(
              '\$${sale.totalAmount.toStringAsFixed(2)}',
              style: AppTextStyles.heading4.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            StatusBadge(
              label: sale.status.name.toUpperCase(),
              color: sale.status == SaleStatus.completed
                  ? AppTheme.successColor
                  : AppTheme.warningColor,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${sale.items.length} items • ${DateFormat('MMM d, h:mm a').format(sale.saleDate)}',
              style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
            ),
            if (sale.soldByName.isNotEmpty)
              Text(
                'Sold by: ${sale.soldByName}',
                style: AppTextStyles.caption.copyWith(color: Colors.grey[500]),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
