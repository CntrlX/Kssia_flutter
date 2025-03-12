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
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    checkAppVersion(context).then((_) {
      if (!isAppUpdateRequired) {
        initialize();
      }
    });
    getToken();
  }

  Future<void> checkAppVersion(context) async {
    log('Checking app version...');
    final response = await http.get(Uri.parse('$baseUrl/user/app-version'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final appVersionResponse = AppVersionResponse.fromJson(jsonResponse);
      await checkForUpdate(appVersionResponse, context);
    } else {
      final jsonResponse = json.decode(response.body);
      log('Failed to fetch app version${jsonResponse['message']}');
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
    Timer(Duration(seconds: 2), () {
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
    });
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
      )
          // Image.asset(
          //   'assets/icons/demo_companylogo.png',
          //   scale: 0.5,
          // ),
          ),
    );
  }
}
