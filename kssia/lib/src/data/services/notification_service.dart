import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kssia/src/data/services/api_routes/notification_api.dart';
import 'package:kssia/src/data/services/deep_link_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/main.dart';

// Create a provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final deepLinkService = ref.watch(deepLinkServiceProvider);
  return NotificationService._(ref, deepLinkService);
});

class NotificationService {
  final Ref ref;
  final DeepLinkService _deepLinkService;

  // Private constructor
  NotificationService._(this.ref, this._deepLinkService);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      // Initialize local notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosInitializationSetting =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const InitializationSettings initSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: iosInitializationSetting);

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      // Set up FCM handlers
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("New FCM Token: $newToken");
        // Save or send the new token to your server
      });

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      await _handleInitialMessage();
    } catch (e) {
      debugPrint('Notification initialization error: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    ref.invalidate(fetchUnreadNotificationsProvider);
    log("Notification received: ${message.data}");
    try {
      if (message.notification != null && Platform.isAndroid) {
        String? deepLink;
        if (message.data.containsKey('screen')) {
          final id = message.data['id'];
          deepLink = _deepLinkService.getDeepLinkPath(
            message.data['screen'],
            id: id,
          );
        
        }

        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: deepLink,
        );
      }
    } catch (e) {
      debugPrint('Foreground message handling error: $e');
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    try {
      String? deepLink;
      if (message.data.containsKey('screen')) {
        final id = message.data['id'];
        deepLink =
            _deepLinkService.getDeepLinkPath(message.data['screen'], id: id);
      }

      if (deepLink != null) {
        _deepLinkService.handleDeepLink(Uri.parse(deepLink));
      }
    } catch (e) {
      debugPrint('Message opened app handling error: $e');
    }
  }

  Future<void> _handleInitialMessage() async {
    try {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('Handling initial message: ${initialMessage.data}');
        // Ensure we're on the main page before handling the deep link
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/mainpage',
            (route) => false,
          );
          // Add a small delay to ensure navigation is complete
          await Future.delayed(Duration(milliseconds: 500));
          _handleMessageOpenedApp(initialMessage);
        }
      }
    } catch (e) {
      debugPrint('Initial message handling error: $e');
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
    try {
      if (response.payload != null) {
        debugPrint(
            'Handling notification tap with payload: ${response.payload}');
        // Ensure we're on the main page before handling the deep link
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/mainpage',
            (route) => false,
          );
          // Add a small delay to ensure navigation is complete
          Future.delayed(Duration(milliseconds: 500)).then((_) {
            _deepLinkService.handleDeepLink(Uri.parse(response.payload!));
          });
        }
      }
    } catch (e) {
      debugPrint('Notification tap handling error: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
}
