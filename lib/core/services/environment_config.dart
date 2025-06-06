// ===================================================================
// * ENVIRONMENT CONFIGURATION SERVICE
// * Purpose: Centralized environment-specific configuration
// * Security Level: LOW - Configuration management only
// ===================================================================

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

class EnvironmentConfig {
  EnvironmentConfig._();

  // * ENVIRONMENT DETECTION
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  // * APP CONFIGURATION
  static const String appName = 'CropFresh Farmers';
  static const String appVersion = '1.0.0+1';
  static const String defaultLanguage = 'en';
  static const bool debugMode = !bool.fromEnvironment('dart.vm.product');
  static const bool enableDarkMode = true;
  static const bool enablePerformanceOverlay = false;
  static const bool enablePushNotifications = true;
  static const bool mockApiEnabled = false;

  // * API ENDPOINTS
  static String get apiBaseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.cropfresh.com/v1';
      case 'staging':
        return 'https://api-staging.cropfresh.com/v1';
      default:
        return 'https://api-dev.cropfresh.com/v1';
    }
  }

  static String get websocketBaseUrl {
    switch (environment) {
      case 'production':
        return 'wss://api.cropfresh.com/ws';
      case 'staging':
        return 'wss://api-staging.cropfresh.com/ws';
      default:
        return 'wss://api-dev.cropfresh.com/ws';
    }
  }

  // * INITIALIZATION
  static Future<void> initialize() async {
    // Initialize any environment-specific configurations
    // This can be expanded for future environment setup
  }

  // * VALIDATION
  static void validateEnvironment() {
    // Add any environment validation logic here
    if (isProduction && debugMode) {
      throw Exception('Debug mode should not be enabled in production');
    }
  }
}

// ===================================================================
// * ENVIRONMENT CONFIGURATION SERVICE
// * Purpose: Centralized environment variable management and validation
// * Features: Load .env files, validate config, provide typed access
// * Security Level: High - Manages sensitive configuration data
// ===================================================================

class EnvironmentConfigManager {
  // ? TODO: Add runtime environment switching capability
  
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
  
  static bool _isInitialized = false;
  
  // * INITIALIZATION
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // ! ALERT: Load environment-specific configuration file
      String envFile = _getEnvironmentFile();
      await dotenv.load(fileName: envFile);
      
      _isInitialized = true;
      _logger.i('✅ Environment configuration loaded successfully from $envFile');
      
      // Log current environment (non-sensitive data only)
      _logger.i('🌍 Environment: ${EnvironmentConfig.environment.toUpperCase()}');
      _logger.i('🏗️ App Version: ${EnvironmentConfig.appVersion}');
      _logger.i('🌐 API Base URL: ${EnvironmentConfig.apiBaseUrl}');
      _logger.i('🌍 Default Language: ${EnvironmentConfig.defaultLanguage}');
      
    } catch (e) {
      _logger.e('❌ Failed to load environment configuration: $e');
      throw EnvironmentConfigException('Failed to load environment configuration: $e');
    }
  }
  
  // * ENVIRONMENT DETECTION
  static String _getEnvironmentFile() {
    // ! ALERT: Determine which .env file to load based on build configuration
    
    // Check for environment variable override
    const envOverride = String.fromEnvironment('ENV');
    if (envOverride.isNotEmpty) {
      return '.env.$envOverride';
    }
    
    // Default environment logic
    if (kDebugMode) {
      return '.env.development';
    } else if (kProfileMode) {
      return '.env.staging';
    } else {
      return '.env.production';
    }
  }
  
  // * VALIDATION
  static void validateEnvironment() {
    if (!_isInitialized) {
      throw EnvironmentConfigException('Environment not initialized. Call initialize() first.');
    }
    
    final missingVariables = <String>[];
    final invalidVariables = <String>[];
    
    // ! ALERT: Validate required environment variables
    _validateRequired('APP_ENV', missingVariables);
    _validateRequired('APP_NAME', missingVariables);
    _validateRequired('API_BASE_URL', missingVariables);
    
    // Validate API configuration
    _validateUrl('API_BASE_URL', invalidVariables);
    _validateUrl('WEATHER_API_URL', invalidVariables);
    
    // Validate numeric values
    _validateNumeric('API_TIMEOUT', invalidVariables);
    _validateNumeric('API_RETRY_ATTEMPTS', invalidVariables);
    
    // Validate boolean values
    _validateBoolean('DEBUG_MODE', invalidVariables);
    _validateBoolean('ENABLE_PUSH_NOTIFICATIONS', invalidVariables);
    _validateBoolean('ENABLE_OFFLINE_MODE', invalidVariables);
    
    // Report validation results
    if (missingVariables.isNotEmpty) {
      _logger.e('❌ Missing required environment variables: ${missingVariables.join(', ')}');
      throw EnvironmentConfigException('Missing required environment variables: ${missingVariables.join(', ')}');
    }
    
    if (invalidVariables.isNotEmpty) {
      _logger.w('⚠️ Invalid environment variables detected: ${invalidVariables.join(', ')}');
    }
    
    _logger.i('✅ Environment validation completed successfully');
  }
  
  static void _validateRequired(String key, List<String> missingVariables) {
    if (!dotenv.env.containsKey(key) || dotenv.env[key]!.isEmpty) {
      missingVariables.add(key);
    }
  }
  
  static void _validateUrl(String key, List<String> invalidVariables) {
    final value = dotenv.env[key];
    if (value != null && value.isNotEmpty) {
      final uri = Uri.tryParse(value);
      if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        invalidVariables.add('$key (invalid URL format)');
      }
    }
  }
  
  static void _validateNumeric(String key, List<String> invalidVariables) {
    final value = dotenv.env[key];
    if (value != null && value.isNotEmpty) {
      if (int.tryParse(value) == null && double.tryParse(value) == null) {
        invalidVariables.add('$key (not a valid number)');
      }
    }
  }
  
  static void _validateBoolean(String key, List<String> invalidVariables) {
    final value = dotenv.env[key]?.toLowerCase();
    if (value != null && value.isNotEmpty) {
      if (value != 'true' && value != 'false') {
        invalidVariables.add('$key (not a valid boolean)');
      }
    }
  }
  
  // * TYPED ACCESSORS
  static String getString(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }
  
  static int getInt(String key, {int defaultValue = 0}) {
    final value = dotenv.env[key];
    return value != null ? int.tryParse(value) ?? defaultValue : defaultValue;
  }
  
  static double getDouble(String key, {double defaultValue = 0.0}) {
    final value = dotenv.env[key];
    return value != null ? double.tryParse(value) ?? defaultValue : defaultValue;
  }
  
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = dotenv.env[key]?.toLowerCase();
    if (value == 'true') return true;
    if (value == 'false') return false;
    return defaultValue;
  }
  
  static List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) return defaultValue;
    return value.split(',').map((e) => e.trim()).toList();
  }
  
  // * FEATURE FLAGS
  static bool get enablePushNotifications {
    if (!_isInitialized) return EnvironmentConfig.enablePushNotifications;
    return getBool('ENABLE_PUSH_NOTIFICATIONS', defaultValue: true);
  }
  
  static bool get enableDarkMode {
    if (!_isInitialized) return EnvironmentConfig.enableDarkMode;
    return getBool('ENABLE_DARK_MODE', defaultValue: true);
  }
  
  static bool get enableOfflineMode {
    return getBool('ENABLE_OFFLINE_MODE', defaultValue: true);
  }
  
  static bool get enableBiometricAuth {
    return getBool('ENABLE_BIOMETRIC_AUTH', defaultValue: true);
  }
  
  static bool get enableAIFeatures {
    return getBool('ENABLE_AI_FEATURES', defaultValue: false);
  }
  
  static bool get enableFinancialServices {
    return getBool('ENABLE_FINANCIAL_SERVICES', defaultValue: false);
  }
  
  // * CONFIGURATION MAP
  static Map<String, dynamic> get configMap {
    return {
      'environment': EnvironmentConfig.environment,
      'app_name': EnvironmentConfig.appName,
      'app_version': EnvironmentConfig.appVersion,
      'api_base_url': EnvironmentConfig.apiBaseUrl,
      'is_production': EnvironmentConfig.isProduction,
      'debug_mode': EnvironmentConfig.debugMode,
      'features': {
        'push_notifications': enablePushNotifications,
        'offline_mode': enableOfflineMode,
        'dark_mode': enableDarkMode,
        'biometric_auth': enableBiometricAuth,
        'ai_features': enableAIFeatures,
        'financial_services': enableFinancialServices,
      },
    };
  }
}

// * CUSTOM EXCEPTIONS
class EnvironmentConfigException implements Exception {
  final String message;
  
  const EnvironmentConfigException(this.message);
  
  @override
  String toString() => 'EnvironmentConfigException: $message';
}
