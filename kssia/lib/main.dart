import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/firebase_options.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/notification_model.dart';
import 'package:kssia/src/data/services/api_routes/notification_api.dart';
import 'package:kssia/src/interface/screens/event_news/viewmore_event.dart';
import 'package:kssia/src/interface/screens/main_page.dart';
import 'package:kssia/src/interface/screens/main_pages/loginPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';
import 'package:kssia/src/interface/screens/main_pages/people_page.dart';
import 'package:kssia/src/interface/screens/menu/my_product.dart';
import 'package:kssia/src/interface/screens/menu/my_subscription.dart';
import 'package:kssia/src/interface/screens/menu/myrequirementsPage.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';
import 'package:kssia/src/interface/splash_screen.dart';
import 'package:kssia/src/data/services/notification_service.dart';
import 'package:kssia/src/data/services/deep_link_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: false);
  runApp(const ProviderScope(child: MainAppLifecycleHandler()));
}

class MainAppLifecycleHandler extends ConsumerStatefulWidget {
  const MainAppLifecycleHandler({Key? key}) : super(key: key);

  @override
  _MainAppLifecycleHandlerState createState() => _MainAppLifecycleHandlerState();
}

class _MainAppLifecycleHandlerState extends ConsumerState<MainAppLifecycleHandler> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {

      ref.invalidate(fetchUnreadNotificationsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access services through their providers
    final notificationService = ref.watch(notificationServiceProvider);

    // Initialize notification service after the app is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationService.initialize();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          bodyMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
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
          titleLarge: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          titleMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          titleSmall: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          labelLarge: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          labelMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          labelSmall: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          bodySmall: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
        ),
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) {
          final deepLinkService = ref.read(deepLinkServiceProvider);
          deepLinkService.initialize(context);
          return SplashScreen();
        },
        '/login_screen': (context) => PhoneNumberScreen(),
        '/mainpage': (context) => MainPage(),
        '/splash': (context) => SplashScreen(),
        '/profile_completion': (context) => ProfileCompletionScreen(),
        '/my_requirements': (context) => MyRequirementsPage(),
        '/my_products': (context) => MyProductPage(),

        '/my_subscription': (context) => MySubscriptionPage(),
        '/chat': (context) => PeoplePage(
              initialTabIndex: 1,
            ),
        // '/membership': (context) => MembershipSubscription(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/individual_page') {
          final args = settings.arguments as Map<String, dynamic>?;
          Participant sender = args?['sender'];
          Participant receiver = args?['receiver'];

          return MaterialPageRoute(
            builder: (context) => IndividualPage(
              receiver: receiver,
              sender: sender,
            ),
          );
        } else if (settings.name == '/event_details') {
          Event event = settings.arguments as Event;

          return MaterialPageRoute(
            builder: (context) => ViewMoreEventPage(
              event: event,
            ),
          );
        } else if (settings.name == '/notification') {
          return MaterialPageRoute(
            builder: (context) => NotificationPage(),
          );
        }

        return null;
      },
    );
  }
}
