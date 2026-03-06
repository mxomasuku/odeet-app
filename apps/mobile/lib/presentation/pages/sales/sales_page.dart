import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../../data/repositories/sale_repository.dart';
import '../../../data/models/sale_model.dart';

/// Filter enum for date ranges
enum SalesFilter { today, thisWeek, thisMonth, all }

extension SalesFilterExtension on SalesFilter {
  String get label {
    switch (this) {
      case SalesFilter.today:
        return 'Today';
      case SalesFilter.thisWeek:
        return 'This Week';
      case SalesFilter.thisMonth:
        return 'This Month';
      case SalesFilter.all:
        return 'All';
    }
  }

  ({DateTime start, DateTime end}) get dateRange {
    final now = DateTime.now();
    switch (this) {
      case SalesFilter.today:
        final startOfDay = DateTime(now.year, now.month, now.day);
        return (start: startOfDay, end: now);
      case SalesFilter.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfDay =
            DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        return (start: startOfDay, end: now);
      case SalesFilter.thisMonth:
        final startOfMonth = DateTime(now.year, now.month, 1);
        return (start: startOfMonth, end: now);
      case SalesFilter.all:
        return (start: DateTime(2020), end: now);
    }
  }
}

/// State provider for the current filter
final salesFilterProvider =
    StateProvider<SalesFilter>((ref) => SalesFilter.today);

/// Filtered sales provider that accounts for user's shop access
final filteredSalesProvider = FutureProvider<List<SaleModel>>((ref) async {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return [];

  final filter = ref.watch(salesFilterProvider);
  final repository = ref.watch(saleRepositoryProvider);

  // Get all sales for the date range
  final range = filter.dateRange;
  List<SaleModel> sales;

  if (filter == SalesFilter.all) {
    sales = await repository.getRecentSales(limit: 100);
  } else {
    sales = await repository.getSalesForDateRange(range.start, range.end);
  }

  // Filter by shop for shopkeepers
  final userShopIds = user.shopIds ?? [];
  if (userShopIds.isNotEmpty && !user.isOwner && !user.isManager) {
    // Shopkeeper: only show sales from their assigned shops
    sales = sales.where((sale) => userShopIds.contains(sale.shopId)).toList();
  }

  return sales;
});

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(salesFilterProvider);
    final salesAsync = ref.watch(filteredSalesProvider);
    final user = ref.watch(currentUserProvider).valueOrNull;

    // Show which shop's sales (for shopkeepers)
    final shopLabel =
        (user?.shopIds?.isNotEmpty == true && !user!.isOwner && !user.isManager)
            ? ' (Your Shop)'
            : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales$shopLabel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Bulk Add Sales',
            onPressed: () => context.push(AppRoutes.bulkSales),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: SalesFilter.values.map((filter) {
                  final isSelected = currentFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter.label),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(salesFilterProvider.notifier).state = filter;
                        }
                      },
                      selectedColor:
                          AppTheme.primaryColor.withValues(alpha: 0.2),
                      checkmarkColor: AppTheme.primaryColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Sales list
          Expanded(
            child: salesAsync.when(
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
                          'No sales ${currentFilter == SalesFilter.today ? 'today' : currentFilter == SalesFilter.thisWeek ? 'this week' : ''}',
                          style: AppTextStyles.heading4
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click the button below to make a sale',
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
                    ref.invalidate(filteredSalesProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sales.length,
                    itemBuilder: (context, index) {
                      final sale = sales[index];
                      final saleDate =
                          DateTime.tryParse(sale.saleDate.toString());
                      final timeStr = saleDate != null
                          ? DateFormat('MMM d, yyyy • h:mm a').format(saleDate)
                          : '';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.successColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.receipt,
                              color: AppTheme.successColor,
                            ),
                          ),
                          title: Text(sale.saleNumber),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${sale.totalItems} items • $timeStr'),
                              if (sale.shopName != null)
                                Text(
                                  sale.shopName!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
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
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(filteredSalesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.newSale),
        icon: const Icon(Icons.add),
        label: const Text('New Sale'),
      ),
    );
  }
}
