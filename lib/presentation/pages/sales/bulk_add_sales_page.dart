import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../data/repositories/sale_repository.dart';
import '../../../core/constants/app_constants.dart';

/// Entry for a bulk sale item
class BulkSaleEntry {
  final ProductModel product;
  int quantity;
  double unitPrice;
  bool isSelected;

  BulkSaleEntry({
    required this.product,
    this.quantity = 1,
    required this.unitPrice,
    this.isSelected = false,
  });

  double get total => quantity * unitPrice;
}

class BulkAddSalesPage extends ConsumerStatefulWidget {
  const BulkAddSalesPage({super.key});

  @override
  ConsumerState<BulkAddSalesPage> createState() => _BulkAddSalesPageState();
}

class _BulkAddSalesPageState extends ConsumerState<BulkAddSalesPage> {
  ShopModel? _selectedShop;
  final List<BulkSaleEntry> _entries = [];
  bool _isLoading = false;
  bool _isSaving = false;
  PaymentMethod _paymentMethod = PaymentMethod.cash;

  double get _totalAmount => _entries.fold(0.0, (sum, e) => sum + e.total);

  Future<void> _loadProducts() async {
    if (_selectedShop == null) return;

    setState(() => _isLoading = true);
    try {
      // Get all products and let user select which to sell
      final productsStream = ref.read(productsStreamProvider.stream);
      final products = await productsStream.first;

      setState(() {
        _entries.clear();
        for (final product in products) {
          _entries.add(
            BulkSaleEntry(
              product: product,
              quantity: 0,
              unitPrice: product.sellingPrice,
            ),
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSale() async {
    final selectedEntries = _entries.where((e) => e.quantity > 0).toList();
    if (selectedEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add quantities for at least one product'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    if (_selectedShop == null) return;

    setState(() => _isSaving = true);

    try {
      final items = selectedEntries
          .map(
            (e) => SaleItemModel(
              productId: e.product.id,
              productName: e.product.name,
              sku: e.product.barcode, // Use barcode as SKU substitute
              quantity: e.quantity,
              unitPrice: e.unitPrice,
              costPrice: e.product.costPrice,
              totalPrice: e.total,
            ),
          )
          .toList();

      final totalAmount = items.fold(0.0, (sum, i) => sum + i.totalPrice);

      await ref.read(saleRepositoryProvider).createSale(
            shopId: _selectedShop!.id,
            shopName: _selectedShop!.displayName,
            items: items,
            subtotal: totalAmount,
            totalAmount: totalAmount,
            amountPaid: totalAmount,
            paymentMethod: _paymentMethod,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sale recorded successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving sale: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopsAsync = ref.watch(shopsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Sales Entry'),
        actions: [
          if (_entries.isNotEmpty)
            TextButton.icon(
              onPressed: _isSaving ? null : _saveSale,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save, color: Colors.white),
              label: Text(
                'Save',
                style: TextStyle(
                  color: _isSaving ? Colors.grey : Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Shop selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: shopsAsync.when(
              data: (shops) => DropdownButtonFormField<ShopModel>(
                initialValue: _selectedShop,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Select Shop',
                  border: OutlineInputBorder(),
                ),
                items: shops
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                          s.displayName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (shop) {
                  setState(() => _selectedShop = shop);
                  if (shop != null) _loadProducts();
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ),

          // Payment method
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<PaymentMethod>(
              initialValue: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
              items: PaymentMethod.values
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.displayName),
                    ),
                  )
                  .toList(),
              onChanged: (m) {
                if (m != null) setState(() => _paymentMethod = m);
              },
            ),
          ),

          const SizedBox(height: 8),
          const Divider(),

          // Products list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedShop == null
                    ? const Center(
                        child: Text('Select a shop to begin'),
                      )
                    : _entries.isEmpty
                        ? const Center(
                            child: Text('No products in this shop'),
                          )
                        : _buildProductList(),
          ),

          // Total bar
          if (_entries.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_entries.where((e) => e.quantity > 0).length} items',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Total: \$${_totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product info
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.product.name,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${entry.unitPrice.toStringAsFixed(2)} each',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Quantity controls
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: entry.quantity > 0
                          ? () {
                              setState(() => entry.quantity--);
                            }
                          : null,
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${entry.quantity}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() => entry.quantity++);
                      },
                    ),
                  ],
                ),

                // Total for this item
                SizedBox(
                  width: 70,
                  child: Text(
                    '\$${entry.total.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: entry.quantity > 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: entry.quantity > 0
                          ? AppTheme.primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
