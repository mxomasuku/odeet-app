import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/shop_model.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../data/services/stock_audit_service.dart';

class AuditHistoryPage extends ConsumerStatefulWidget {
  const AuditHistoryPage({super.key});

  @override
  ConsumerState<AuditHistoryPage> createState() => _AuditHistoryPageState();
}

class _AuditHistoryPageState extends ConsumerState<AuditHistoryPage> {
  ShopModel? _selectedShop;
  bool _isLoading = false;
  bool _hasInitiallyLoaded = false;
  List<StockAuditRecord> _audits = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitiallyLoaded) {
        _hasInitiallyLoaded = true;
        _loadAudits();
      }
    });
  }

  Future<void> _loadAudits() async {
    if (_isLoading) return; // Prevent overlapping calls
    setState(() => _isLoading = true);
    try {
      final audits = await ref.read(stockAuditServiceProvider).getAuditHistory(
            shopId: _selectedShop?.id,
          );
      setState(() => _audits = audits);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading audits: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  int _getTotalVariances(StockAuditRecord audit) {
    return audit.variance.values.where((v) => v != 0).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit History'),
      ),
      body: Column(
        children: [
          _buildFilters(context),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _audits.isEmpty
                    ? _buildEmptyState()
                    : _buildAuditList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final shopsAsync = ref.watch(shopsStreamProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardColor,
      child: shopsAsync.when(
        data: (shops) {
          return DropdownButtonFormField<ShopModel?>(
            value: _selectedShop,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Filter by Shop',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: [
              const DropdownMenuItem<ShopModel?>(
                value: null,
                child: Text('All Shops'),
              ),
              ...shops.map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(
                    s.displayName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            onChanged: (shop) {
              setState(() => _selectedShop = shop);
              _loadAudits();
            },
          );
        },
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No audits found'),
          SizedBox(height: 8),
          Text(
            'Complete an audit to see it here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditList() {
    return RefreshIndicator(
      onRefresh: _loadAudits,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _audits.length,
        itemBuilder: (context, index) {
          final audit = _audits[index];
          final varianceCount = _getTotalVariances(audit);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: varianceCount > 0
                    ? Colors.orange.shade100
                    : Colors.green.shade100,
                child: Icon(
                  varianceCount > 0 ? Icons.warning : Icons.check,
                  color:
                      varianceCount > 0 ? Colors.orange.shade700 : Colors.green,
                ),
              ),
              title: Text(
                DateFormat('MMMM d, yyyy').format(audit.auditDate),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('h:mm a').format(audit.auditDate),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${audit.systemStock.length} products'),
                      if (varianceCount > 0) ...[
                        const Text(' • '),
                        Text(
                          '$varianceCount variances',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/reports/audit/history/${audit.id}');
              },
            ),
          );
        },
      ),
    );
  }
}
