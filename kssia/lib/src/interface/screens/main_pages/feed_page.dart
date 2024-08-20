import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/screens/feed/feed_view.dart';
import 'package:kssia/src/interface/screens/feed/product_view.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: App_bar(),
        body: Column(
          children: [
            Center(
              child: TabBar(
                isScrollable: false,
                indicatorColor: const Color(0xFF004797),
                indicatorWeight: 2.0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: "FEED"),
                  Tab(text: "PRODUCTS"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FeedView(),
                  ProductView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
