import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/main.dart';  // Import for navigatorKey

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();

  // Initialize and handle deep links
  Future<void> initialize(BuildContext context) async {
    try {
      // Handle deep link when app is started from terminated state
      final appLink = await _appLinks.getInitialLink();
      if (appLink != null) {
        handleDeepLink(appLink);
      }

      // Handle deep link when app is in background or foreground
      _appLinks.uriLinkStream.listen((uri) {
        handleDeepLink(uri);
      });
    } catch (e) {
      debugPrint('Deep link initialization error: $e');
    }
  }

  Future<void> handleDeepLink(Uri uri) async {
    try {
      final pathSegments = uri.pathSegments;
      
      if (pathSegments.isEmpty) return;

      switch (pathSegments[0]) {
        // case 'profile':
        //   if (pathSegments.length > 1) {
        //     final userId = pathSegments[1];
        //     try {
        //       // Fetch user data using the ID
        //       final user = await fetchUserById(userId);
        //       if (user != null) {
        //         navigatorKey.currentState?.pushNamed(
        //           '/profile',
        //           arguments: user,
        //         );
        //       }
        //     } catch (e) {
        //       debugPrint('Error fetching user: $e');
        //       _showError('Unable to load profile');
        //     }
        //   }
        //   break;
        case 'membership':
          navigatorKey.currentState?.pushNamed('/membership');
        case 'chat':
          navigatorKey.currentState?.pushNamed('/chat');
          break;
        case 'mainpage':
          navigatorKey.currentState?.pushNamed('/mainpage');
          break;
        default:
          debugPrint('Unknown deep link route: ${pathSegments[0]}');
          break;
      }
    } catch (e) {
      debugPrint('Deep link handling error: $e');
      _showError('Unable to process the link');
    }
  }

  void _showError(String message) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String? getDeepLinkPath(String screen, {String? userId}) {
    switch (screen) {
      case 'profile':
        return userId != null 
            ? 'kssia://app/profile/$userId'
            : 'kssia://app/profile';
      case 'membership':
        return 'kssia://app/membership';
      case 'mainpage':
        return 'kssia://app/mainpage';
      default:
        return null;
    }
  }
}

