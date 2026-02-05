import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/transfer_model.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/transfer_repository.dart';

class NewTransferPage extends ConsumerStatefulWidget {
  const NewTransferPage({super.key});

  @override
  ConsumerState<NewTransferPage> createState() => _NewTransferPageState();
}

class _NewTransferPageState extends ConsumerState<NewTransferPage> {
  ShopModel? _sourceShop;
  ShopModel? _destinationShop;
  final List<TransferItem> _items = [];
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopsAsync = ref.watch(shopsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New Transfer')),
      body: shopsAsync.when(
        data: (shops) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Source and destination
                  DropdownButtonFormField<ShopModel>(
                    initialValue: _sourceShop,
                    decoration: const InputDecoration(
                      labelText: 'From Shop *',
                      prefixIcon: Icon(Icons.store_outlined),
                    ),
                    items: shops
                        .map(
                          (s) =>
                              DropdownMenuItem(value: s, child: Text(s.name)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() {
                      _sourceShop = v;
                      if (_destinationShop?.id == v?.id) {
                        _destinationShop = null;
                      }
                    }),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<ShopModel>(
                    initialValue: _destinationShop,
                    decoration: const InputDecoration(
                      labelText: 'To Shop *',
                      prefixIcon: Icon(Icons.store),
                    ),
                    items: shops
                        .where((s) => s.id != _sourceShop?.id)
                        .map(
                          (s) =>
                              DropdownMenuItem(value: s, child: Text(s.name)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _destinationShop = v),
                  ),
                  const SizedBox(height: 24),

                  // Add products
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Products', style: AppTextStyles.heading4),
                      TextButton.icon(
                        onPressed: _addProduct,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Product'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_items.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'No products added yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(_items.length, (index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text('Qty: ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _editQuantity(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppTheme.errorColor,
                                ),
                                onPressed: () =>
                                    setState(() => _items.removeAt(index)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 16),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),

            // Submit button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: LoadingButton(
                  onPressed: _sourceShop != null &&
                          _destinationShop != null &&
                          _items.isNotEmpty
                      ? _submitTransfer
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please select shops and add products'),
                            ),
                          );
                        },
                  isLoading: _isLoading,
                  child: const Text('Create Transfer'),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading shops: $e')),
      ),
    );
  }

  void _addProduct() {
    final productsAsync = ref.read(productsStreamProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => setModalState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: productsAsync.when(
                      data: (products) {
                        final query = _searchController.text.toLowerCase();
                        final filtered = query.isEmpty
                            ? products
                            : products
                                .where(
                                  (p) =>
                                      p.name.toLowerCase().contains(query) ||
                                      (p.barcode
                                              ?.toLowerCase()
                                              .contains(query) ??
                                          false),
                                )
                                .toList();

                        if (filtered.isEmpty) {
                          return const Center(child: Text('No products found'));
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final product = filtered[index];
                            final alreadyAdded =
                                _items.any((i) => i.productId == product.id);

                            return ListTile(
                              title: Text(product.name),
                              subtitle: Text(product.barcode ?? ''),
                              trailing: alreadyAdded
                                  ? const Icon(
                                      Icons.check,
                                      color: AppTheme.successColor,
                                    )
                                  : const Icon(Icons.add),
                              onTap: alreadyAdded
                                  ? null
                                  : () {
                                      _showQuantityDialog(product).then((qty) {
                                        if (qty != null && qty > 0) {
                                          setState(() {
                                            _items.add(
                                              TransferItem(
                                                productId: product.id,
                                                name: product.name,
                                                quantity: qty,
                                              ),
                                            );
                                          });
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ).then((_) => _searchController.clear());
  }

  Future<int?> _showQuantityDialog(ProductModel product) async {
    final controller = TextEditingController(text: '1');
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transfer ${product.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editQuantity(int index) async {
    final item = _items[index];
    final controller = TextEditingController(text: item.quantity.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${item.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Quantity'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (result != null && result > 0) {
      setState(() {
        _items[index] = TransferItem(
          productId: item.productId,
          name: item.name,
          quantity: result,
        );
      });
    }
  }

  Future<void> _submitTransfer() async {
    if (_sourceShop == null || _destinationShop == null || _items.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final transferItems = _items
          .map(
            (item) => TransferItemModel(
              productId: item.productId,
              productName: item.name,
              quantity: item.quantity,
              unitCost: 0, // Cost tracking not used for transfers
            ),
          )
          .toList();

      await ref.read(transferRepositoryProvider).createTransfer(
            fromShopId: _sourceShop!.id,
            fromShopName: _sourceShop!.name,
            toShopId: _destinationShop!.id,
            toShopName: _destinationShop!.name,
            items: transferItems,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer created successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating transfer: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class TransferItem {
  final String productId;
  final String name;
  final int quantity;

  TransferItem({
    required this.productId,
    required this.name,
    required this.quantity,
  });
}
