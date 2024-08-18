import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/screens/main_pages/event_news_page.dart';
import 'package:kssia/src/interface/screens/main_pages/feed_page.dart';
import 'package:kssia/src/interface/screens/main_pages/home_page.dart';
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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    FeedPage(),
    ProfilePage(),
    Event_News_Page(),
    People_Page(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _inactiveIcons = [
    'assets/icons/home_inactive.svg',
    'assets/icons/feed_inactive.svg',
    'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133351928-stock-illustration-default-placeholder-man-and-woman.jpg',
    'assets/icons/news_inactive.svg',
    'assets/icons/people_inactive.svg',
  ];

  final List<String> _activeIcons = [
    'assets/icons/home_active.svg',
    'assets/icons/feed_active.svg',
    'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133351928-stock-illustration-default-placeholder-man-and-woman.jpg',
    'assets/icons/news_active.svg',
    'assets/icons/people_active.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: App_bar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar( 
        items: List.generate(5, (index) {
          return BottomNavigationBarItem(
            icon: IconResolver(
              iconPath: _inactiveIcons[index],
              color: _selectedIndex == index ? Colors.blue : Colors.grey,
            ),
            activeIcon: IconResolver(
              iconPath: _activeIcons[index],
              color: Colors.blue,
            ),
            label: ['Home', 'Feed', 'Profile', 'Events/news', 'People'][index],
          );
        }),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
