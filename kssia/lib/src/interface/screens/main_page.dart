import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/data/services/api_routes/subscription_api.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/event_news/news.dart';
import 'package:kssia/src/interface/screens/main_pages/event_news_page.dart';
import 'package:kssia/src/interface/screens/main_pages/feed_page.dart';
import 'package:kssia/src/interface/screens/main_pages/home_page.dart';
import 'package:kssia/src/interface/screens/main_pages/loginPage.dart';
import 'package:kssia/src/interface/screens/main_pages/people_page.dart';
import 'package:kssia/src/interface/screens/main_pages/profilePage.dart';

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
      FeedPage(),
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
      user.profilePicture ?? 'assets/icons/person-svgrepo-com.svg',
      'assets/icons/active_news.svg',
      'assets/icons/people_active.svg',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(fetchStatusProvider);
      final asyncUser = ref.watch(userProvider);
      return asyncUser.when(
        loading: () {
          log('im inside details main page loading');
          return Center(child: LoadingAnimation());
        },
        error: (error, stackTrace) {
          log('im inside details main page error $error $stackTrace');
          return PhoneNumberScreen();
        },
        data: (user) {
          print(user.profilePicture);
          _initialize(user: user);
          return PopScope(
            canPop: _selectedIndex != 0 ? false : true,
            onPopInvokedWithResult: (didPop, result) {
              if (_selectedIndex != 0) {
                setState(() {
                  _selectedIndex = 0;
                });
              }
            },
            child: Scaffold(
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: List.generate(5, (index) {
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: index == 2 // Assuming profile is the third item
                        ? user.profilePicture != null &&
                                user.profilePicture != ''
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
                            iconPath: _inactiveIcons[index],
                            color: _selectedIndex == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                    activeIcon: index == 2
                        ? user.profilePicture != null &&
                                user.profilePicture != ''
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
                            color: Color(0xFF004797),
                          ),
                    label: ['Home', 'Feed', 'Profile', 'News', 'People'][index],
                  );
                }),
                currentIndex: _selectedIndex,
                selectedItemColor: Color(0xFF004797),
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                showUnselectedLabels: true,
              ),
            ),
          );
        },
      );
    });
  }
}
