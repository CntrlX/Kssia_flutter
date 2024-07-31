import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildNotificationCard(
              'Please update Membership',
              'Lorem ipsum dolor sit amet consectetur. Justo facilisis mattis tincidunt vitae quam quis. Nec nisi duis amet aenean arcu tristique et et eleifend.',
              '3 hours ago',
            ),
            SizedBox(height: 16),
            _buildNotificationCard(
              'Please update checklist',
              'Lorem ipsum dolor sit amet consectetur. Justo facilisis mattis tincidunt vitae quam quis. Nec nisi duis amet aenean arcu tristique et et eleifend.',
              '3 hours ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(String title, String content, String time) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: Colors.blue, size: 12),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationPage(),
  ));
}
