import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Storage Service for local data persistence
class StorageService {
  StorageService._();
  
  static late Box _userBox;
  static late Box _settingsBox;
  static late Box _cacheBox;
  static late SharedPreferences _prefs;
  
  /// Initialize storage services
  static Future<void> initialize() async {
    // Initialize Hive boxes
    _userBox = await Hive.openBox('user_data');
    _settingsBox = await Hive.openBox('app_settings');
    _cacheBox = await Hive.openBox('cache_data');
    
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
  }

  // User Data Management
  static Future<void> saveUserToken(String token) async {
    await _userBox.put(AppConstants.userTokenKey, token);
  }

  static String? getUserToken() {
    return _userBox.get(AppConstants.userTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _userBox.put(AppConstants.refreshTokenKey, token);
  }

  static String? getRefreshToken() {
    return _userBox.get(AppConstants.refreshTokenKey);
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _userBox.put(AppConstants.userDataKey, jsonEncode(userData));
  }

  static Map<String, dynamic>? getUserData() {
    final userData = _userBox.get(AppConstants.userDataKey);
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  static Future<void> clearUserData() async {
    await _userBox.delete(AppConstants.userTokenKey);
    await _userBox.delete(AppConstants.refreshTokenKey);
    await _userBox.delete(AppConstants.userDataKey);
  }

  // App Settings Management
  static Future<void> setOnboardingComplete(bool value) async {
    await _settingsBox.put(AppConstants.onboardingCompleteKey, value);
  }

  static bool isOnboardingComplete() {
    return _settingsBox.get(AppConstants.onboardingCompleteKey, defaultValue: false);
  }

  static Future<void> setLanguageSelectionComplete(bool value) async {
    await _settingsBox.put(AppConstants.languageSelectionCompleteKey, value);
  }

  static bool isLanguageSelectionComplete() {
    return _settingsBox.get(AppConstants.languageSelectionCompleteKey, defaultValue: false);
  }

  static Future<void> setSelectedLanguage(String languageCode) async {
    await _settingsBox.put(AppConstants.selectedLanguageKey, languageCode);
    // ! IMPORTANT: Mark language selection as complete when language is set
    await setLanguageSelectionComplete(true);
  }

  static String getSelectedLanguage() {
    return _settingsBox.get(AppConstants.selectedLanguageKey, 
        defaultValue: AppConstants.defaultLanguage);
  }

  static Future<void> setBiometricEnabled(bool value) async {
    await _settingsBox.put(AppConstants.biometricEnabledKey, value);
  }

  static bool isBiometricEnabled() {
    return _settingsBox.get(AppConstants.biometricEnabledKey, defaultValue: false);
  }

  static Future<void> setNotificationEnabled(bool value) async {
    await _settingsBox.put(AppConstants.notificationEnabledKey, value);
  }

  static bool isNotificationEnabled() {
    return _settingsBox.get(AppConstants.notificationEnabledKey, defaultValue: true);
  }

  // * ADDITIONAL GENERIC METHODS FOR ROUTER COMPATIBILITY
  static Future<bool?> getBool(String key) async {
    return _settingsBox.get(key) as bool?;
  }

  static Future<String?> getString(String key) async {
    return _userBox.get(key) as String?;
  }

  static Future<void> setBool(String key, bool value) async {
    await _settingsBox.put(key, value);
  }

  static Future<void> setString(String key, String value) async {
    await _userBox.put(key, value);
  }

  // Cache Management
  static Future<void> saveOfflineData(String key, Map<String, dynamic> data) async {
    await _cacheBox.put('${AppConstants.offlineDataKey}_$key', jsonEncode(data));
  }

  static Map<String, dynamic>? getOfflineData(String key) {
    final data = _cacheBox.get('${AppConstants.offlineDataKey}_$key');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  static Future<void> clearOfflineData() async {
    final keys = _cacheBox.keys.where((key) => 
        key.toString().startsWith(AppConstants.offlineDataKey)).toList();
    for (final key in keys) {
      await _cacheBox.delete(key);
    }
  }

  static Future<void> setLastSyncTime(DateTime dateTime) async {
    await _cacheBox.put(AppConstants.lastSyncTimeKey, dateTime.millisecondsSinceEpoch);
  }

  static DateTime? getLastSyncTime() {
    final timestamp = _cacheBox.get(AppConstants.lastSyncTimeKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  // Generic Cache Methods
  static Future<void> cacheData(String key, dynamic data, {Duration? expiry}) async {
    final cacheItem = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };
    await _cacheBox.put(key, jsonEncode(cacheItem));
  }

  static T? getCachedData<T>(String key) {
    final cachedItem = _cacheBox.get(key);
    if (cachedItem != null) {
      final decoded = jsonDecode(cachedItem);
      final timestamp = decoded['timestamp'] as int;
      final expiry = decoded['expiry'] as int?;
      
      // Check if cache has expired
      if (expiry != null) {
        final expiryTime = DateTime.fromMillisecondsSinceEpoch(timestamp + expiry);
        if (DateTime.now().isAfter(expiryTime)) {
          _cacheBox.delete(key); // Remove expired cache
          return null;
        }
      }
      
      return decoded['data'] as T;
    }
    return null;
  }

  static Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  // Utility Methods
  static Future<void> clearAllData() async {
    await _userBox.clear();
    await _settingsBox.clear();
    await _cacheBox.clear();
    await _prefs.clear();
  }

  static Future<int> getStorageSize() async {
    // Calculate approximate storage size
    int size = 0;
    
    // Hive boxes
    size += _userBox.length;
    size += _settingsBox.length;
    size += _cacheBox.length;
    
    return size;
  }

  // Backup and Restore
  static Future<Map<String, dynamic>> createBackup() async {
    return {
      'user_data': _userBox.toMap(),
      'settings': _settingsBox.toMap(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'version': AppConstants.appVersion,
    };
  }

  static Future<bool> restoreFromBackup(Map<String, dynamic> backup) async {
    try {
      // Validate backup
      if (backup['version'] != AppConstants.appVersion) {
        // Handle version mismatch
        return false;
      }
      
      // Restore user data
      final userData = backup['user_data'] as Map?;
      if (userData != null) {
        await _userBox.clear();
        await _userBox.putAll(userData.cast<String, dynamic>());
      }
      
      // Restore settings
      final settings = backup['settings'] as Map?;
      if (settings != null) {
        await _settingsBox.clear();
        await _settingsBox.putAll(settings.cast<String, dynamic>());
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Migration Methods
  static Future<void> migrateData() async {
    // Handle data migration between app versions
    final currentVersion = AppConstants.appVersion;
    final storedVersion = _settingsBox.get('app_version', defaultValue: '1.0.0');
    
    if (currentVersion != storedVersion) {
      // Perform migration based on version differences
      await _performMigration(storedVersion, currentVersion);
      await _settingsBox.put('app_version', currentVersion);
    }
  }

  static Future<void> _performMigration(String fromVersion, String toVersion) async {
    // Implement version-specific migration logic
    // Example: migrate from 1.0.0 to 1.1.0
    if (fromVersion == '1.0.0' && toVersion == '1.1.0') {
      // Add new default settings
      await setNotificationEnabled(true);
    }
  }
}

/// Storage Exception for error handling
class StorageException implements Exception {
  final String message;
  final dynamic originalError;

  const StorageException(this.message, [this.originalError]);

  @override
  String toString() => 'StorageException: $message';
}

/// Storage Helper Extensions
extension StorageHelpers on StorageService {
  static Future<void> saveList<T>(String key, List<T> list) async {
    await StorageService._cacheBox.put(key, jsonEncode(list));
  }

  static List<T>? getList<T>(String key) {
    final data = StorageService._cacheBox.get(key);
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      return decoded.cast<T>();
    }
    return null;
  }

  static Future<void> saveMap(String key, Map<String, dynamic> map) async {
    await StorageService._cacheBox.put(key, jsonEncode(map));
  }

  static Map<String, dynamic>? getMap(String key) {
    final data = StorageService._cacheBox.get(key);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  static bool hasKey(String key) {
    return StorageService._cacheBox.containsKey(key);
  }

  static Future<void> removeKey(String key) async {
    await StorageService._cacheBox.delete(key);
  }

  static List<String> getAllKeys() {
    return StorageService._cacheBox.keys.cast<String>().toList();
  }
}
