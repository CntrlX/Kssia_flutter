import 'package:flutter/material.dart';

class RequestNFCPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request NFC'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect     with Ease',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 73, 122),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Lorem ipsum dolor sit amet consectetur. Justo facilisis mattis tincidunt vitae quam quis. Nec nisi duis amet aenean arcu tristique et et eleifend.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Center(
              child: Image.network(
                'https://placehold.co/600x400/png', // Replace with your image URL
                height: 200,
              ),
            ),
            SizedBox(height: 69),
            Center(
                child: ElevatedButton(
                onPressed: () {
                  // Add your request NFC card logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF003399), // Dark blue color
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Rectangle shape
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 100.0), // Increase the horizontal length here
                  child: Text(
                  'REQUEST NFC CARD',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Set the color to white
                  ),
                  ),
                ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
