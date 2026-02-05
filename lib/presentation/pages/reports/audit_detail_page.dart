import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/services/stock_audit_service.dart';
import '../../theme/app_theme.dart';

class AuditDetailPage extends ConsumerStatefulWidget {
  final String auditId;

  const AuditDetailPage({super.key, required this.auditId});

  @override
  ConsumerState<AuditDetailPage> createState() => _AuditDetailPageState();
}

class _AuditDetailPageState extends ConsumerState<AuditDetailPage> {
  bool _isLoading = true;
  StockAuditRecord? _audit;
  Map<String, String> _productNames = {};

  @override
  void initState() {
    super.initState();
    _loadAudit();
  }

  Future<void> _loadAudit() async {
    setState(() => _isLoading = true);
    try {
      final audit = await ref
          .read(stockAuditServiceProvider)
          .getAuditById(widget.auditId);

      if (audit != null) {
        // Load product names for all products in the audit
        final productIds = <String>{
          ...audit.systemStock.keys,
          ...audit.actualStock.keys,
        };

        final names = await ref
            .read(stockAuditServiceProvider)
            .getProductNames(productIds.toList());

        setState(() {
          _audit = audit;
          _productNames = names;
        });
      } else {
        setState(() => _audit = null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading audit: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<_AuditLineItem> _buildLineItems() {
    if (_audit == null) return [];

    final items = <_AuditLineItem>[];
    final allProductIds = <String>{
      ..._audit!.systemStock.keys,
      ..._audit!.actualStock.keys,
    };

    for (final pid in allProductIds) {
      final system = _audit!.systemStock[pid] ?? 0;
      final actual = _audit!.actualStock[pid] ?? 0;
      final variance = _audit!.variance[pid] ?? (actual - system);

      items.add(
        _AuditLineItem(
          productId: pid,
          productName: _productNames[pid] ?? pid,
          systemStock: system,
          actualStock: actual,
          variance: variance,
        ),
      );
    }

    // Sort: variances first, then by product name
    items.sort((a, b) {
      final aHasVariance = a.variance != 0;
      final bHasVariance = b.variance != 0;
      if (aHasVariance && !bHasVariance) return -1;
      if (!aHasVariance && bHasVariance) return 1;
      return a.productName.compareTo(b.productName);
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Report'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _audit == null
              ? const Center(child: Text('Audit not found'))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final items = _buildLineItems();
    final varianceItems = items.where((i) => i.variance != 0).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM d, yyyy').format(_audit!.auditDate),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Completed at ${DateFormat('h:mm a').format(_audit!.auditDate)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatChip(
                      '${items.length}',
                      'Products',
                      Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      '${varianceItems.length}',
                      'Variances',
                      varianceItems.isEmpty ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Variance Summary (if any)
          if (varianceItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Variances',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...varianceItems.map((item) => _buildVarianceCard(item)),
          ],

          // Full Table
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Full Audit Report',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
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
                    'System',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Actual',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
              rows: items.map((item) {
                final varianceColor = item.variance > 0
                    ? Colors.green
                    : item.variance < 0
                        ? Colors.red
                        : Colors.grey;

                return DataRow(
                  color: item.variance != 0
                      ? WidgetStateProperty.all(varianceColor.withOpacity(0.05))
                      : null,
                  cells: [
                    DataCell(
                      Text(
                        item.productName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    DataCell(Text('${item.systemStock}')),
                    DataCell(Text('${item.actualStock}')),
                    DataCell(
                      Text(
                        item.variance >= 0
                            ? '+${item.variance}'
                            : '${item.variance}',
                        style: TextStyle(
                          color: varianceColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildVarianceCard(_AuditLineItem item) {
    final isPositive = item.variance > 0;
    final color = isPositive ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.add_circle : Icons.remove_circle,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'System: ${item.systemStock} → Actual: ${item.actualStock}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isPositive ? '+${item.variance}' : '${item.variance}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditLineItem {
  final String productId;
  final String productName;
  final int systemStock;
  final int actualStock;
  final int variance;

  _AuditLineItem({
    required this.productId,
    required this.productName,
    required this.systemStock,
    required this.actualStock,
    required this.variance,
  });
}
