import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'products_search.dart'; // Import the ProductsSearchPage

class ProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsSearchPage()),
                );
              },
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search your Products and requirements',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                enabled: false, // Disable the TextField to make it non-editable
              ),
            ),
            SizedBox(height: 100),
            Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/feed_productBag.svg',
                  height: 120,
                ),
                SizedBox(height: 16),
                Text(
                  'Search for Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'that you need',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProductView(),
  ));
}
