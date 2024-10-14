import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/screens/feed/feed_view.dart';
import 'package:kssia/src/interface/screens/feed/product_view.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, // Number of tabs

        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(
              iselevationNeeded: false,
            ),
            body: Column(
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(20),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 0), // Adjust this value to reduce space
                    child: const SizedBox(
                      height: 40,
                      child: TabBar(
                        enableFeedback: true,
                        isScrollable:
                            false, // Disable scroll to center the tabs
                        indicatorColor: Color(
                            0xFF004797), // Set to AppPalette.kPrimaryColor
                        indicatorWeight: 3.0,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Color(0xFF004797),
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(text: "CHAT"),
                          Tab(text: "MEMBERS"),
                        ],
                      ),
                    ),
                  ),
                ),
                // Wrap TabBar with a Container to adjust margin

                Expanded(
                  child: TabBarView(
                    children: [
                      FeedView(),
                      ProductView(),
                    ],
                  ),
                ),
              ],
            )));
  }
}
