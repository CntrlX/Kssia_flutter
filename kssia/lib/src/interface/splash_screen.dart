import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/api_routes/get_fcm_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
     getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New FCM Token: $newToken");
      // Save or send the new token to your server
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in foreground: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.data}');
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('Notification clicked when app was terminated');
      }
    });
  }

  Future<void> initialize() async {
    await checktoken();
    Timer(Duration(seconds: 2), () {
      print('logged in : $LoggedIn');
      if (LoggedIn) {
        Navigator.pushReplacementNamed(context, '/mainpage');
      } else {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    });
  }

  Future<void> checktoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedtoken = preferences.getString('token');
    log(savedtoken.toString());
    String? savedId = preferences.getString('id');
    if (savedtoken != null && savedtoken.isNotEmpty && savedId != null) {
      setState(() {
        LoggedIn = true;
        token = savedtoken;
        id = savedId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icons/kssiaLogo.png',
          scale: 0.5,
        ),
      ),
    );
  }
}
