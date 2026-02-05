import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../controllers/auth_controller.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/barcode_scanner_service.dart';

import '../../../data/repositories/product_repository.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final String productId;

  const EditProductPage({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _descriptionController;
  late TextEditingController _costPriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _lowStockController;
  String? _selectedCategory;
  bool _trackInventory = true;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _barcodeController = TextEditingController();
    _descriptionController = TextEditingController();
    _costPriceController = TextEditingController();
    _sellingPriceController = TextEditingController();
    _lowStockController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadProduct();
      _isInitialized = true;
    }
  }

  Future<void> _loadProduct() async {
    setState(() => _isLoading = true);
    try {
      final product = await ref
          .read(productRepositoryProvider)
          .getProduct(widget.productId);
      if (product != null && mounted) {
        _nameController.text = product.name;
        _barcodeController.text = product.barcode ?? '';
        _descriptionController.text = product.description ?? '';
        _costPriceController.text = product.costPrice.toString();
        _sellingPriceController.text = product.sellingPrice.toString();
        _lowStockController.text = product.lowStockThreshold.toString();

        setState(() {
          _selectedCategory = product.categoryId;
          _trackInventory = product.trackInventory;
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      // Get current product to preserve fields we might not be editing or to clone
      final currentProduct = await ref
          .read(productRepositoryProvider)
          .getProduct(widget.productId);
      if (currentProduct == null) throw Exception('Product not found');

      final updatedProduct = currentProduct.copyWith(
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
        updatedAt: DateTime.now(),
      );

      await ref.read(productRepositoryProvider).updateProduct(updatedProduct);

      // Invalidate providers
      ref.invalidate(productProvider(widget.productId));
      ref.invalidate(productsStreamProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
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
    if (_isLoading && !_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
            const SizedBox(height: 24),
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
            LoadingButton(
              onPressed: _handleSave,
              isLoading: _isLoading,
              child: const Text('Update Product'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
