import 'package:flutter/material.dart';

class Event_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search for Events ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildPost(),
        _buildPost(withImage: true),
        _buildPost(withImage: true),
      ],
    );
  }

  Widget _buildPost({bool withImage = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (withImage) ...[
              SizedBox(height: 16),
              Image(
                  image: NetworkImage(
                      'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133351928-stock-illustration-default-placeholder-man-and-woman.jpg')) // Replace with your image path
            ],
            Text(
              'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. '
              'Amet hac bibendum dignissim eget pretium turpis in non cum.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/icons/johnkappa_feed.png'), // Replace with your logo image path
                  radius: 16,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Kappa',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      'Company name',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  '12:30 PM - Apr 21, 2021',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
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
          Image(image: NetworkImage(imagePath)),
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/avatar.png'), // Replace with your avatar image path
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
