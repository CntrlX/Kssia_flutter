import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(fontSize: 17),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/aboutus1.png'),
            SizedBox(height: 16),
            SizedBox(height: 8),
            Text(
              '''The Kerala State Small Industries Association was registered in 1961 under the Travancore Cochin Literary Scientific & Charitable Societies Registration Act 1955. This is the only representative Association of small-scale industries in Kerala State. The Association has district units in all the 14 revenue Districts of the State.''',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone, color: Color(0xFF004797)),
                SizedBox(width: 10),
                Text('8078955514', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Color(0xFF004797)),
                SizedBox(width: 10),
                Text('kssiatrisur@gmail.com', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Color(0xFF004797)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '''
Kerala State Small Industries Association Thrissur,
KSSIA Building, Patturaikkal, Shornur Road, Thiruvamapadi P. O, Thrissur - 680022
Tel 0487-2321562''',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Image.network('https://placehold.co/600x400/png'),
          ],
        ),
      ),
    );
  }
}
