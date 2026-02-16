import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/connectivity_service.dart';

/// Widget that requires network connectivity to show its child.
/// Shows an overlay when offline, blocking interaction.
///
/// Use this for settings pages and operations that cannot work offline.
class RequiresNetworkWidget extends ConsumerWidget {
  final Widget child;
  final String? message;
  final bool showOverlay;

  const RequiresNetworkWidget({
    super.key,
    required this.child,
    this.message,
    this.showOverlay = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStatusProvider);
    final isOffline =
        connectivityAsync.valueOrNull == ConnectivityStatus.offline;

    if (!isOffline) {
      return child;
    }

    if (showOverlay) {
      return Stack(
        children: [
          child,
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(32),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.cloud_off,
                            size: 48,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Network Required',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message ??
                              'This feature requires an internet connection.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            ref
                                .read(connectivityServiceProvider)
                                .checkConnectivity();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Check Connection'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Non-overlay mode - just replace content
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Network Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'This feature requires an internet connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(connectivityServiceProvider).checkConnectivity();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A smaller indicator that can be placed in forms/buttons
/// to show network status without blocking
class NetworkStatusIndicator extends ConsumerWidget {
  const NetworkStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStatusProvider);
    final isOffline =
        connectivityAsync.valueOrNull == ConnectivityStatus.offline;

    if (!isOffline) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, size: 16, color: Colors.orange),
          SizedBox(width: 6),
          Text(
            'Offline',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mixin to easily check network status in widgets
mixin NetworkCheckMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool get isOnline {
    final status = ref.watch(connectivityStatusProvider);
    return status.valueOrNull == ConnectivityStatus.online;
  }

  bool get isOffline => !isOnline;

  void showOfflineSnackBar([String? message]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'You are currently offline'),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            ref.read(connectivityServiceProvider).checkConnectivity();
          },
        ),
      ),
    );
  }
}
