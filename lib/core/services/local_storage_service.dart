import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../constants/firestore_paths.dart';

/// Provider for local storage service
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

/// Service for managing local Hive storage
class LocalStorageService {
  /// Get a value from a box
  T? get<T>(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.get(key) as T?;
  }

  /// Put a value in a box
  Future<void> put(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  /// Delete a value from a box
  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  /// Get all values from a box
  List<T> getAll<T>(String boxName) {
    final box = Hive.box(boxName);
    return box.values.cast<T>().toList();
  }

  /// Get all keys from a box
  List<dynamic> getKeys(String boxName) {
    final box = Hive.box(boxName);
    return box.keys.toList();
  }

  /// Clear all values from a box
  Future<void> clear(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  /// Check if a key exists in a box
  bool containsKey(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.containsKey(key);
  }

  /// Get count of items in a box
  int count(String boxName) {
    final box = Hive.box(boxName);
    return box.length;
  }

  /// Store a JSON-serializable object
  Future<void> putJson(
    String boxName,
    String key,
    Map<String, dynamic> json,
  ) async {
    await put(boxName, key, jsonEncode(json));
  }

  /// Retrieve a JSON object
  Map<String, dynamic>? getJson(String boxName, String key) {
    final value = get<String>(boxName, key);
    if (value == null) return null;
    return jsonDecode(value) as Map<String, dynamic>;
  }

  /// Get all JSON objects from a box
  List<Map<String, dynamic>> getAllJson(String boxName) {
    final box = Hive.box(boxName);
    return box.values
        .map((value) => jsonDecode(value as String) as Map<String, dynamic>)
        .toList();
  }

  /// Store user settings
  Future<void> saveSetting(String key, dynamic value) async {
    await put(HiveBoxes.settings, key, value);
  }

  /// Get user setting
  T? getSetting<T>(String key) {
    return get<T>(HiveBoxes.settings, key);
  }

  /// Save current user data
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await putJson(HiveBoxes.user, 'current', userData);
  }

  /// Get current user data
  Map<String, dynamic>? getCurrentUser() {
    return getJson(HiveBoxes.user, 'current');
  }

  /// Clear current user data
  Future<void> clearUser() async {
    await clear(HiveBoxes.user);
  }

  /// Clear all app data (for logout)
  Future<void> clearAllData() async {
    await clear(HiveBoxes.products);
    await clear(HiveBoxes.sales);
    await clear(HiveBoxes.inventory);
    await clear(HiveBoxes.transfers);
    await clear(HiveBoxes.cashCollections);
    await clear(HiveBoxes.syncQueue);
    await clear(HiveBoxes.user);
    await clear(HiveBoxes.shops);
    await clear(HiveBoxes.categories);
    // Keep settings
  }
}
