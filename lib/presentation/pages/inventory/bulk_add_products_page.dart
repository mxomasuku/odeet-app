import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../controllers/auth_controller.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../data/repositories/inventory_repository.dart';

/// Parsed entry from bulk input
class BulkProductEntry {
  final String name;
  final int quantity;
  final double? sellingPrice;
  final double? costPrice;
  final bool isValid;
  final String? error;

  BulkProductEntry({
    required this.name,
    required this.quantity,
    this.sellingPrice,
    this.costPrice,
    this.isValid = true,
    this.error,
  });
}

class BulkAddProductsPage extends ConsumerStatefulWidget {
  final List<String> shopIds;

  const BulkAddProductsPage({super.key, required this.shopIds});

  @override
  ConsumerState<BulkAddProductsPage> createState() =>
      _BulkAddProductsPageState();
}

class _BulkAddProductsPageState extends ConsumerState<BulkAddProductsPage> {
  final _inputController = TextEditingController();
  List<BulkProductEntry> _parsedEntries = [];
  bool _isLoading = false;
  bool _isPreviewing = false;
  List<ShopModel> _shops = [];

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  Future<void> _loadShops() async {
    final shops = <ShopModel>[];
    for (final id in widget.shopIds) {
      final shop = await ref.read(shopRepositoryProvider).getShop(id);
      if (shop != null) shops.add(shop);
    }
    if (mounted) {
      setState(() => _shops = shops);
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  /// Parse input text into product entries
  /// Format: "Product Name * Quantity @ $SellingPrice, $CostPrice"
  /// Examples:
  ///   Peanut Butter * 10
  ///   Bread * 5 @ $1.50
  ///   Milk * 3 @ $1, $0.80
  List<BulkProductEntry> _parseInput(String input) {
    final lines = input
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    return lines.map((line) {
      try {
        // Pattern: Name * Qty [@ Price[, Cost]]
        final parts = line.split('*');
        if (parts.length < 2) {
          return BulkProductEntry(
            name: line,
            quantity: 1,
            isValid: false,
            error: 'Invalid format. Use: Product * Quantity',
          );
        }

        final name = parts[0].trim();
        if (name.isEmpty) {
          return BulkProductEntry(
            name: '',
            quantity: 0,
            isValid: false,
            error: 'Product name is required',
          );
        }

        // Parse quantity and optional price
        var qtyPricePart = parts.sublist(1).join('*').trim();
        double? sellingPrice;
        double? costPrice;

        if (qtyPricePart.contains('@')) {
          final priceParts = qtyPricePart.split('@');
          qtyPricePart = priceParts[0].trim();

          // Parse prices
          final priceStr = priceParts[1].trim();
          if (priceStr.contains(',')) {
            // Format: @ $selling, $cost
            final prices = priceStr.split(',');
            sellingPrice = _parsePrice(prices[0].trim());
            costPrice = _parsePrice(prices[1].trim());
          } else {
            // Format: @ $selling
            sellingPrice = _parsePrice(priceStr);
          }
        }

        final quantity = int.tryParse(qtyPricePart);
        if (quantity == null || quantity <= 0) {
          return BulkProductEntry(
            name: name,
            quantity: 0,
            isValid: false,
            error: 'Invalid quantity: $qtyPricePart',
          );
        }

        return BulkProductEntry(
          name: name,
          quantity: quantity,
          sellingPrice: sellingPrice,
          costPrice: costPrice,
        );
      } catch (e) {
        return BulkProductEntry(
          name: line,
          quantity: 0,
          isValid: false,
          error: 'Parse error: $e',
        );
      }
    }).toList();
  }

  double? _parsePrice(String priceStr) {
    // Remove currency symbols and parse
    final cleaned = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned);
  }

  void _handlePreview() {
    final entries = _parseInput(_inputController.text);
    setState(() {
      _parsedEntries = entries;
      _isPreviewing = true;
    });
  }

  Future<void> _handleSave() async {
    if (_parsedEntries.isEmpty) return;

    final validEntries = _parsedEntries.where((e) => e.isValid).toList();
    if (validEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid entries to save'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

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

    // Check connectivity before proceeding (stock operations require network)
    final connectivity = ref.read(connectivityServiceProvider);
    if (!connectivity.isOnline) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Network required. Stock additions cannot be saved offline.'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final productRepo = ref.read(productRepositoryProvider);
      final inventoryRepo = ref.read(inventoryRepositoryProvider);

      for (final entry in validEntries) {
        // Check if product exists globally
        final existing = await productRepo.findByName(entry.name);
        String productId;

        if (existing != null) {
          productId = existing.id;
          // Update global product price if provided
          if (entry.sellingPrice != null || entry.costPrice != null) {
            await productRepo.updateProduct(
              existing.copyWith(
                sellingPrice: entry.sellingPrice ?? existing.sellingPrice,
                costPrice: entry.costPrice ?? existing.costPrice,
                updatedAt: DateTime.now(),
              ),
            );
          }
        } else {
          // Create new product
          final product = ProductModel(
            id: '',
            organizationId: user.organizationId,
            name: entry.name,
            costPrice: entry.costPrice ?? 0,
            sellingPrice: entry.sellingPrice ?? 0,
            lowStockThreshold: 10,
            trackInventory: true,
            createdAt: DateTime.now(),
          );
          productId = await productRepo.createProduct(product);
        }

        // Add to ALL selected shops
        for (final shopId in widget.shopIds) {
          await inventoryRepo.adjustStock(
            shopId: shopId,
            productId: productId,
            adjustment: entry.quantity,
            adjustmentType: 'received',
            reason: 'Stock Received',
            notes: 'Bulk add restock',
          );
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Processed ${validEntries.length} products for ${widget.shopIds.length} shops',
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_shops.isEmpty
            ? 'Add to Shops'
            : _shops.length == 1
                ? 'Add to ${_shops.first.name}'
                : 'Add to ${_shops.length} Shops'),
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bulk Add Products',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter one product per line:',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peanut Butter * 10',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Bread * 5 @ \$1.50',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Milk * 3 @ \$1, \$0.80',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Input or Preview
          Expanded(
            child: _isPreviewing ? _buildPreview() : _buildInput(),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: _isPreviewing
                ? Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _isPreviewing = false);
                          },
                          child: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: LoadingButton(
                          onPressed: _handleSave,
                          isLoading: _isLoading,
                          child: Text(
                            'Save ${_parsedEntries.where((e) => e.isValid).length} Products',
                          ),
                        ),
                      ),
                    ],
                  )
                : LoadingButton(
                    onPressed: _inputController.text.trim().isNotEmpty
                        ? _handlePreview
                        : () {},
                    isLoading: false,
                    child: const Text('Preview'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _inputController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          hintText: 'Enter products here...\nExample: Bread * 5 @ \$1.50',
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildPreview() {
    final validCount = _parsedEntries.where((e) => e.isValid).length;
    final invalidCount = _parsedEntries.where((e) => !e.isValid).length;

    return Column(
      children: [
        // Summary bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppTheme.successColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text('$validCount valid'),
              if (invalidCount > 0) ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.error,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text('$invalidCount invalid'),
              ],
            ],
          ),
        ),

        // Entry list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _parsedEntries.length,
            itemBuilder: (context, index) {
              final entry = _parsedEntries[index];
              return Card(
                color: entry.isValid ? null : Colors.red[50],
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: entry.isValid
                        ? AppTheme.successColor.withOpacity(0.2)
                        : AppTheme.errorColor.withOpacity(0.2),
                    child: Icon(
                      entry.isValid ? Icons.inventory : Icons.error,
                      color: entry.isValid
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                    ),
                  ),
                  title: Text(entry.name.isEmpty ? '(empty)' : entry.name),
                  subtitle: entry.isValid
                      ? Text(
                          'Qty: ${entry.quantity}${entry.sellingPrice != null ? ' • \$${entry.sellingPrice!.toStringAsFixed(2)}' : ''}${entry.costPrice != null ? ' (cost: \$${entry.costPrice!.toStringAsFixed(2)})' : ''}',
                        )
                      : Text(
                          entry.error ?? 'Invalid entry',
                          style: TextStyle(color: AppTheme.errorColor),
                        ),
                  trailing: entry.isValid
                      ? Text(
                          '×${entry.quantity}',
                          style: AppTextStyles.heading4,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
