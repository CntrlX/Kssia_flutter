import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/firebase_options.dart';
import 'package:kssia/src/interface/screens/main_page.dart';
import 'package:kssia/src/interface/screens/main_pages/loginPage.dart';
import 'package:kssia/src/interface/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeNotifications();
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            bodyMedium:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            displayLarge:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            displayMedium:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            displaySmall:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            headlineMedium:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            headlineSmall:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            titleLarge:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            titleMedium:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            titleSmall:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            labelLarge:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            labelMedium:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            labelSmall:
                TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
            bodySmall: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          ),
          primarySwatch: Colors.blue,
          secondaryHeaderColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login_screen': (context) => LoginPage(),
          '/mainpage': (context) => MainPage(),
        });
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Initialize in your main function
void initializeNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
