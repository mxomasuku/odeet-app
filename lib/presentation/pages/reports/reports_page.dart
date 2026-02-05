import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stocktake/presentation/theme/app_text_styles.dart';
import '../../theme/app_theme.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReportCard(
            context,
            icon: Icons.table_chart,
            title: 'Stock Audit',
            subtitle: 'Conduct a new stock audit for a shop',
            color: AppTheme.primaryColor,
            onTap: () => context.push('/reports/audit'),
          ),
          _buildReportCard(
            context,
            icon: Icons.history,
            title: 'Audit History',
            subtitle: 'View completed audits and reports',
            color: Colors.teal,
            onTap: () => context.push('/reports/audit/history'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
