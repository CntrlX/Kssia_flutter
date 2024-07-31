import 'package:flutter/material.dart';
import 'package:kssia/src/interface/screens/feed/feed_view.dart';
import 'package:kssia/src/interface/screens/feed/product_view.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
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

  void _showAddRequirementSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Post a Requirement/update',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Handle image upload
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 40, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Upload Image',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle post requirement
                },
                child: Text('POST REQUIREMENT/UPDATE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004797), // Set to AppPalette.kPrimaryColor
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/icons/kssia_logo.png', height: 30),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Handle notifications button pressed
              },
            ),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // Handle menu button pressed
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Center(
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorColor: Color(0xFF004797),
                indicatorWeight: 2.0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: "FEED"),
                  Tab(text: "PRODUCTS"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FeedView(),
                  ProductView(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddRequirementSheet,
          label: Text('Add Requirement/update'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeedPage(),
  ));
}
