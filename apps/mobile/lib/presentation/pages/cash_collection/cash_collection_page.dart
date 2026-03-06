import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/common_widgets.dart';
import '../../../core/constants/app_constants.dart';

class CashCollectionPage extends ConsumerWidget {
  const CashCollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cash Collections')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          final collection = (
            id: 'cc_$index',
            number: 'CC${1000 + index}',
            shop: 'Branch ${index + 1}',
            expected: 500.0 + index * 100,
            actual: 500.0 +
                index * 100 +
                (index == 1
                    ? -10
                    : index == 2
                        ? 5
                        : 0),
            status: index == 0
                ? CashCollectionStatus.pending
                : index == 1
                    ? CashCollectionStatus.collected
                    : CashCollectionStatus.confirmed,
          );
          final variance = collection.actual - collection.expected;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(collection.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payments,
                  color: _getStatusColor(collection.status),
                ),
              ),
              title: Text(collection.number),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(collection.shop),
                  Row(
                    children: [
                      StatusBadge(
                        label: collection.status.displayName,
                        color: _getStatusColor(collection.status),
                      ),
                      if (variance != 0) ...[
                        const SizedBox(width: 8),
                        StatusBadge(
                          label: variance > 0
                              ? '+\$${variance.abs().toStringAsFixed(2)}'
                              : '-\$${variance.abs().toStringAsFixed(2)}',
                          color: variance > 0
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: Text(
                '\$${collection.actual.toStringAsFixed(2)}',
                style: AppTextStyles.bodyLarge
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.newCashCollection),
        icon: const Icon(Icons.add),
        label: const Text('New Collection'),
      ),
    );
  }

  Color _getStatusColor(CashCollectionStatus status) {
    switch (status) {
      case CashCollectionStatus.pending:
        return AppTheme.warningColor;
      case CashCollectionStatus.collected:
        return AppTheme.infoColor;
      case CashCollectionStatus.confirmed:
        return AppTheme.successColor;
      case CashCollectionStatus.disputed:
        return AppTheme.errorColor;
    }
  }
}
