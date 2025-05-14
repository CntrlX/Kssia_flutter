import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../src/interface/screens/main_pages/loginPage.dart';
import '../../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

/// The main entry point for the KSSIA package.
/// This class provides the only public API that clients should use.
class KssiaPackage {
  /// Initializes the KSSIA package.
  /// This must be called before using any other functionality.
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Ensure assets are loaded
    await _loadAssets();
  }

  /// Internal method to ensure assets are loaded
  static Future<void> _loadAssets() async {
    try {
      // List of all assets that need to be loaded
      final assets = [
        // Main assets
        'assets/kssia_logo.svg',
        'assets/loginPeople.png',
        'assets/triangles.png',
        'assets/traingles.svg',
        'assets/question _mark.svg',
        'assets/searchproduct.png',
        'assets/premium.png',
        'assets/payment_qr.png',
        'assets/nochat.png',
        'assets/eventlocation.png',
        'assets/basic.png',
        'assets/appicon.png',
        'assets/aboutus1.png',
        'assets/Vector3.svg',
        'assets/Vector.svg',
        'assets/Vector2.svg',
        'assets/NFC.png',
        'assets/skybertechlogo.png',
        'assets/acutelogo.png',
        'assets/letsgetstarted.png',
        'assets/homegirl.png',
        'assets/upgrade.png',
        
        // Fonts
        'assets/fonts/Inter_Regular.ttf',
        'assets/fonts/Inter_Bold.ttf',
      ];

      // Try loading each asset
      for (final asset in assets) {
        try {
          // Try loading with package prefix
          await rootBundle.load('packages/kssia/$asset');
          debugPrint('Successfully loaded asset: packages/kssia/$asset');
        } catch (e) {
          try {
            // Try loading without package prefix
            await rootBundle.load(asset);
            debugPrint('Successfully loaded asset: $asset');
          } catch (e2) {
            debugPrint('Error loading asset $asset: $e2');
          }
        }
      }

      // Also try loading the icons directory
      try {
        await rootBundle.load('packages/kssia/assets/icons/');
        debugPrint('Successfully loaded icons directory');
      } catch (e) {
        try {
          await rootBundle.load('assets/icons/');
          debugPrint('Successfully loaded icons directory');
        } catch (e2) {
          debugPrint('Error loading icons directory: $e2');
        }
      }

    } catch (e) {
      debugPrint('Error in _loadAssets: $e');
      // Don't rethrow the error as it might prevent the app from starting
      // Just log it and continue
    }
  }

  /// Returns a widget that can be used to show the KSSIA login screen.
  /// This is the only screen that should be directly accessed by clients.
  static Widget start() {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          primarySwatch: Colors.blue,
          secondaryHeaderColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: PhoneNumberScreen(),
      ),
    );
  }
} 