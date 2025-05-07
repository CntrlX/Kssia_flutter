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
  bool isPermissionCheckComplete = false;
  final DeepLinkService _deepLinkService = DeepLinkService();
  
  // Add a flag to track first launch
  bool isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    checkFirstLaunch().then((_) {
      handlePermissions();
    });
  }

  Future<void> checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstLaunch = !(prefs.getBool('has_launched_before') ?? false);
    
    // If this is the first launch, mark it for future reference
    if (isFirstLaunch) {
      await prefs.setBool('has_launched_before', true);
    }
  }

  Future<void> handlePermissions() async {
    if (isFirstLaunch) {
      // For first launch, directly request permission using the system dialog
      await setupFCM();
      setState(() {
        isPermissionCheckComplete = true;
      });
      proceedWithAppFlow();
    } else {
      // For subsequent launches, check status first
      final status = await Permission.notification.status;
      if (status.isGranted) {
        await setupFCM();
        setState(() {
          isPermissionCheckComplete = true;
        });
        proceedWithAppFlow();
      } else if (status.isPermanentlyDenied) {
        // Show custom dialog if permission was permanently denied
        if (mounted) {
          await showPermissionDialog();
        }
      } else {
        // For other cases (like first denial), try system dialog again
        await setupFCM();
        setState(() {
          isPermissionCheckComplete = true;
        });
        proceedWithAppFlow();
      }
    }
  }

  void proceedWithAppFlow() {
    checkAppVersion(context).then((_) {
      if (!isAppUpdateRequired) {
        initialize();
      }
    });
  }

  Future<void> showPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon at the top
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.blue.shade700,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Enable Notifications",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
              ),
              const SizedBox(height: 12),

              // Content
              Text(
                "Would you like to enable notifications to stay updated with important information?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        setState(() {
                          isPermissionCheckComplete = true;
                        });

                        proceedWithAppFlow();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Color(0xFF004797)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Skip",
                        style: TextStyle(color: Color(0xFF004797)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await openAppSettings();

                        final newStatus = await Permission.notification.status;
                        if (newStatus.isGranted) {
                          await setupFCM();
                        }

                        setState(() {
                          isPermissionCheckComplete = true;
                        });

                        proceedWithAppFlow();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Color(0xFF004797),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Enable"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
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
  }

  Future<void> checkAppVersion(context) async {
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

  Future<void> checkForUpdate(AppVersionResponse response, context) async {
    PackageInfo packageInfo = await PackageManager.getPackageInfo();
    final currentVersion = int.parse(packageInfo.version.split('.').join());
    log('Current version: $currentVersion');
    log('New version: ${response.version}');

    if (currentVersion < response.version && response.force) {
      // Pause initialization and show update dialog
      isAppUpdateRequired = true;
      showUpdateDialog(response, context);
    }
  }

  void showUpdateDialog(AppVersionResponse response, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force update requirement
      builder: (context) => AlertDialog(
        title: Text('Update Required'),
        content: Text(response.updateMessage),
        actions: [
          TextButton(
            onPressed: () {
              // Redirect to app store
              launchURL(response.applink);
            },
            child: Text('Update Now'),
          ),
        ],
      ),
    );
  }

  Future<void> initialize() async {
    await checktoken();
    // No timer here - navigation happens immediately when conditions are met
    if (!isAppUpdateRequired) {
      print('Logged in : $LoggedIn');
      if (LoggedIn) {
        // Check for pending deep link
        final pendingDeepLink = _deepLinkService.pendingDeepLink;
        if (pendingDeepLink != null) {
          Navigator.pushReplacementNamed(context, '/mainpage').then((_) {
            // Handle the deep link after main page is loaded
            _deepLinkService.handleDeepLink(pendingDeepLink);
            _deepLinkService.clearPendingDeepLink();
          });
        } else {
          Navigator.pushReplacementNamed(context, '/mainpage');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    }
  }

  Future<void> checktoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedtoken = preferences.getString('token');
    String? savedId = preferences.getString('id');
    log('token:$savedtoken');
    log('userId:$savedId');
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
        child: SvgPicture.asset(
          'assets/kssia_logo.svg',
          height: 140,
          width: 140,
        ),
      ),
    );
  }
}