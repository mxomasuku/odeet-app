import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/loading_button.dart';
import '../../router/app_router.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/shop_repository.dart';

class ShopOnboardingPage extends ConsumerStatefulWidget {
  const ShopOnboardingPage({super.key});

  @override
  ConsumerState<ShopOnboardingPage> createState() => _ShopOnboardingPageState();
}

class _ShopOnboardingPageState extends ConsumerState<ShopOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isAddingNew = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _codeController.clear();
    _addressController.clear();
    _cityController.clear();
    _phoneController.clear();
  }

  Future<void> _handleDeleteShop(String shopId, String shopName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shop'),
        content: Text(
          'Are you sure you want to delete "$shopName"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // In a real app, you'd want to check if the shop has sales/products first
      // For now, we'll just soft delete via repository if available, or just throw unimplemented
      // Since repository implementation for delete might be missing, let's check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shop deletion not implemented yet (safety)'),
        ),
      );
    }
  }

  Future<void> _handleAddShop() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(shopRepositoryProvider).createShop(
            name: _nameController.text,
            code: _codeController.text.isNotEmpty ? _codeController.text : null,
            address: _addressController.text.isNotEmpty
                ? _addressController.text
                : null,
            city: _cityController.text.isNotEmpty ? _cityController.text : null,
            phone:
                _phoneController.text.isNotEmpty ? _phoneController.text : null,
            // Only set first shop as head office if there are no other shops
            isHeadOffice: false, // Logic can be refined
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shop added successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        // Navigate to dashboard
        context.go(AppRoutes.dashboard);
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
    final shopsAsync = ref.watch(shopsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isAddingNew ? 'Add Shop' : 'Manage Shops'),
        leading: _isAddingNew
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _isAddingNew = false),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(AppRoutes.settings),
              ),
      ),
      body: shopsAsync.when(
        data: (shops) {
          // If no shops and not explicitly adding, force add mode
          if (shops.isEmpty && !_isAddingNew) {
            // Effectively "Add First Shop" mode
            return _buildForm(isFirstShop: true);
          }

          // If explicitly adding new shop
          if (_isAddingNew) {
            return _buildForm(isFirstShop: false);
          }

          // List View
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child:
                        const Icon(Icons.store, color: AppTheme.primaryColor),
                  ),
                  title: Text(shop.name),
                  subtitle:
                      Text(shop.city ?? shop.address ?? 'No location info'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () => _handleDeleteShop(shop.id, shop.name),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading shops: $e')),
      ),
      floatingActionButton:
          (!_isAddingNew && shopsAsync.valueOrNull?.isNotEmpty == true)
              ? FloatingActionButton(
                  onPressed: () => setState(() => _isAddingNew = true),
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }

  Widget _buildForm({required bool isFirstShop}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isFirstShop) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      AppTheme.accentColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.store,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Add Your First Shop',
                      style: AppTextStyles.heading3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Set up your shop to start managing inventory and sales',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Shop name (required)
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Shop Name *',
                prefixIcon: Icon(Icons.store_outlined),
                hintText: 'e.g. Main Branch',
              ),
              validator: (value) =>
                  Validators.required(value, fieldName: 'Shop name'),
            ),
            const SizedBox(height: 16),

            // Shop code (optional)
            TextFormField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Shop Code (Optional)',
                prefixIcon: Icon(Icons.tag),
                hintText: 'e.g. MB01',
              ),
            ),
            const SizedBox(height: 16),

            // Address (optional)
            TextFormField(
              controller: _addressController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Address (Optional)',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // City (optional)
            TextFormField(
              controller: _cityController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'City (Optional)',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Phone (optional)
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Contact Phone (Optional)',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 32),

            // Add shop button
            LoadingButton(
              onPressed: _handleAddShop,
              isLoading: _isLoading,
              child: Text(isFirstShop ? 'Add Shop & Continue' : 'Add Shop'),
            ),

            if (isFirstShop) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(AppRoutes.dashboard),
                child: const Text('Skip for Now'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
