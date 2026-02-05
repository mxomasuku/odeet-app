import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../../data/repositories/product_repository.dart';

class ProductDetailPage extends ConsumerWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/inventory/$productId/edit');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Product'),
                    content: const Text(
                      'Are you sure you want to delete this product? This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.errorColor,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  try {
                    await ref
                        .read(productRepositoryProvider)
                        .deleteProduct(productId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product deleted'),
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                      context.pop();
                    }
                  } catch (e) {
                    if (context.mounted) {
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
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppTheme.errorColor),
                    SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Product not found'),
                ],
              ),
            );
          }

          final profit = product.sellingPrice - product.costPrice;
          final margin = product.sellingPrice > 0
              ? (profit / product.sellingPrice) * 100
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image placeholder
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.inventory_2,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Product name and category
                Center(
                  child: Text(
                    product.name,
                    style: AppTextStyles.heading2,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (product.categoryName != null) ...[
                  const SizedBox(height: 4),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        product.categoryName!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Pricing section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pricing', style: AppTextStyles.heading4),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoTile(
                                'Cost Price',
                                '\$${product.costPrice.toStringAsFixed(2)}',
                                Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoTile(
                                'Selling Price',
                                '\$${product.sellingPrice.toStringAsFixed(2)}',
                                AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoTile(
                                'Profit',
                                '\$${profit.toStringAsFixed(2)}',
                                profit >= 0
                                    ? AppTheme.successColor
                                    : AppTheme.errorColor,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoTile(
                                'Margin',
                                '${margin.toStringAsFixed(1)}%',
                                margin >= 0
                                    ? AppTheme.successColor
                                    : AppTheme.errorColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Details section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Details', style: AppTextStyles.heading4),
                        const SizedBox(height: 16),
                        if (product.barcode != null)
                          _buildDetailRow('Barcode', product.barcode!),
                        _buildDetailRow(
                          'Track Inventory',
                          product.trackInventory ? 'Yes' : 'No',
                        ),
                        if (product.trackInventory)
                          _buildDetailRow(
                            'Low Stock Threshold',
                            '${product.lowStockThreshold} units',
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                if (product.description != null &&
                    product.description!.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: AppTextStyles.heading4,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description!,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(productProvider(productId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
