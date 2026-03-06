import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/shop_model.dart';
import '../../../../data/repositories/inventory_repository.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_text_styles.dart';

class ShopInventoryView extends ConsumerWidget {
  final ShopModel shop;

  const ShopInventoryView({super.key, required this.shop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);
    final inventoryAsync = ref.watch(shopInventoryProvider(shop.id));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(
            child: Text('No products defined in organization'),
          );
        }

        return inventoryAsync.when(
          data: (inventory) {
            // Map inventory by productId for easy access
            final inventoryMap = {
              for (var item in inventory) item.productId: item.quantity,
            };

            // Filter products that track inventory or show all if desired
            // decoupling: Only show products that have a record in this shop's inventory
            final productList =
                products.where((p) => inventoryMap.containsKey(p.id)).toList();

            if (productList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No products in this shop.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Find context to navigate
                        // This button acts as a hint to add products
                      },
                      child: const Text('Add Products'),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: productList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = productList[index];
                final quantity = inventoryMap[product.id] ?? 0;

                // Determine status based on quantity and thresholds
                Color statusColor = AppTheme.successColor;
                String statusText = 'In Stock';

                if (quantity <= 0) {
                  statusColor = AppTheme.errorColor;
                  statusText = 'Out of Stock';
                } else if (quantity <= product.lowStockThreshold) {
                  statusColor = AppTheme.warningColor;
                  statusText = 'Low Stock';
                }

                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
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
                          : const Icon(Icons.inventory_2, color: Colors.grey),
                    ),
                    title: Text(
                      product.name,
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('\$${product.sellingPrice.toStringAsFixed(2)}'),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusText,
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$quantity',
                          style: AppTextStyles.heading4,
                        ),
                        Text(
                          'Qty',
                          style: AppTextStyles.caption
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      context.push('/inventory/${product.id}');
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading inventory: $e')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading products: $e')),
    );
  }
}
