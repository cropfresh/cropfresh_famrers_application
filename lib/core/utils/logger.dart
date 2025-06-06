// * APP LOGGER - CENTRALIZED LOGGING UTILITY
// * Purpose: Provide structured logging with different levels and formatting
// ! SECURITY: Ensure no sensitive data is logged in production

import 'dart:developer' as developer;
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._internal();
  
  late Logger _logger;
  
  AppLogger._internal() {
    _initializeLogger();
  }
  
  // * INITIALIZE LOGGER WITH CONFIGURATION
  void _initializeLogger() {
    _logger = Logger(
      printer: EnvironmentConfig.enableDetailedLogging 
          ? PrettyPrinter(
              methodCount: 2,
              errorMethodCount: 8,
              lineLength: 120,
              colors: true,
              printEmojis: true,
              printTime: true,
            )
          : SimplePrinter(),
      output: kDebugMode ? ConsoleOutput() : null,
      level: EnvironmentConfig.enableDetailedLogging ? Level.debug : Level.info,
    );
  }
  
  // * DEBUG LEVEL LOGGING
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (EnvironmentConfig.enableDetailedLogging) {
      _logger.d(message, error: error, stackTrace: stackTrace);
      developer.log(
        message,
        name: 'CropFresh-Debug',
        level: 500,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  
  // * INFO LEVEL LOGGING
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
    developer.log(
      message,
      name: 'CropFresh-Info',
      level: 800,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  // * WARNING LEVEL LOGGING
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    developer.log(
      message,
      name: 'CropFresh-Warning',
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  // * ERROR LEVEL LOGGING
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    developer.log(
      message,
      name: 'CropFresh-Error',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    
    // TODO: Send to crash reporting service in production
    if (EnvironmentConfig.enableCrashReporting) {
      _sendToCrashReporting(message, error, stackTrace);
    }
  }
  
  // * FATAL LEVEL LOGGING
  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    developer.log(
      message,
      name: 'CropFresh-Fatal',
      level: 1200,
      error: error,
      stackTrace: stackTrace,
    );
    
    // Always send fatal errors to crash reporting
    _sendToCrashReporting(message, error, stackTrace);
  }
  
  // * NETWORK SPECIFIC LOGGING
  void network(String message, {
    String? method,
    String? url,
    int? statusCode,
    dynamic requestData,
    dynamic responseData,
  }) {
    final networkMessage = [
      message,
      if (method != null) 'Method: $method',
      if (url != null) 'URL: $url',
      if (statusCode != null) 'Status: $statusCode',
    ].join(' | ');
    
    if (EnvironmentConfig.enableDetailedLogging) {
      debug(networkMessage);
      if (requestData != null) debug('Request: $requestData');
      if (responseData != null) debug('Response: $responseData');
    } else {
      info(networkMessage);
    }
  }
  
  // * PERFORMANCE LOGGING
  void performance(String operation, Duration duration, [Map<String, dynamic>? metadata]) {
    final message = 'Performance: $operation took ${duration.inMilliseconds}ms';
    
    if (duration.inMilliseconds > 1000) {
      warning('$message (SLOW)', metadata);
    } else {
      info(message, metadata);
    }
  }
  
  // * USER ACTION LOGGING
  void userAction(String action, [Map<String, dynamic>? context]) {
    final message = 'User Action: $action';
    info(message, context);
  }
  
  // * BUSINESS EVENT LOGGING
  void businessEvent(String event, Map<String, dynamic> data) {
    final message = 'Business Event: $event';
    info(message, data);
    
    // TODO: Send to analytics service
    _sendToAnalytics(event, data);
  }
  
  // * SECURITY EVENT LOGGING
  void security(String event, [Map<String, dynamic>? context]) {
    final message = 'Security Event: $event';
    warning(message, context);
    
    // Always log security events
    developer.log(
      message,
      name: 'CropFresh-Security',
      level: 950,
    );
  }
  
  // * SEND TO CRASH REPORTING SERVICE
  void _sendToCrashReporting(String message, dynamic error, StackTrace? stackTrace) {
    if (!EnvironmentConfig.enableCrashReporting) return;
    
    // TODO: Implement crash reporting service integration
    // Examples: Firebase Crashlytics, Sentry, Bugsnag
    developer.log(
      'Crash Report: $message',
      name: 'CropFresh-CrashReport',
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  // * SEND TO ANALYTICS SERVICE
  void _sendToAnalytics(String event, Map<String, dynamic> data) {
    if (!EnvironmentConfig.isProduction) return;
    
    // TODO: Implement analytics service integration
    // Examples: Firebase Analytics, Mixpanel, Amplitude
    developer.log(
      'Analytics: $event',
      name: 'CropFresh-Analytics',
    );
  }
  
  // * LOG API REQUEST
  void apiRequest(String method, String url, [dynamic data]) {
    if (EnvironmentConfig.enableDetailedLogging) {
      debug('API Request: $method $url', data);
    }
  }
  
  // * LOG API RESPONSE
  void apiResponse(String method, String url, int statusCode, [dynamic data]) {
    final message = 'API Response: $method $url - $statusCode';
    
    if (statusCode >= 200 && statusCode < 300) {
      if (EnvironmentConfig.enableDetailedLogging) {
        debug(message, data);
      }
    } else if (statusCode >= 400) {
      error(message, data);
    } else {
      warning(message, data);
    }
  }
  
  // * LOG FEATURE USAGE
  void featureUsage(String feature, [Map<String, dynamic>? context]) {
    info('Feature Used: $feature', context);
    
    // Track feature usage for product analytics
    if (EnvironmentConfig.isProduction) {
      _sendToAnalytics('feature_used', {
        'feature': feature,
        if (context != null) ...context,
      });
    }
  }
  
  // * LOG APP LIFECYCLE EVENTS
  void lifecycle(String event, [Map<String, dynamic>? context]) {
    info('App Lifecycle: $event', context);
  }
  
  // * LOG OFFLINE ACTIONS
  void offline(String action, [Map<String, dynamic>? data]) {
    info('Offline Action: $action', data);
  }
  
  // * LOG SYNC OPERATIONS
  void sync(String operation, {bool success = true, String? error}) {
    final message = 'Sync: $operation ${success ? 'SUCCESS' : 'FAILED'}';
    
    if (success) {
      info(message);
    } else {
      this.error(message, error);
    }
  }
  
  // * STRUCTURED LOGGING FOR COMPLEX EVENTS
  void structured(String event, Map<String, dynamic> data) {
    final structuredData = {
      'timestamp': DateTime.now().toIso8601String(),
      'event': event,
      'app_version': AppConstants.appVersion,
      'environment': EnvironmentConfig.environment,
      ...data,
    };
    
    info('Structured Log: $event', structuredData);
  }
}

// * CUSTOM CONSOLE OUTPUT FOR BETTER FORMATTING
class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      // ignore: avoid_print
      print(line);
    }
  }
}

// * LOG LEVEL EXTENSIONS
extension LogLevelExtension on Level {
  String get emoji {
    switch (this) {
      case Level.debug:
        return '🐛';
      case Level.info:
        return 'ℹ️';
      case Level.warning:
        return '⚠️';
      case Level.error:
        return '❌';
      case Level.fatal:
        return '💀';
      default:
        return '📝';
    }
  }
  
  String get label {
    switch (this) {
      case Level.debug:
        return 'DEBUG';
      case Level.info:
        return 'INFO';
      case Level.warning:
        return 'WARN';
      case Level.error:
        return 'ERROR';
      case Level.fatal:
        return 'FATAL';
      default:
        return 'LOG';
    }
  }
} 