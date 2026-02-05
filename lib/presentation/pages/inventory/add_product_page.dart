import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../controllers/auth_controller.dart';
import '../../router/app_router.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/barcode_scanner_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/shop_repository.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _lowStockController = TextEditingController(text: '10');
  String? _selectedCategory;
  ShopModel? _selectedShop;
  bool _trackInventory = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final barcode =
        await ref.read(barcodeScannerServiceProvider).scanBarcode(context);

    if (barcode != null && mounted) {
      setState(() {
        _barcodeController.text = barcode;
      });

      // Check if product with this barcode already exists
      final existingProduct =
          await ref.read(productRepositoryProvider).findByBarcode(barcode);

      if (existingProduct != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Product "${existingProduct.name}" already has this barcode',
            ),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to add products'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final product = ProductModel(
        id: '', // Will be set by Firestore
        organizationId: user.organizationId,
        name: _nameController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty
            ? null
            : _barcodeController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        categoryId: _selectedCategory,
        categoryName: _getCategoryName(_selectedCategory),
        costPrice: double.tryParse(_costPriceController.text) ?? 0,
        sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0,
        lowStockThreshold: int.tryParse(_lowStockController.text) ?? 10,
        trackInventory: _trackInventory,
        createdAt: DateTime.now(),
      );

      await ref.read(productRepositoryProvider).createProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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

  String? _getCategoryName(String? categoryId) {
    switch (categoryId) {
      case 'electronics':
        return 'Electronics';
      case 'food':
        return 'Food';
      case 'beverages':
        return 'Beverages';
      case 'household':
        return 'Household';
      case 'other':
        return 'Other';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Product image placeholder
            Center(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Image upload coming soon'),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        color: Colors.grey[400],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Photo',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Basic Info Section
            const Text('Basic Information', style: AppTextStyles.heading4),
            const SizedBox(height: 16),

            // Shop selection (required)
            Consumer(
              builder: (context, ref, _) {
                final shopsAsync = ref.watch(shopsStreamProvider);
                return shopsAsync.when(
                  data: (shops) {
                    if (shops.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.warningColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.store_outlined,
                              color: AppTheme.warningColor,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No shops found',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Please add a shop before adding products',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.push(AppRoutes.shopOnboarding),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Shop'),
                            ),
                          ],
                        ),
                      );
                    }
                    return DropdownButtonFormField<ShopModel>(
                      initialValue: _selectedShop,
                      decoration: const InputDecoration(
                        labelText: 'Shop *',
                        prefixIcon: Icon(Icons.store_outlined),
                      ),
                      items: shops
                          .map(
                            (shop) => DropdownMenuItem(
                              value: shop,
                              child: Text(shop.displayName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedShop = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a shop';
                        }
                        return null;
                      },
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error loading shops: $e'),
                );
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Product Name *',
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              validator: (value) =>
                  Validators.required(value, fieldName: 'Product name'),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _barcodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Barcode',
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _scanBarcode,
                ),
              ),
              validator: Validators.barcode,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'electronics',
                  child: Text('Electronics'),
                ),
                DropdownMenuItem(value: 'food', child: Text('Food')),
                DropdownMenuItem(value: 'beverages', child: Text('Beverages')),
                DropdownMenuItem(value: 'household', child: Text('Household')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Pricing Section
            const Text('Pricing', style: AppTextStyles.heading4),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _costPriceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Cost Price *',
                      prefixText: '\$ ',
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (value) => Validators.positiveNumber(
                      value,
                      fieldName: 'Cost price',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _sellingPriceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Selling Price *',
                      prefixText: '\$ ',
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (value) => Validators.positiveNumber(
                      value,
                      fieldName: 'Selling price',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Profit margin display
            Builder(
              builder: (context) {
                final cost = double.tryParse(_costPriceController.text) ?? 0;
                final selling =
                    double.tryParse(_sellingPriceController.text) ?? 0;
                final profit = selling - cost;
                final margin = selling > 0 ? (profit / selling) * 100 : 0;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Profit', style: AppTextStyles.caption),
                          Text(
                            '\$${profit.toStringAsFixed(2)}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: profit > 0
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Margin', style: AppTextStyles.caption),
                          Text(
                            '${margin.toStringAsFixed(1)}%',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: margin > 0
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Inventory Section
            const Text('Inventory', style: AppTextStyles.heading4),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Track Inventory'),
              subtitle: const Text('Enable stock level tracking'),
              value: _trackInventory,
              onChanged: (value) {
                setState(() => _trackInventory = value);
              },
            ),

            if (_trackInventory) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _lowStockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Low Stock Threshold',
                  prefixIcon: Icon(Icons.warning_amber_outlined),
                  helperText: 'Alert when stock falls below this level',
                ),
                validator: (value) =>
                    Validators.nonNegativeNumber(value, fieldName: 'Threshold'),
              ),
            ],

            const SizedBox(height: 32),

            // Save button
            LoadingButton(
              onPressed: _handleSave,
              isLoading: _isLoading,
              child: const Text('Save Product'),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
