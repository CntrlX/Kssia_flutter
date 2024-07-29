import 'package:flutter/material.dart';
import 'package:kssia/src/interface/screens/feed/feed_view.dart';
import 'package:kssia/src/interface/screens/feed/product_view.dart';

class People_Page extends StatefulWidget {
  @override
  _People_PageState createState() => _People_PageState();
}

class _People_PageState extends State<People_Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          isScrollable: false, // Disable scroll to center the tabs
          indicatorColor: Color(0xFF004797), // Set to AppPalette.kPrimaryColor
          indicatorWeight: 2.0,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            Tab(text: "Members"),
            Tab(text: "Chat"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FeedView(),
          ProductView(),
        ],
      ),
    );
  }
}
