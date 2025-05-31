import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';
import 'package:flutter_upgrade_version/models/package_info.dart';
import 'package:kssia/main.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/appversion_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kssia/src/data/services/api_routes/get_fcm_token.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/services/launch_url.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/services/deep_link_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isAppUpdateRequired = false;
  bool isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    checkFirstLaunch().then((_) {
      handlePermissions();
    });
  }

  Future<void> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstLaunch = !(prefs.getBool('has_launched_before') ?? false);
    if (isFirstLaunch) {
      await prefs.setBool('has_launched_before', true);
    }
  }

  Future<void> handlePermissions() async {
    if (Platform.isIOS) {
      await handleIOSPermissions();
    } else {
      await handleAndroidPermissions();
    }
  }

  // ✅ iOS permission logic
  Future<void> handleIOSPermissions() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      final newSettings = await FirebaseMessaging.instance.requestPermission();
      if (newSettings.authorizationStatus == AuthorizationStatus.authorized) {
        await setupFCM();
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await showiOSPermissionDialog();
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await setupFCM();
    }

    proceedWithAppFlow();
  }

  // ✅ Android permission logic
  Future<void> handleAndroidPermissions() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      await setupFCM();
      proceedWithAppFlow();
    } else if (status.isPermanentlyDenied) {
      await showAndroidPermissionDialog();
    } else {
      final result = await Permission.notification.request();
      if (result.isGranted) {
        await setupFCM();
      }
      proceedWithAppFlow();
    }
  }

  Future<void> showiOSPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Enable Notifications'),
        content: Text('You have previously denied notification permissions. Please enable them in Settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              proceedWithAppFlow();
            },
            child: Text('Skip'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> showAndroidPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Enable Notifications'),
        content: Text('Please enable notification permissions from app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              proceedWithAppFlow();
            },
            child: Text('Skip'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> setupFCM() async {
    try {
      await getToken(context);
      print("FCM Token: $token");
    } catch (e) {
      print('Error getting FCM token: $e');
      fcmToken = '';
    }
  }

  void proceedWithAppFlow() {
    checkAppVersion(context).then((_) {
      if (!isAppUpdateRequired) {
        initialize();
      }
    });
  }

  Future<void> checkAppVersion(BuildContext context) async {
    log('Checking app version...');
    final response = await http.get(Uri.parse('$baseUrl/user/app-version'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final appVersionResponse = AppVersionResponse.fromJson(jsonResponse);
      paymentEnabled = appVersionResponse.isPaymentEnabled ?? true;
      await checkForUpdate(appVersionResponse, context);
    } else {
      log('Failed to fetch app version');
      throw Exception('Failed to load app version');
    }
  }

  Future<void> checkForUpdate(AppVersionResponse response, BuildContext context) async {
    final packageInfo = await PackageManager.getPackageInfo();
    final currentVersion = int.parse(packageInfo.version.split('.').join());

    log('Current version: $currentVersion');
    log('New version: ${response.version}');

    if (currentVersion < response.version && response.force) {
      isAppUpdateRequired = true;
      showUpdateDialog(response, context);
    }
  }

  void showUpdateDialog(AppVersionResponse response, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Update Required'),
        content: Text(response.updateMessage),
        actions: [
          TextButton(
            onPressed: () => launchURL(response.applink),
            child: Text('Update Now'),
          ),
        ],
      ),
    );
  }

  Future<void> initialize() async {
    final deepLinkService = ref.watch(deepLinkServiceProvider);
    await checkToken();

    if (!isAppUpdateRequired) {
      if (LoggedIn) {
        final pendingDeepLink = deepLinkService.pendingDeepLink;
        if (pendingDeepLink != null) {
          Navigator.pushReplacementNamed(context, '/mainpage').then((_) {
            deepLinkService.handleDeepLink(pendingDeepLink);
            deepLinkService.clearPendingDeepLink();
          });
        } else {
          Navigator.pushReplacementNamed(context, '/mainpage');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    }
  }

  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final savedId = prefs.getString('id');

    log('token:$savedToken');
    log('userId:$savedId');

    if (savedToken != null && savedToken.isNotEmpty && savedId != null) {
      setState(() {
        LoggedIn = true;
        token = savedToken;
        id = savedId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset(
          'assets/kssia_logo.svg',
          height: 140,
          width: 140,
        ),
      ),
    );
  }
}
