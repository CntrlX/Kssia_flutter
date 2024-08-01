import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '4.6',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        RatingBarIndicator(
                          rating: 4.6,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.vertical,
                        ),
                        Text('24 Reviews'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(), // to disable ListView's scrolling
              shrinkWrap: true, // Use this to fit ListView in SingleChildScrollView
              itemCount: 5, // Assuming we have 5 reviews for demo
              itemBuilder: (BuildContext context, int index) {
                return reviewCard(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextButton(
                onPressed: () {
                  // Implement view more action
                },
                child: Text(
                  'View More',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget reviewCard(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey, // Replace with network image for actual use
        child: Text('JD'), // Placeholder for initials
      ),
      title: Text('Jane Doe'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lorem ipsum dolor sit amet consectetur... Justo vitae a laculis integer pulvinar. Nunc enim sapien elit tempus quam in elit porta mattis. Interdum tincidunt id.',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          RatingBarIndicator(
            rating: 4.0,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          Text('6 days ago'),
        ],
      ),
      isThreeLine: true,
    );
  }
}
