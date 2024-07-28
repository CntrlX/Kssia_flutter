import 'package:flutter/material.dart';

class FeedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search your Products and requirements',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 16),
          PostWidget(
            authorName: 'John Kappa',
            companyName: 'Company name',
            timestamp: '12:30 PM · Apr 21, 2021',
            content: 'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. Amet hac bibendum dignissim eget pretium turpis in non cum.',
            imagePath: 'assets/icons/lightBulb_feed.png', // Replace with the path to your image
          ),
          SizedBox(height: 16),
          PostWidget(
            authorName: 'John Kappa',
            companyName: 'Company name',
            timestamp: '12:30 PM · Apr 21, 2021',
            content: 'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. Amet hac bibendum dignissim eget pretium turpis in non cum.',
            imagePath: 'assets/icons/lightBulb_feed.png', // Replace with the path to your image
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String authorName;
  final String companyName;
  final String timestamp;
  final String content;
  final String imagePath;

  PostWidget({
    required this.authorName,
    required this.companyName,
    required this.timestamp,
    required this.content,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Image.asset(imagePath),
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'), // Replace with your avatar image path
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(companyName),
                ],
              ),
              Spacer(),
              Text(timestamp),
            ],
          ),
        ],
      ),
    );
  }
}
