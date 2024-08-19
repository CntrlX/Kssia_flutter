import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Review distribution data
    final ratingsDistribution = [5, 3, 15, 25, 12]; // Example: 1-star to 5-star counts
    final int totalReviews = ratingsDistribution.fold(0, (previousValue, element) => previousValue + element);
    final double maxRatingCount = ratingsDistribution.reduce((value, element) => value > element ? value : element).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: () {
              // Placeholder for search functionality
            },
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView(
        children: [
            Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                '4.6',
                style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Add this line to change the font color to orange
                ),
              ),
                RatingBarIndicator(
                  rating: 4.6,
                  itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 40.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(height: 8),
                Text('24 Reviews', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ...List.generate(5, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: ratingsDistribution[4 - index] / maxRatingCount,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: index == 0 ? Colors.orange : Colors.amber[400],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('${ratingsDistribution[4 - index]}'),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Divider(),
          ...List.generate(5, (index) => ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[200],
              child: Text('JD', style: TextStyle(color: Colors.white)),
            ),
            title: Text('Jane Doe'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBarIndicator(
                  rating: 4,
                  itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
                Text('Lorem ipsum dolor sit amet consectetur.'),
              ],
            ),
            trailing: Text('6 days ago', style: TextStyle(color: Colors.grey)),
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Placeholder for 'View More' functionality
                },
                child: const Text('View More'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: MyReviewsPage()));
