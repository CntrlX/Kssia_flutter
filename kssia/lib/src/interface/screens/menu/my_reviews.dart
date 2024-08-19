import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Review distribution data
    final ratingsDistribution = [5, 4, 3, 2, 1]; // Example: 1-star to 5-star counts
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
              // Placeholder for WhatsApp functionality
            },
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 1.0,
            color: Colors.grey[300], // Divider color
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFCF2), // Subtle yellow background for the rating box
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: Color(0xFFF5B358), size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '4.6',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFF5B358), // Main rating number color
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '24 Reviews',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Text('${5 - index}', style: TextStyle(color: Colors.black)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: ratingsDistribution[index] / maxRatingCount,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5B358), // Rating bar color
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                // const Divider(height: 32),
                ...List.generate(5, (index) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey[200],
                    child: Text('JD', style: TextStyle(color: Colors.white)),
                  ),
                  title: const Text('Jane Doe'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        rating: 4,
                        itemBuilder: (context, index) => Icon(Icons.star, color: Color(0xFFF5B358)),
                        itemCount: 5,
                        itemSize: 16.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(height: 4),
                      const Text('Lorem ipsum dolor sit amet consectetur.'),
                    ],
                  ),
                  trailing: const Text('6 days ago', style: TextStyle(color: Colors.grey)),
                )),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Placeholder for 'View More' functionality
                    },
                    child: const Text('View More'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: MyReviewsPage()));
