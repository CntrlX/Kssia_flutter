import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://placehold.co/600x400/png'),
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
                Text('9425726433', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Color(0xFF004797)),
                SizedBox(width: 10),
                Text('kssia@gmail.com', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF004797)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '''Building No. 11/673 A,
HMT Industrial Estate,
HMT Colony.P.O.,
Kalamassery,
Kerala-683 503''',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Image.network('https://placehold.co/600x400/png'),
          ],
        ),
      ),
    );
  }
}
