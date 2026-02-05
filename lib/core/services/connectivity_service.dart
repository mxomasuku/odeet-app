import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity status enum
enum ConnectivityStatus {
  online,
  offline,
}

/// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Provider for current connectivity status
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  return ref.watch(connectivityServiceProvider).statusStream;
});

/// Service for monitoring network connectivity
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityStatus> _statusController =
      StreamController<ConnectivityStatus>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  ConnectivityStatus _currentStatus = ConnectivityStatus.offline;

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get statusStream => _statusController.stream;

  /// Current connectivity status
  ConnectivityStatus get currentStatus => _currentStatus;

  /// Whether currently online
  bool get isOnline => _currentStatus == ConnectivityStatus.online;

  /// Initialize the connectivity monitoring
  Future<void> initialize() async {
    // Check initial status
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  /// Update connectivity status based on results
  void _updateStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );

    final newStatus =
        hasConnection ? ConnectivityStatus.online : ConnectivityStatus.offline;

    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(newStatus);
    }
  }

  /// Check connectivity manually
  Future<ConnectivityStatus> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);
    return _currentStatus;
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
