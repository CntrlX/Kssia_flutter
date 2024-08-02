import 'package:flutter/material.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
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
      body: ListView(
        children: [
          eventCard(context),
        ],
      ),
    );
  }

  Widget eventCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://via.placeholder.com/400x200',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lorem ipsum dolor sit amet consectetur.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Eget velit sagittis sapien in vitae ut. Lorem cursus sed nunc diam ullamcorper elit.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 5),
                    Text('02 Jan 2023', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(width: 5),
                    Text('09:00 PM', style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 5),
                  Text('02 Jan 2023', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 5),
                  Text('09:00 PM', style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                  onPressed: () {
                    // Join event action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004797),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), // Adjust the value to make the edge less circular
                    ),
                    minimumSize: const Size(150, 40), // Adjust the width of the button
                  ),
                  child: const Text('JOIN', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
