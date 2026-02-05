import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../../data/repositories/shop_repository.dart';
import 'tabs/shop_inventory_view.dart';
import 'tabs/shop_sales_view.dart';

class ShopDetailPage extends ConsumerStatefulWidget {
  final String shopId;

  const ShopDetailPage({
    super.key,
    required this.shopId,
  });

  @override
  ConsumerState<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends ConsumerState<ShopDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopAsync = ref.watch(shopProvider(widget.shopId));

    return Scaffold(
      appBar: AppBar(
        title: shopAsync.when(
          data: (shop) => Text(shop?.name ?? 'Shop Details'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Shop Details'),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Stock'),
            Tab(text: 'Sales'),
          ],
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: shopAsync.when(
        data: (shop) {
          if (shop == null) {
            return const Center(child: Text('Shop not found'));
          }
          return TabBarView(
            controller: _tabController,
            children: [
              ShopInventoryView(shop: shop),
              ShopSalesView(shop: shop),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget? _buildFab() {
    if (_tabController.index == 0) {
      // Inventory Tab
      return FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add product for this shop context
          // Since product creation is organization-global but stock is per-shop
          // We might direct to bulk adding stock, or creating a new global product
          // For now, let's offer bulk add as primary, or standard add
          _showAddOptions(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Products'),
      );
    } else {
      // Sales Tab
      return FloatingActionButton.extended(
        onPressed: () {
          context.push('/sales/new');
        },
        icon: const Icon(Icons.point_of_sale),
        label: const Text('New Sale'),
      );
    }
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.playlist_add),
            title: const Text('Bulk Add Products'),
            subtitle: const Text('Add multiple products quickly'),
            onTap: () {
              Navigator.pop(context);
              context.push(
                Uri(
                  path: '/inventory/bulk-add',
                  queryParameters: {'shopIds': widget.shopId},
                ).toString(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Create New Product'),
            subtitle: const Text('Create a single product definition'),
            onTap: () {
              Navigator.pop(context);
              context.push('/inventory/add');
            },
          ),
        ],
      ),
    );
  }
}
