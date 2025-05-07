import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kssia/src/data/globals.dart';

import 'package:permission_handler/permission_handler.dart';
Future<void> getToken(BuildContext context) async {
  final status = await Permission.notification.status;

  if (status.isGranted) { FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Fetch the FCM token
    String? token = await messaging.getToken();
    fcmToken = token ?? '';
    print("FCM Token: $token");
  } else {
    print('User declined or has not accepted permission');
  }
  } else if (status.isDenied || status.isPermanentlyDenied) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Notifications Disabled"),
        content: Text(
            "Notifications are disabled. You can enable them later in settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Continue app flow even if permission not granted
            },
            child: Text("Continue"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Opens settings
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
