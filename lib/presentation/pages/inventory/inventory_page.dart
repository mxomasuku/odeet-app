import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../../core/services/barcode_scanner_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

/// Filter for product list
final productFilterProvider = StateProvider<String>((ref) => 'all');

/// Search query provider
final productSearchQueryProvider = StateProvider<String>((ref) => '');

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final barcode =
        await ref.read(barcodeScannerServiceProvider).scanBarcode(context);

    if (barcode != null && mounted) {
      // Find product by barcode
      final product =
          await ref.read(productRepositoryProvider).findByBarcode(barcode);

      if (product != null && mounted) {
        context.push('${AppRoutes.inventory}/${product.id}');
      } else if (mounted) {
        // Product not found, offer to add
        final shouldAdd = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Product Not Found'),
            content: Text(
              'No product found with barcode: $barcode\n\nWould you like to add a new product?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Add Product'),
              ),
            ],
          ),
        );

        if (shouldAdd == true && mounted) {
          context.push(AppRoutes.addProduct);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsStreamProvider);
    final selectedFilter = ref.watch(productFilterProvider);
    final searchQuery = ref.watch(productSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppSearchBar(
                  controller: _searchController,
                  hintText: 'Search products...',
                  onChanged: (value) {
                    ref.read(productSearchQueryProvider.notifier).state = value;
                  },
                  onClear: () {
                    _searchController.clear();
                    ref.read(productSearchQueryProvider.notifier).state = '';
                  },
                  onFilterTap: () => _showFilterSheet(context),
                ),
                const SizedBox(height: 12),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all', selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('Low Stock', 'low', selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('Out of Stock', 'out', selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('In Stock', 'in', selectedFilter),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats summary
          productsAsync.when(
            data: (products) {
              final lowStock = products
                  .where((p) => p.trackInventory && p.lowStockThreshold > 0)
                  .length;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatItem('Total Products', '${products.length}'),
                    _buildStatItem(
                      'Low Stock',
                      '$lowStock',
                      color: AppTheme.warningColor,
                    ),
                    _buildStatItem(
                      'Categories',
                      '5',
                      color: AppTheme.infoColor,
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),

          // Product list
          Expanded(
            child:
                _buildProductList(productsAsync, selectedFilter, searchQuery),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addProduct),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String selectedFilter) {
    final isSelected = selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(productFilterProvider.notifier).state =
            selected ? value : 'all';
      },
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(
                color: color ?? AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(
    AsyncValue<List<ProductModel>> productsAsync,
    String selectedFilter,
    String searchQuery,
  ) {
    return productsAsync.when(
      data: (products) {
        // Apply search filter
        var filteredProducts = products;
        if (searchQuery.isNotEmpty) {
          final query = searchQuery.toLowerCase();
          filteredProducts = products
              .where(
                (p) =>
                    p.name.toLowerCase().contains(query) ||
                    (p.barcode?.toLowerCase().contains(query) ?? false),
              )
              .toList();
        }

        // Apply stock filter (simplified - in real app would check actual inventory)
        // For now, we'll just show all products
        if (selectedFilter == 'low') {
          filteredProducts =
              filteredProducts.where((p) => p.trackInventory).toList();
        }

        if (filteredProducts.isEmpty) {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            title: searchQuery.isNotEmpty
                ? 'No matching products'
                : 'No products yet',
            subtitle: searchQuery.isNotEmpty
                ? 'Try a different search term'
                : 'Add your first product to get started',
            action: searchQuery.isEmpty
                ? ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.addProduct),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  )
                : null,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: product.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.inventory_2,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.inventory_2,
                          color: Colors.grey,
                        ),
                ),
                title: Text(product.name),
                subtitle: Row(
                  children: [
                    if (product.categoryName != null)
                      StatusBadge(
                        label: product.categoryName!,
                        color: AppTheme.primaryColor,
                      ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${product.sellingPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cost: \$${product.costPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                onTap: () =>
                    context.push('${AppRoutes.inventory}/${product.id}'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Error loading products: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(productsStreamProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Products', style: AppTextStyles.heading4),
            const SizedBox(height: 16),
            const Text('Category'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('Electronics'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('Food'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('Beverages'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
