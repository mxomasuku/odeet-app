import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../../data/repositories/sale_repository.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(recentSalesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Bulk Add Sales',
            onPressed: () => context.push(AppRoutes.bulkSales),
          ),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: salesAsync.when(
        data: (sales) {
          if (sales.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No sales yet',
                    style: AppTextStyles.heading4.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click the button below to make your first sale',
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
              ref.invalidate(recentSalesProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];
                final saleDate = DateTime.tryParse(sale.saleDate.toString());
                final timeStr = saleDate != null
                    ? DateFormat('MMM d, yyyy • h:mm a').format(saleDate)
                    : '';

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.receipt,
                        color: AppTheme.successColor,
                      ),
                    ),
                    title: Text(sale.saleNumber),
                    subtitle: Text('${sale.totalItems} items • $timeStr'),
                    trailing: Text(
                      '\$${sale.totalAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    onTap: () => context.push('/sales/${sale.id}'),
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
                onPressed: () => ref.invalidate(recentSalesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.newSale),
        icon: const Icon(Icons.add),
        label: const Text('New Sale'),
      ),
    );
  }
}
