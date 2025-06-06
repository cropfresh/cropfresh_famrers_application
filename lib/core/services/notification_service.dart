import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
// app_constants import removed - not needed for local notifications
import 'storage_service.dart';

/// Notification Service for handling local notifications only
/// Firebase removed - using Django backend for push notifications via alternative services
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  /// Initialize notification services (local only)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();
      
      // Initialize local notifications only
      await _initializeLocalNotifications();
      
      _isInitialized = true;
      debugPrint('Local notifications initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize local notifications: $e');
    }
  }

  /// Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }

    // Request permissions for iOS
    if (Platform.isIOS) {
      await _requestIOSPermissions();
    }
  }

  /// Request notification permissions for iOS
  static Future<bool> _requestIOSPermissions() async {
    final iosImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImplementation != null) {
      final bool? result = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    }
    return false;
  }

  /// Create notification channels for Android
  static Future<void> _createNotificationChannels() async {
    const channels = [
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      ),
      AndroidNotificationChannel(
        'order_channel',
        'Order Updates',
        description: 'Notifications for order status updates',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'market_channel',
        'Market Updates',
        description: 'Market price and demand updates',
        importance: Importance.defaultImportance,
      ),
      AndroidNotificationChannel(
        'weather_channel',
        'Weather Alerts',
        description: 'Weather warnings and updates',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'logistics_channel',
        'Logistics Updates',
        description: 'Transportation and delivery updates',
        importance: Importance.high,
      ),
    ];

    for (final channel in channels) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Handle notification tap events
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    
    if (response.payload != null) {
      // Parse payload and navigate accordingly
      _handleNotificationPayload(response.payload!);
    }
  }

  /// Handle notification payload for navigation
  static void _handleNotificationPayload(String payload) {
    try {
      // TODO: Implement navigation based on payload
      // This will be handled by your router service
      debugPrint('Processing notification payload: $payload');
    } catch (e) {
      debugPrint('Error processing notification payload: $e');
    }
  }

  /// Show local notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'high_importance_channel',
    String? largeIcon,
    String? bigPicture,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        _getChannelName(channelId),
        channelDescription: _getChannelDescription(channelId),
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'CropFresh',
        largeIcon: largeIcon != null ? FilePathAndroidBitmap(largeIcon) : null,
        styleInformation: bigPicture != null
            ? BigPictureStyleInformation(
                FilePathAndroidBitmap(bigPicture),
                contentTitle: title,
                summaryText: body,
              )
            : BigTextStyleInformation(body),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Schedule a local notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = 'high_importance_channel',
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        _getChannelName(channelId),
        channelDescription: _getChannelDescription(channelId),
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Cancel notification by ID
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    } else if (Platform.isIOS) {
      // For iOS, we assume notifications are enabled if initialization was successful
      // You can implement more sophisticated checking if needed
      return _isInitialized;
    }
    return false;
  }

  /// Get channel name by ID
  static String _getChannelName(String channelId) {
    switch (channelId) {
      case 'order_channel':
        return 'Order Updates';
      case 'market_channel':
        return 'Market Updates';
      case 'weather_channel':
        return 'Weather Alerts';
      case 'logistics_channel':
        return 'Logistics Updates';
      default:
        return 'High Importance Notifications';
    }
  }

  /// Get channel description by ID
  static String _getChannelDescription(String channelId) {
    switch (channelId) {
      case 'order_channel':
        return 'Notifications for order status updates';
      case 'market_channel':
        return 'Market price and demand updates';
      case 'weather_channel':
        return 'Weather warnings and updates';
      case 'logistics_channel':
        return 'Transportation and delivery updates';
      default:
        return 'This channel is used for important notifications.';
    }
  }

  // ============================================================================
  // * NOTIFICATION HELPER METHODS
  // ============================================================================

  /// Show order update notification
  static Future<void> showOrderNotification({
    required String orderId,
    required String status,
    required String message,
  }) async {
    await showNotification(
      id: orderId.hashCode,
      title: 'Order Update',
      body: message,
      payload: 'order:$orderId',
      channelId: 'order_channel',
    );
  }

  /// Show market price notification
  static Future<void> showMarketNotification({
    required String cropName,
    required double price,
    required String message,
  }) async {
    await showNotification(
      id: cropName.hashCode,
      title: 'Market Update',
      body: message,
      payload: 'market:$cropName',
      channelId: 'market_channel',
    );
  }

  /// Show weather alert notification
  static Future<void> showWeatherNotification({
    required String alertType,
    required String message,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Weather Alert',
      body: message,
      payload: 'weather:$alertType',
      channelId: 'weather_channel',
    );
  }

  /// Show logistics update notification
  static Future<void> showLogisticsNotification({
    required String bookingId,
    required String status,
    required String message,
  }) async {
    await showNotification(
      id: bookingId.hashCode,
      title: 'Logistics Update',
      body: message,
      payload: 'logistics:$bookingId',
      channelId: 'logistics_channel',
    );
  }

  // ============================================================================
  // * PERMISSION MANAGEMENT
  // ============================================================================

  /// Request notification permissions (especially useful for iOS)
  static Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      return await _requestIOSPermissions();
    } else if (Platform.isAndroid) {
      // Android permissions are usually granted during installation
      // For Android 13+ (API 33+), you might need to request POST_NOTIFICATIONS permission
      return await areNotificationsEnabled();
    }
    return true;
  }

  // ============================================================================
  // * NOTIFICATION PREFERENCES
  // ============================================================================

  /// Enable/disable specific notification types
  static Future<void> setNotificationPreference(String type, bool enabled) async {
    await StorageService.cacheData('notification_$type', enabled);
  }

  /// Get notification preference
  static Future<bool> getNotificationPreference(String type) async {
    return await StorageService.getCachedData('notification_$type') ?? true;
  }

  /// Get all notification preferences
  static Future<Map<String, bool>> getAllNotificationPreferences() async {
    return {
      'orders': await getNotificationPreference('orders'),
      'market': await getNotificationPreference('market'),
      'weather': await getNotificationPreference('weather'),
      'logistics': await getNotificationPreference('logistics'),
      'general': await getNotificationPreference('general'),
    };
  }
}
