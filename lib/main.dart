import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'firebase_options.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/sync_service.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/router/app_router.dart';
import 'presentation/providers/theme_mode_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connect to Firebase Emulators only in Debug Mode AND on simulators/emulators
  if (kDebugMode) {
    final isEmulatorDevice = await _isRunningOnEmulator();
    if (isEmulatorDevice) {
      try {
        // For Android emulator: use 10.0.2.2 (special alias for host loopback)
        // For iOS simulator: use localhost
        final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
        await FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);
        FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8080);
        await FirebaseStorage.instance
            .useStorageEmulator(localHostString, 9199);
        FirebaseFunctions.instance.useFunctionsEmulator(localHostString, 5001);
        debugPrint('Connected to Firebase Emulators');
      } catch (e) {
        debugPrint('Error connecting to Firebase Emulators: $e');
      }
    } else {
      debugPrint('Running on physical device - using production Firebase');
    }
  }

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Register Hive adapters
  await _registerHiveAdapters();

  // Open Hive boxes
  await _openHiveBoxes();

  runApp(
    const ProviderScope(
      child: StockTakeApp(),
    ),
  );
}

Future<void> _registerHiveAdapters() async {
  // Adapters are registered here after code generation
  // Hive.registerAdapter(ProductModelAdapter());
  // Hive.registerAdapter(SaleModelAdapter());
  // etc.
}

/// Detects if the app is running on an emulator/simulator (returns true)
/// or a physical device (returns false)
Future<bool> _isRunningOnEmulator() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    final isEmulator = !androidInfo.isPhysicalDevice;
    debugPrint(
        'Android device - isPhysicalDevice: ${androidInfo.isPhysicalDevice}, using emulators: $isEmulator');
    return isEmulator;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    final isSimulator = !iosInfo.isPhysicalDevice;
    debugPrint(
        'iOS device - isPhysicalDevice: ${iosInfo.isPhysicalDevice}, using emulators: $isSimulator');
    return isSimulator;
  }
  debugPrint('Unknown platform - defaulting to production Firebase');
  return false;
}

Future<void> _openHiveBoxes() async {
  await Hive.openBox('products');
  await Hive.openBox('sales');
  await Hive.openBox('inventory');
  await Hive.openBox('transfers');
  await Hive.openBox('cash_collections');
  await Hive.openBox('sync_queue');
  await Hive.openBox('settings');
  await Hive.openBox('user');
  await Hive.openBox('shops');
  await Hive.openBox('categories');
}

class StockTakeApp extends ConsumerStatefulWidget {
  const StockTakeApp({super.key});

  @override
  ConsumerState<StockTakeApp> createState() => _StockTakeAppState();
}

class _StockTakeAppState extends ConsumerState<StockTakeApp> {
  @override
  void initState() {
    super.initState();
    // Initialize connectivity monitoring
    ref.read(connectivityServiceProvider).initialize();
    // Start sync service
    ref.read(syncServiceProvider).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'StockTake',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
