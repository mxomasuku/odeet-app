import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/shop_model.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../data/services/stock_audit_service.dart';
import 'product_movements_sheet.dart';
import '../../theme/app_theme.dart';

class StockAuditPage extends ConsumerStatefulWidget {
  const StockAuditPage({super.key});

  @override
  ConsumerState<StockAuditPage> createState() => _StockAuditPageState();
}

class _StockAuditPageState extends ConsumerState<StockAuditPage> {
  ShopModel? _selectedShop;
  bool _isLoading = false;
  bool _isCompleting = false;
  StockAuditReport? _report;

  // Map to track actual counts entered by auditor
  final Map<String, int> _actualCounts = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeActualCounts() {
    if (_report == null) return;

    _actualCounts.clear();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();

    for (final item in _report!.items.values) {
      // Default actual count to system closing stock
      _actualCounts[item.productId] = item.closingStock;
      _controllers[item.productId] = TextEditingController(
        text: item.closingStock.toString(),
      );
    }
  }

  Future<void> _generateReport() async {
    if (_selectedShop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a shop')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final report = await ref.read(stockAuditServiceProvider).getAuditReport(
            shopId: _selectedShop!.id,
          );
      setState(() {
        _report = report;
        _initializeActualCounts();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating report: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  int _getVariance(String productId, int systemStock) {
    final actual = _actualCounts[productId] ?? systemStock;
    return actual - systemStock;
  }

  bool _hasVariances() {
    if (_report == null) return false;
    for (final item in _report!.items.values) {
      if (_getVariance(item.productId, item.closingStock) != 0) {
        return true;
      }
    }
    return false;
  }

  void _showProductMovements(StockAuditItem item) {
    if (_selectedShop == null || _report == null) return;

    showProductMovementsSheet(
      context: context,
      shopId: _selectedShop!.id,
      productId: item.productId,
      productName: item.productName,
      sinceDate: _report!.lastAuditDate ?? DateTime(2024),
      openingStock: item.openingStock,
      closingStock: item.closingStock,
    );
  }

  Future<void> _completeAudit() async {
    if (_selectedShop == null || _report == null) return;

    final hasVariances = _hasVariances();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Audit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This will save the audit record with:'),
            const SizedBox(height: 8),
            const Text('• System stock levels'),
            const Text('• Your actual counts'),
            const Text('• Calculated variances'),
            if (hasVariances) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: AppTheme.warningColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'There are variances between system and actual counts.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Text('Continue?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Complete Audit'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isCompleting = true);
    try {
      await ref.read(stockAuditServiceProvider).completeAudit(
            shopId: _selectedShop!.id,
            actualCounts: _actualCounts,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audit completed successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        // Refresh the report
        _generateReport();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing audit: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCompleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Audit Ledger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _selectedShop != null ? _generateReport : null,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(context),
          const Divider(height: 1),
          if (_hasVariances())
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppTheme.warningColor.withOpacity(0.1),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppTheme.warningColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Variances detected - review before completing audit',
                    style: TextStyle(
                      color: AppTheme.warningColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildReportTable(),
          ),
        ],
      ),
      floatingActionButton: _selectedShop != null && _report != null
          ? FloatingActionButton.extended(
              onPressed: _isCompleting ? null : _completeAudit,
              icon: _isCompleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check),
              label: const Text('Complete Audit'),
            )
          : null,
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final shopsAsync = ref.watch(shopsStreamProvider);
                    return shopsAsync.when(
                      data: (shops) {
                        // Auto-select first shop if none selected
                        if (_selectedShop == null && shops.isNotEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _selectedShop = shops.first;
                              _generateReport();
                            });
                          });
                        }
                        return DropdownButtonFormField<ShopModel>(
                          initialValue: _selectedShop,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Shop',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
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
                            if (shop != null) _generateReport();
                          },
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Error: $e'),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _report == null
                      ? const Text(
                          'No audit loaded',
                          style: TextStyle(color: Colors.grey),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Last Audit',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _report!.lastAuditDate != null
                                  ? DateFormat('MMM d, yyyy')
                                      .format(_report!.lastAuditDate!)
                                  : 'No previous audit',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportTable() {
    if (_report == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.table_chart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Select a shop to view audit ledger'),
          ],
        ),
      );
    }

    if (_report!.items.isEmpty) {
      return const Center(child: Text('No stock data found'));
    }

    // Sort items by name
    final sortedItems = _report!.items.values.toList()
      ..sort((a, b) => a.productName.compareTo(b.productName));

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          columnSpacing: 16,
          columns: const [
            DataColumn(
              label: Text(
                'Product',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Opening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'System',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'Actual',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'Variance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
            ),
          ],
          rows: sortedItems.map((item) {
            final variance = _getVariance(item.productId, item.closingStock);
            final varianceColor = variance > 0
                ? Colors.green
                : variance < 0
                    ? Colors.red
                    : Colors.grey;

            return DataRow(
              cells: [
                DataCell(
                  InkWell(
                    onTap: () => _showProductMovements(item),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.open_in_new,
                          size: 14,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(Text('${item.openingStock}')),
                DataCell(
                  Text(
                    '+${item.stockIn}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
                DataCell(
                  Text(
                    '-${item.stockOut}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                DataCell(
                  Text(
                    '${item.closingStock}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: _controllers[item.productId],
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _actualCounts[item.productId] =
                              int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: variance != 0
                          ? varianceColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      variance >= 0 ? '+$variance' : '$variance',
                      style: TextStyle(
                        color: varianceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
