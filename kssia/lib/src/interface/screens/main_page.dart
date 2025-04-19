import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/data/services/api_routes/subscription_api.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/event_news/news.dart';
import 'package:kssia/src/interface/screens/feed/product_view.dart';
import 'package:kssia/src/interface/screens/main_pages/event_news_page.dart';
import 'package:kssia/src/interface/screens/main_pages/feed_page.dart';
import 'package:kssia/src/interface/screens/main_pages/home_page.dart';
import 'package:kssia/src/interface/screens/main_pages/loginPage.dart';
import 'package:kssia/src/interface/screens/main_pages/people_page.dart';
import 'package:kssia/src/interface/screens/main_pages/profilePage.dart';
import 'package:kssia/src/interface/screens/menu/my_subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IconResolver extends StatelessWidget {
  final String iconPath;
  final Color color;
  final double height;
  final double width;

  const IconResolver({
    Key? key,
    required this.iconPath,
    required this.color,
    this.height = 24,
    this.width = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (iconPath.startsWith('http') || iconPath.startsWith('https')) {
      return Image.network(
        iconPath,
        color: color,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    } else {
      return SvgPicture.asset(
        iconPath,
        color: color,
        height: height,
        width: width,
      );
    }
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late final webSocketClient;

  Future<void> _handleLogout(BuildContext context) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('token');
    await preferences.remove('id');
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneNumberScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    webSocketClient = ref.read(socketIoClientProvider);
    webSocketClient.connect(id, ref);
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      ref.read(currentNewsIndexProvider.notifier).state = 0;
      _selectedIndex = index;
    });
  }

  List<String> _inactiveIcons = [];
  List<String> _activeIcons = [];
  void _initialize({required UserModel user}) {
    _widgetOptions = <Widget>[
      HomePage(
        user: user,
      ),
      ProductView(),
      ProfilePage(user: user),
      NewsPage(),
      PeoplePage(),
    ];
    _inactiveIcons = [
      'assets/icons/home_inactive.svg',
      'assets/icons/feed_inactive.svg',
      user.profilePicture ?? 'assets/icons/person-svgrepo-com.svg',
      'assets/icons/inactive_news.svg',
      'assets/icons/people_inactive.svg',
    ];
    _activeIcons = [
      'assets/icons/home_active.svg',
      'assets/icons/feed_active.svg',
      user.profilePicture ?? 'assets/icons/dummy_person_small.svg',
      'assets/icons/active_news.svg',
      'assets/icons/people_active.svg',
    ];
  }

  Widget _buildStatusPage(String status, UserModel user) {
    switch (status.toLowerCase()) {
      case 'active':
        return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: List.generate(5, (index) {
              return BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: index == 2
                    ? user.profilePicture != null && user.profilePicture != ''
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.profilePicture ?? '',
                            ),
                            radius: 15,
                          )
                        : Image.asset(
                            'assets/icons/dummy_person_small.png',
                            scale: 1,
                          )
                    : IconResolver(
                        iconPath: _inactiveIcons[index],
                        color: _selectedIndex == index
                            ? Color(0xFF004797)
                            : Colors.grey,
                      ),
                activeIcon: index == 2
                    ? user.profilePicture != null && user.profilePicture != ''
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.profilePicture ?? '',
                            ),
                            radius: 15,
                          )
                        : Image.asset(
                            'assets/icons/dummy_person_small.png',
                            scale: 1.5,
                          )
                    : IconResolver(
                        iconPath: _activeIcons[index],
                        color: Color(0xFF004797)),
                label: [
                  'Home',
                  'Business',
                  'Profile',
                  'News',
                  'Members'
                ][index],
              );
            }),
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFF004797),
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              HapticFeedback.selectionClick();
              _onItemTapped(index);
            },
            showUnselectedLabels: true,
          ),
        );

      case 'inactive':
        return Scaffold(
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.orange,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 48,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your account is currently Inactive",
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please complete your profile setup",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  customButton(
                    label: "Upload payment",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MySubscriptionPage()),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      final SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.remove('token');
                      preferences.remove('id');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneNumberScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.orange[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'suspended':
        return Scaffold(
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.red,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.block,
                    color: Colors.red,
                    size: 48,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your account is Suspended",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please contact Admin for more information",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      final SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.remove('token');
                      preferences.remove('id');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneNumberScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'blocked':
        return Scaffold(
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.red,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.gpp_bad,
                    color: Colors.red,
                    size: 48,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your account has been Blocked",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please contact Admin for assistance",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      final SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.remove('token');
                      preferences.remove('id');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneNumberScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'deleted':
        // Immediately navigate to PhoneNumberScreen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneNumberScreen(),
            ),
          );
        });
        // Return a loading screen while navigation occurs
        return Scaffold(
          body: Center(
            child: LoadingAnimation(),
          ),
        );

      default:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneNumberScreen(),
            ),
          );
        });
        // Return a loading screen while navigation occurs
        return Scaffold(
          body: Center(
            child: LoadingAnimation(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(fetchStatusProvider);
      final asyncUser = ref.watch(userProvider);
      return asyncUser.when(
        loading: () {
          log('im inside details main page loading');
          return Scaffold(
            body: buildShimmerPromotionsColumn(context: context),
          );
        },
        error: (error, stackTrace) {
          log('im inside details main page error $error $stackTrace');
          return PhoneNumberScreen();
        },
        data: (user) {
          print(user.profilePicture);
          _initialize(user: user);
          if (user.firebaseId != null && user.firebaseId != '') {
            return PopScope(
              canPop: _selectedIndex != 0 ? false : true,
              onPopInvokedWithResult: (didPop, result) {
                if (_selectedIndex != 0) {
                  setState(() {
                    _selectedIndex = 0;
                  });
                }
              },
              child: _buildStatusPage(user.status ?? 'unknown', user),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleLogout(context);
            });
            return PhoneNumberScreen();
          }
        },
      );
    });
  }
}
