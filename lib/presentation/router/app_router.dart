import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/blocked_page.dart';
import '../pages/dashboard/dashboard_page.dart';

import '../pages/inventory/product_detail_page.dart';
import '../pages/inventory/add_product_page.dart';
import '../pages/inventory/bulk_add_products_page.dart';
import '../pages/inventory/edit_product_page.dart';
import '../pages/reports/stock_audit_page.dart';
import '../pages/reports/audit_history_page.dart';
import '../pages/reports/audit_detail_page.dart';
import '../pages/sales/sales_page.dart';
import '../pages/sales/new_sale_page.dart';
import '../pages/sales/sale_detail_page.dart';
import '../pages/sales/bulk_add_sales_page.dart';
import '../pages/transfers/transfers_page.dart';
import '../pages/transfers/new_transfer_page.dart';
import '../pages/transfers/transfer_detail_page.dart';
import '../pages/cash_collection/cash_collection_page.dart';
import '../pages/cash_collection/new_cash_collection_page.dart';
import '../pages/reports/reports_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/settings/manage_users_page.dart';
import '../pages/onboarding/shop_onboarding_page.dart';
import '../pages/shops/shop_detail_page.dart';
import '../controllers/auth_controller.dart';

/// Route names
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String blocked = '/blocked';

  // Main
  static const String dashboard = '/';
  static const String inventory = '/inventory';
  static const String productDetail = '/inventory/:id';
  static const String addProduct = '/inventory/add';
  static const String bulkAddProducts = '/inventory/bulk-add';
  static const String editProduct = '/inventory/:id/edit';

  static const String sales = '/sales';
  static const String newSale = '/sales/new';
  static const String bulkSales = '/sales/bulk';
  static const String saleDetail = '/sales/:id';

  static const String transfers = '/transfers';
  static const String newTransfer = '/transfers/new';
  static const String transferDetail = '/transfers/:id';

  static const String cashCollection = '/cash-collection';
  static const String newCashCollection = '/cash-collection/new';

  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String manageUsers = '/settings/users';

  // Onboarding
  static const String shopOnboarding = '/onboarding/shops';
}

/// Notifier that listens to auth state changes for router refresh
class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._ref) {
    _ref.listen(authStateProvider, (previous, next) {
      debugPrint('Auth state changed: $next (was $previous)');
      notifyListeners();
    });

    // Listen to user data for blocked status changes
    // Listen to user data for blocked status changes or logout events
    _ref.listen(currentUserProvider, (previous, next) {
      final wasBlocked = previous?.valueOrNull?.isBlocked ?? false;
      final isBlocked = next.valueOrNull?.isBlocked ?? false;

      final wasLoggedIn = previous?.valueOrNull != null;
      final isLoggedIn = next.valueOrNull != null;

      if (wasBlocked != isBlocked || wasLoggedIn != isLoggedIn) {
        debugPrint(
            'AuthNotifier: User state changed (blocked: $isBlocked, loggedIn: $isLoggedIn)');
        notifyListeners();
      }
    });
  }

  final Ref _ref;

  bool get isLoggedIn {
    // 1. Immediate check: Firebase Auth has a user? (Fixes race condition on login)
    final firebaseUser = _ref.read(authStateProvider).valueOrNull;
    if (firebaseUser != null) return true;

    // 2. Check currentUserProvider for cached user data
    final userAsync = _ref.read(currentUserProvider);
    if (userAsync.valueOrNull != null) return true;

    // 3. Last resort: check raw local session in Hive
    //    This covers the brief window where providers haven't resolved yet
    return _ref.read(hasLocalSessionProvider);
  }

  bool get isLoading {
    final userAsync = _ref.read(currentUserProvider);
    return userAsync.isLoading;
  }

  bool get isBlocked {
    final user = _ref.read(currentUserProvider).valueOrNull;
    return user?.isBlocked ?? false;
  }
}

/// Provider for auth notifier
final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier(ref);
});

/// App router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoading = authNotifier.isLoading;
      final isLoggedIn = authNotifier.isLoggedIn;
      final isBlocked = authNotifier.isBlocked;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup ||
          state.matchedLocation == AppRoutes.forgotPassword;
      final isBlockedRoute = state.matchedLocation == AppRoutes.blocked;

      // If auth state is still loading (and no local session), stay put
      if (isLoading) {
        debugPrint(
            'Router Redirect: auth still loading, staying put at ${state.matchedLocation}');
        return null;
      }

      debugPrint(
        'Router Redirect: location=${state.matchedLocation}, isLoggedIn=$isLoggedIn, isBlocked=$isBlocked',
      );

      // If not logged in and not on auth route, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        debugPrint('Redirecting to login');
        return AppRoutes.login;
      }

      // If logged in and on auth route, redirect to dashboard
      if (isLoggedIn && isAuthRoute) {
        debugPrint('Redirecting to dashboard');
        return AppRoutes.dashboard;
      }

      // If blocked, redirect to blocked page
      if (isLoggedIn && isBlocked && !isBlockedRoute) {
        debugPrint('User is blocked, redirecting to blocked page');
        return AppRoutes.blocked;
      }

      // If NOT blocked but on blocked page, go to dashboard
      if (isLoggedIn && !isBlocked && isBlockedRoute) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.blocked,
        name: 'blocked',
        builder: (context, state) => const BlockedPage(),
      ),

      // Onboarding routes
      GoRoute(
        path: AppRoutes.shopOnboarding,
        name: 'shopOnboarding',
        builder: (context, state) => const ShopOnboardingPage(),
      ),

      // Main app with shell
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/shop/:id',
            name: 'shopDetail',
            builder: (context, state) => ShopDetailPage(
              shopId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '${AppRoutes.inventory}/add',
            name: 'addProduct',
            builder: (context, state) => const AddProductPage(),
          ),
          GoRoute(
            path: '${AppRoutes.inventory}/bulk-add',
            name: 'bulkAddProducts',
            builder: (context, state) {
              final shopIdsStr = state.uri.queryParameters['shopIds'];
              final shopIds = shopIdsStr?.split(',') ?? [];
              return BulkAddProductsPage(shopIds: shopIds);
            },
          ),
          GoRoute(
            path: '${AppRoutes.inventory}/:id',
            name: 'productDetail',
            builder: (context, state) => ProductDetailPage(
              productId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'editProduct',
                builder: (context, state) => EditProductPage(
                  productId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.sales,
            name: 'sales',
            builder: (context, state) => const SalesPage(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'newSale',
                builder: (context, state) => const NewSalePage(),
              ),
              GoRoute(
                path: 'bulk',
                name: 'bulkSales',
                builder: (context, state) => const BulkAddSalesPage(),
              ),
              GoRoute(
                path: ':id',
                name: 'saleDetail',
                builder: (context, state) => SaleDetailPage(
                  saleId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.transfers,
            name: 'transfers',
            builder: (context, state) => const TransfersPage(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'newTransfer',
                builder: (context, state) => const NewTransferPage(),
              ),
              GoRoute(
                path: ':id',
                name: 'transferDetail',
                builder: (context, state) => TransferDetailPage(
                  transferId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.cashCollection,
            name: 'cashCollection',
            builder: (context, state) => const CashCollectionPage(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'newCashCollection',
                builder: (context, state) => const NewCashCollectionPage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.reports,
            name: 'reports',
            builder: (context, state) => const ReportsPage(),
            routes: [
              GoRoute(
                path: 'audit',
                name: 'stockAudit',
                builder: (context, state) => const StockAuditPage(),
              ),
              GoRoute(
                path: 'audit/history',
                name: 'auditHistory',
                builder: (context, state) => const AuditHistoryPage(),
              ),
              GoRoute(
                path: 'audit/history/:id',
                name: 'auditDetail',
                builder: (context, state) => AuditDetailPage(
                  auditId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: AppRoutes.manageUsers,
            name: 'manageUsers',
            builder: (context, state) => const ManageUsersPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
});

/// Main shell with bottom navigation
class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  // Navigation items definition
  List<({IconData icon, IconData activeIcon, String label, String route})>
      _buildNavItems(bool canViewReports) {
    return [
      (
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Dashboard',
        route: AppRoutes.dashboard
      ),
      (
        icon: Icons.point_of_sale_outlined,
        activeIcon: Icons.point_of_sale,
        label: 'Sales',
        route: AppRoutes.sales
      ),
      (
        icon: Icons.swap_horiz_outlined,
        activeIcon: Icons.swap_horiz,
        label: 'Transfers',
        route: AppRoutes.transfers
      ),
      if (canViewReports)
        (
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart,
          label: 'Reports',
          route: AppRoutes.reports
        ),
      (
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: 'Settings',
        route: AppRoutes.settings
      ),
    ];
  }

  int _calculateSelectedIndex(
    BuildContext context,
    List<({IconData icon, IconData activeIcon, String label, String route})>
        items,
  ) {
    final String location = GoRouterState.of(context).uri.path;

    // Handle specific sub-routes matching to parent tabs
    if (location.startsWith('/inventory') || location.startsWith('/shop/')) {
      return 0; // Dashboard tab
    }
    if (location.startsWith('/sales')) {
      return 1; // Sales tab
    }
    if (location.startsWith('/transfers')) {
      return 2; // Transfers tab
    }

    // For dynamic tabs, we need to find the index carefully
    // Check for Reports
    final reportsIndex =
        items.indexWhere((item) => item.route == AppRoutes.reports);
    if (reportsIndex != -1 && location.startsWith('/reports')) {
      return reportsIndex;
    }

    // Settings is usually last
    if (location.startsWith('/settings')) {
      final settingsIndex =
          items.indexWhere((item) => item.route == AppRoutes.settings);
      if (settingsIndex != -1) return settingsIndex;
    }

    // Default matching logic
    for (int i = 0; i < items.length; i++) {
      if (location == items[i].route) {
        return i;
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    // Default to false if user not loaded yet, or check typical roles
    final canViewReports = user?.canViewReports ?? false;

    final navItems = _buildNavItems(canViewReports);
    final currentIndex = _calculateSelectedIndex(context, navItems);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.go(navItems[index].route);
        },
        destinations: navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
