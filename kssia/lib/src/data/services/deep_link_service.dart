import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/services/api_routes/events_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/main.dart';
import 'package:kssia/src/data/services/nav_router.dart';

// Create a provider for DeepLinkService
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return DeepLinkService(ref);
});

class DeepLinkService {
  final Ref _ref;
  final _appLinks = AppLinks();
  Uri? _pendingDeepLink;

  // Constructor that takes a Ref
  DeepLinkService(this._ref);

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

      // Check if app is in the foreground
      bool isAppForeground = navigatorKey.currentState?.overlay != null;

      if (!isAppForeground) {
        // App is in the background or terminated, go through splash & mainpage
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/splash',
          (route) => false,
        );

        await Future.delayed(
            Duration(seconds: 2)); // Simulating splash processing

        navigatorKey.currentState?.pushReplacementNamed('/mainpage');

        await Future.delayed(Duration(milliseconds: 500)); // Ensure stability
      }

      // Now navigate to the deep link destination
      switch (pathSegments[0]) {
        case 'chat':
          if (pathSegments.length > 1) {
            final userId = pathSegments[1];
            try {
              ApiRoutes userApi = ApiRoutes();
              final user = await userApi.fetchUserDetails(userId);
              navigatorKey.currentState
                  ?.pushNamed('/individual_page', arguments: {
                'sender': Participant(id: id),
                'receiver': Participant(
                  id: user.id,
                  name: user.name,
                  profilePicture: user.profilePicture,
                ),
              });
            } catch (e) {
              debugPrint('Error fetching user: $e');
              _showError('Unable to load profile');
            }
          }
          break;
        case 'event':
          if (pathSegments.length > 1) {
            final eventId = pathSegments[1];
            try {
              final event = await fetchEventById(eventId);
              navigatorKey.currentState
                  ?.pushNamed('/event_details', arguments: event);
            } catch (e) {
              debugPrint('Error fetching event: $e');
              _showError('Unable to load event');
            }
          }
          break;

        case 'my_requirements':
          try {
            navigatorKey.currentState?.pushNamed('/my_requirements');
          } catch (e) {
            debugPrint('Error navigating to requirements: $e');
            _showError('Unable to navigate to requirements');
          }
          break;
          
        case 'my_products':
          try {
            navigatorKey.currentState?.pushNamed('/my_products');
          } catch (e) {
            debugPrint('Error navigating to products: $e');
            _showError('Unable to navigate to products');
          }
          break;
          
        case 'my_subscription':
          try {
            navigatorKey.currentState?.pushNamed('/my_subscription');
          } catch (e) {
            debugPrint('Error navigating to subscription: $e');
            _showError('Unable to navigate to subscription');
          }
          break;
          
        case 'requirements':
          try {
                _ref.read(selectedIndexProvider.notifier).updateIndex(4);
          } catch (e) {
            debugPrint('Error updating tab: $e');
            _showError('Unable to navigate to requirements');
          }
          break;
          
        case 'products':
          try {
                _ref.read(selectedIndexProvider.notifier).updateIndex(1);
          } catch (e) {
            debugPrint('Error updating tab: $e');
            _showError('Unable to navigate to requirements');
          }
          break;

        case 'mainpage':
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/mainpage',
            (route) => false,
          );
          break;

        default:
          navigatorKey.currentState?.pushNamed('/notification');
          break;
      }
    } catch (e) {
      debugPrint('Deep link handling error: $e');
      _showError('Unable to process the notification');
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
      case 'event':
        return id != null ? 'kssia://app/event/$id' : 'kssia://app/event';
      case 'my_subscription':
        return 'kssia://app/my_subscription';
      case 'my_products':
        return 'kssia://app/my_products';
      case 'my_requirements':
        return 'kssia://app/my_requirements';
      case 'products':
        return 'kssia://app/products';
      case 'requirements':
        return 'kssia://app/requirements';
      case 'mainpage':
        return 'kssia://app/mainpage';
      default:
        return null;
    }
  }
}