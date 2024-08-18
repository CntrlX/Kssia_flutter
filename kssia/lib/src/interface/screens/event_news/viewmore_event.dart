import 'package:flutter/material.dart';

class ViewMoreEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder with LIVE text
            Stack(
              children: [
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 100,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFE4483E), // Red background color
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Event Title
            Text(
              'Kick off',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Date and Time
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Color(0xFF004797)),
                    SizedBox(width: 8),
                    Text(
                      'Nov 19 2023',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Color(0xFF004797)),
                    SizedBox(width: 8),
                    Text(
                      '08:00 - 08:30',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: Color.fromARGB(255, 192, 188, 188)),  // Add this line to create a divider
            // Event Description
            Text(
              'Lorem ipsum dolor sit amet consectetur. Nunc vivamus vel aliquet lacinia. '
              'Ultricies mauris vulputate amet sagittis diam sit neque enim enim.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 24),
            // Speakers Section
            Text(
              'Speakers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildSpeakerCard('assets/images/speaker1.png', 'Céline Wolf', 'Event Manager'),
            SizedBox(height: 8),
            _buildSpeakerCard('assets/images/speaker2.png', 'Céline Wolf', 'Event Manager'),
            SizedBox(height: 24),
            // Venue Section
            Text(
              'Venue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Map Placeholder
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.map,
                  color: Colors.grey,
                  size: 100,
                ),
              ),
            ),
            SizedBox(height: 24),
            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action for "Register Event"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004797), // Blue color
                  minimumSize: Size(double.infinity, 48), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'REGISTER EVENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakerCard(String imagePath, String name, String role) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          role,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
