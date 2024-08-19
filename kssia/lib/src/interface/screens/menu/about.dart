import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
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
            Center(
              child: Image.network(
                'https://placehold.co/600x400/png', 
                height: 200,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ABOUT THE COMPANY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Lorem ipsum dolor sit amet consectetur. Lorem non tortor diam lorem viverra at nisl purus. Nec nec velit id proin vitae tempus orci donec tortor. Vehicula morbi ultrices potenti a. Fermentum nec aliquet quam velit netus. Proin eget leo non laoreet risus viverra lorem pharetra enim. Platea massa ornare id tellus nulla id ullamcorper nisl est. Sem quam est at urna feugiat. Tristique porttitor elit ultricies.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 10),
                Text('9425726433'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                Text('kssia@gmail.com'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Lorem ipsum dolor sit amet consectetur. Diam orci pretium sed volutpat elit. Vulputate in amet ac pulvinar.',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Image.network(
                'https://placehold.co/600x400/png', // Replace with your image URL
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
