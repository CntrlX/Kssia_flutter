import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyRequirementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My requirements'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: () {
              // Handle WhatsApp button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRequirementCard(
              context,
              'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. Amet hac bibendum dignissim eget pretium turpis in non cum.',
              '3 messages',
              '12:30 PM · Apr 21, 2021',
            ),
            SizedBox(height: 16),
            _buildRequirementCard(
              context,
              'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. Amet hac bibendum dignissim eget pretium turpis in non cum.',
              '4 messages',
              '12:30 PM · Apr 21, 2021',
              imageUrl: 'https://placehold.co/600x400/png', // Replace with your image URL
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementCard(BuildContext context, String description, String messages, String timestamp, {String? imageUrl}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null)
              Column(
                children: [
                  Image.network(imageUrl),
                  SizedBox(height: 10),
                ],
              ),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  messages,
                  style: TextStyle(
                    color: Color(0xFF004797),
                  ),
                ),
                Text(
                  timestamp,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEB5757),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {
                _showDeleteDialog(context);
              },
              child: const Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                'https://img.freepik.com/free-photo/question-mark-bubble-speech-sign-symbol-icon-3d-rendering_56104-1950.jpg?t=st=1722584569~exp=1722588169~hmac=4fd202dfa51c41238e3a253545f7aab4bf8f87f64027a5f42e82cd22cd3395f5&w=1380',
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Delete Post?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Are you sure?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No', style: TextStyle(color: Color(0xFF0E1877))),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Color(0xFFEB5757)),
                    onPressed: () {
                      // Handle the deletion logic
                      Navigator.of(context).pop();
                    },
                    child: Text('Yes, Delete', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
