import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/services/stock_audit_service.dart';

/// Bottom sheet to show all movements for a product since last audit
class ProductMovementsSheet extends ConsumerStatefulWidget {
  final String shopId;
  final String productId;
  final String productName;
  final DateTime sinceDate;
  final int openingStock;
  final int closingStock;

  const ProductMovementsSheet({
    super.key,
    required this.shopId,
    required this.productId,
    required this.productName,
    required this.sinceDate,
    required this.openingStock,
    required this.closingStock,
  });

  @override
  ConsumerState<ProductMovementsSheet> createState() =>
      _ProductMovementsSheetState();
}

class _ProductMovementsSheetState extends ConsumerState<ProductMovementsSheet> {
  bool _isLoading = true;
  List<ProductMovement> _movements = [];

  @override
  void initState() {
    super.initState();
    _loadMovements();
  }

  Future<void> _loadMovements() async {
    setState(() => _isLoading = true);
    try {
      final movements =
          await ref.read(stockAuditServiceProvider).getProductMovements(
                shopId: widget.shopId,
                productId: widget.productId,
                sinceDate: widget.sinceDate,
              );
      setState(() => _movements = movements);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading movements: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  IconData _getMovementIcon(String type) {
    switch (type) {
      case 'sale':
        return Icons.shopping_cart;
      case 'transfer_in':
        return Icons.arrow_downward;
      case 'transfer_out':
        return Icons.arrow_upward;
      case 'purchase':
        return Icons.add_shopping_cart;
      case 'adjustment':
        return Icons.tune;
      default:
        return Icons.sync;
    }
  }

  Color _getMovementColor(int quantity) {
    return quantity > 0 ? Colors.green : Colors.red;
  }

  String _getMovementLabel(String type) {
    switch (type) {
      case 'sale':
        return 'Sale';
      case 'transfer_in':
        return 'Transfer In';
      case 'transfer_out':
        return 'Transfer Out';
      case 'purchase':
        return 'Purchase';
      case 'adjustment':
        return 'Adjustment';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStockChip(
                          'Opening',
                          widget.openingStock,
                          Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_right_alt, color: Colors.grey),
                        const SizedBox(width: 12),
                        _buildStockChip(
                          'Closing',
                          widget.closingStock,
                          Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Movements since ${DateFormat('MMM d, yyyy').format(widget.sinceDate)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _movements.isEmpty
                        ? _buildEmptyState()
                        : _buildMovementsList(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStockChip(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No movements recorded',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Stock may have been adjusted manually',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementsList(ScrollController scrollController) {
    // Calculate running balance starting from opening stock
    int runningBalance = widget.openingStock;
    final itemsWithBalance = <_MovementWithBalance>[];

    // Sort oldest first to calculate balance
    final sortedMovements = List<ProductMovement>.from(_movements)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final movement in sortedMovements) {
      runningBalance += movement.quantity;
      itemsWithBalance.add(
        _MovementWithBalance(
          movement: movement,
          balanceAfter: runningBalance,
        ),
      );
    }

    // Reverse to show newest first
    itemsWithBalance.reversed.toList();

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: itemsWithBalance.length,
      itemBuilder: (context, index) {
        // Show in reverse order (newest first)
        final item = itemsWithBalance[itemsWithBalance.length - 1 - index];
        final movement = item.movement;
        final color = _getMovementColor(movement.quantity);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getMovementIcon(movement.type),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMovementLabel(movement.type),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy • h:mm a')
                          .format(movement.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    if (movement.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        movement.description!,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),

              // Quantity and Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    movement.quantity > 0
                        ? '+${movement.quantity}'
                        : '${movement.quantity}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Bal: ${item.balanceAfter}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MovementWithBalance {
  final ProductMovement movement;
  final int balanceAfter;

  _MovementWithBalance({
    required this.movement,
    required this.balanceAfter,
  });
}

/// Show the product movements bottom sheet
void showProductMovementsSheet({
  required BuildContext context,
  required String shopId,
  required String productId,
  required String productName,
  required DateTime sinceDate,
  required int openingStock,
  required int closingStock,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ProductMovementsSheet(
      shopId: shopId,
      productId: productId,
      productName: productName,
      sinceDate: sinceDate,
      openingStock: openingStock,
      closingStock: closingStock,
    ),
  );
}
