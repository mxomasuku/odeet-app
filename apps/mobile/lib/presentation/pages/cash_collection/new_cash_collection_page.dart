import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stocktake/presentation/theme/app_text_styles.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common/common_widgets.dart';

class NewCashCollectionPage extends ConsumerStatefulWidget {
  const NewCashCollectionPage({super.key});

  @override
  ConsumerState<NewCashCollectionPage> createState() =>
      _NewCashCollectionPageState();
}

class _NewCashCollectionPageState extends ConsumerState<NewCashCollectionPage> {
  String? _selectedShop;
  final Map<String, int> _denominations = {};
  final _notesController = TextEditingController();
  bool _isLoading = false;

  // USD denominations
  final _bills = ['100', '50', '20', '10', '5', '2', '1'];
  final _coins = ['0.50', '0.25', '0.10', '0.05', '0.01'];

  double get _total {
    double sum = 0;
    _denominations.forEach((denom, count) {
      sum += double.parse(denom) * count;
    });
    return sum;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Cash Collection')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedShop,
                  decoration: const InputDecoration(
                    labelText: 'Shop *',
                    prefixIcon: Icon(Icons.store),
                  ),
                  items: ['Head Office', 'Branch A', 'Branch B']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedShop = v),
                ),
                const SizedBox(height: 16),

                // Expected amount (from system)
                Card(
                  color: AppTheme.infoColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Expected Amount'),
                        Text(
                          '\$523.45',
                          style: AppTextStyles.heading4
                              .copyWith(color: AppTheme.infoColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Count Cash', style: AppTextStyles.heading4),
                const SizedBox(height: 16),

                // Bills
                Text(
                  'Bills',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._bills
                    .map((denom) => _buildDenominationRow(denom, '\$$denom')),

                const SizedBox(height: 16),
                Text(
                  'Coins',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._coins
                    .map((denom) => _buildDenominationRow(denom, '\$$denom')),

                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),

          // Total and submit
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Counted'),
                      Text(
                        '\$${_total.toStringAsFixed(2)}',
                        style: AppTextStyles.heading3
                            .copyWith(color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                  if (_selectedShop != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Variance'),
                        Builder(
                          builder: (context) {
                            final variance = _total - 523.45;
                            return Text(
                              variance >= 0
                                  ? '+\$${variance.toStringAsFixed(2)}'
                                  : '-\$${variance.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                color: variance == 0
                                    ? null
                                    : variance > 0
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  LoadingButton(
                    onPressed: _selectedShop != null ? _submit : () {},
                    isLoading: _isLoading,
                    child: const Text('Submit Collection'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDenominationRow(String denom, String label) {
    final count = _denominations[denom] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label)),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: count > 0
                ? () => setState(() => _denominations[denom] = count - 1)
                : null,
          ),
          SizedBox(
            width: 40,
            child: Text('$count', textAlign: TextAlign.center),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => setState(() => _denominations[denom] = count + 1),
          ),
          const Spacer(),
          Text('\$${(double.parse(denom) * count).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Collection submitted'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      context.pop();
    }
  }
}
