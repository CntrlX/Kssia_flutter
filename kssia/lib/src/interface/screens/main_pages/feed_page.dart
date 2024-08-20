import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/screens/feed/feed_view.dart';
import 'package:kssia/src/interface/screens/feed/product_view.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  void _showAddRequirementSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Post a Requirement/update',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Handle image upload
                },
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 27, color: Color(0xFF004797)),
                        SizedBox(height: 10),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                              color: Color.fromARGB(255, 102, 101, 101)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: ((MediaQuery.sizeOf(context).height) / 200).toInt(),
                decoration: InputDecoration(
                  hintText: 'Add content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    // Handle post requirement
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF004797)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF004797)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Color(0xFF004797)),
                      ),
                    ),
                  ),
                  child: const Text(
                    'POST REQUIREMENT/UPDATE',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 10,
              )
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
      child: Scaffold(backgroundColor: Colors.white,
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddRequirementSheet(context),
          label: const Text(
            'Add Requirement/update',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 27,
          ),
          backgroundColor: const Color(0xFF004797),
        ),
      ),
    );
  }
}
