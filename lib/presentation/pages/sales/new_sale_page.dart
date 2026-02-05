import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/barcode_scanner_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/sale_repository.dart';
import '../../../data/repositories/shop_repository.dart';

class NewSalePage extends ConsumerStatefulWidget {
  const NewSalePage({super.key});

  @override
  ConsumerState<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends ConsumerState<NewSalePage> {
  final List<CartItem> _cart = [];
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  final _amountPaidController = TextEditingController();
  final _searchController = TextEditingController();
  List<ProductModel> _searchResults = [];
  bool _isSearching = false;
  bool _isCompletingSale = false;

  double get subtotal => _cart.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal; // Add tax/discount later

  @override
  void dispose() {
    _amountPaidController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final barcode =
        await ref.read(barcodeScannerServiceProvider).scanBarcode(context);

    if (barcode != null && mounted) {
      final product =
          await ref.read(productRepositoryProvider).findByBarcode(barcode);

      if (product != null) {
        _addProductToCart(product);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No product found with barcode: $barcode'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      }
    }
  }

  void _searchProducts(String query) {
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final allProducts = ref.read(productsStreamProvider).valueOrNull ?? [];
      final queryLower = query.toLowerCase();

      final results = allProducts
          .where((product) {
            final nameMatch = product.name.toLowerCase().contains(queryLower);
            final barcodeMatch =
                product.barcode?.toLowerCase().contains(queryLower) ?? false;
            return nameMatch || barcodeMatch;
          })
          .take(20)
          .toList();

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _addProductToCart(ProductModel product) {
    setState(() {
      final existing = _cart.indexWhere((item) => item.productId == product.id);
      if (existing >= 0) {
        _cart[existing] = _cart[existing].copyWith(
          quantity: _cart[existing].quantity + 1,
        );
      } else {
        _cart.add(
          CartItem(
            productId: product.id,
            name: product.name,
            price: product.sellingPrice,
            costPrice: product.costPrice,
            barcode: product.barcode,
            quantity: 1,
          ),
        );
      }
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _removeFromCart(int index) {
    setState(() => _cart.removeAt(index));
  }

  void _updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _removeFromCart(index);
    } else {
      setState(() {
        _cart[index] = _cart[index].copyWith(quantity: quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
        ],
      ),
      body: Column(
        children: [
          // Ensure products are loaded for search
          const SizedBox(height: 0, width: 0, child: _ProductListener()),

          // Search/Add products
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _isSearching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            onPressed: _scanBarcode,
                          ),
                  ),
                  onChanged: (value) => _searchProducts(value),
                ),
                // Search results dropdown
                if (_searchResults.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final product = _searchResults[index];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                            '\$${product.sellingPrice.toStringAsFixed(2)}',
                          ),
                          trailing: const Icon(Icons.add),
                          onTap: () => _addProductToCart(product),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Cart items
          Expanded(
            child: _cart.isEmpty
                ? const EmptyState(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Cart is empty',
                    subtitle: 'Search or scan products to add them',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final item = _cart[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: AppTextStyles.bodyLarge,
                                    ),
                                    Text(
                                      '\$${item.price.toStringAsFixed(2)} each',
                                      style: AppTextStyles.caption
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity controls
                              Row(
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _updateQuantity(
                                      index,
                                      item.quantity - 1,
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => _updateQuantity(
                                      index,
                                      item.quantity + 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${item.total.toStringAsFixed(2)}',
                                style: AppTextStyles.bodyLarge
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Payment section
          if (_cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total (${_cart.length} items)',
                          style: AppTextStyles.bodyLarge,
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Payment method
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: PaymentMethod.values.take(4).map((method) {
                          final isSelected = _paymentMethod == method;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(method.displayName),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _paymentMethod = method);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Complete sale button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isCompletingSale
                            ? null
                            : () => _completeSale(context),
                        child: _isCompletingSale
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Complete Sale'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _completeSale(BuildContext context) async {
    double amountPaid = total;
    double change = 0;

    // Show payment dialog for cash
    if (_paymentMethod == PaymentMethod.cash) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cash Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: AppTextStyles.heading4,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountPaidController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount Received',
                  prefixText: '\$ ',
                ),
                autofocus: true,
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
              child: const Text('Complete'),
            ),
          ],
        ),
      );

      if (result != true) return;

      amountPaid = double.tryParse(_amountPaidController.text) ?? total;
      change = amountPaid - total;

      if (amountPaid < total) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Amount received is less than total'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
        return;
      }
    }

    setState(() => _isCompletingSale = true);

    try {
      // Get shop info (use first available shop for now)
      final shops = await ref.read(shopRepositoryProvider).getShops();
      if (shops.isEmpty) {
        throw Exception('No shop configured');
      }
      final shop = shops.first;

      // Convert cart items to sale items
      final saleItems = _cart
          .map(
            (item) => SaleItemModel(
              productId: item.productId,
              productName: item.name,
              sku: null,
              barcode: item.barcode,
              quantity: item.quantity,
              unitPrice: item.price,
              costPrice: item.costPrice,
              totalPrice: item.total,
            ),
          )
          .toList();

      // Save to Firestore
      await ref.read(saleRepositoryProvider).createSale(
            shopId: shop.id,
            shopName: shop.name,
            items: saleItems,
            subtotal: subtotal,
            totalAmount: total,
            amountPaid: amountPaid,
            paymentMethod: _paymentMethod,
            changeGiven: change > 0 ? change : 0,
          );

      if (mounted) {
        if (change > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Sale complete! Change: \$${change.toStringAsFixed(2)}'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sale completed successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing sale: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCompletingSale = false);
      }
    }
  }
}

class CartItem {
  final String productId;
  final String name;
  final double price;
  final double costPrice;
  final String? barcode;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.costPrice,
    this.barcode,
    required this.quantity,
  });

  double get total => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      price: price,
      costPrice: costPrice,
      barcode: barcode,
      quantity: quantity ?? this.quantity,
    );
  }
}

class _ProductListener extends ConsumerWidget {
  const _ProductListener();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productsStreamProvider);
    return const SizedBox.shrink();
  }
}
