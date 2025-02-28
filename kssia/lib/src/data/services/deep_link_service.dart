import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/main.dart'; // Make sure this import is present

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  Uri? _pendingDeepLink;

  Uri? get pendingDeepLink => _pendingDeepLink;
  void clearPendingDeepLink() {
    _pendingDeepLink = null;
  }

  // Initialize and handle deep links
  Future<void> initialize(BuildContext context) async {
    try {
      // Handle deep link when app is started from terminated state
      final appLink = await _appLinks.getInitialLink();
      if (appLink != null) {
        _pendingDeepLink = appLink;
      }

      // Handle deep link when app is in background or foreground
      _appLinks.uriLinkStream.listen((uri) {
        _pendingDeepLink = uri;
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

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/splash',
      (route) => false,
    );

    await Future.delayed(Duration(seconds: 2)); // Simulating splash screen processing

    navigatorKey.currentState?.pushReplacementNamed('/mainpage');

    await Future.delayed(Duration(milliseconds: 500)); // Ensure navigation stability

    switch (pathSegments[0]) {
      case 'chat':
        if (pathSegments.length > 1) {
          final userId = pathSegments[1];
          try {
            ApiRoutes userApi = ApiRoutes();
            final user = await userApi.fetchUserDetails(userId);
            navigatorKey.currentState?.pushNamed('/individual_page', arguments: {
              'sender': Participant(id: id),
              'receiver': Participant(
                id: user.id,
                name: user.name,
                profilePicture: user.profilePicture,
              ),
            });
          } catch (e) {
            debugPrint('Error fetching user: $e');
            _showError('Unable to load profile $e');
          }
        }
        break;
      case 'membership':
        navigatorKey.currentState?.pushNamed('/membership');
        break;
      case 'mainpage':
        // Already at mainpage, do nothing
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

  String? getDeepLinkPath(String screen, {String? id}) {
    switch (screen) {
      case 'chat':
        return id != null ? 'kssia://app/chat/$id' : 'kssia://app/chat';
      case 'membership':
        return 'kssia://app/membership';
      case 'mainpage':
        return 'kssia://app/mainpage';

      default:
        return null;
    }
  }
}
