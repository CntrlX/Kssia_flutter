import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _currentIndex = 0;

  List<Map<String, String>> _news = [
    {
      'title':
          'Tech Mahindra employees start hashtags on social media on Manish Vyas',
      'category': 'FINANCE',
      'image': 'https://placehold.co/600x400/png',
      'date': 'Sep 07, 2021, 01:28 PM IST',
      'content': '''Lorem ipsum dolor sit amet, consectetur adipiscing elit...
      Lorem ipsum dolor sit amet, consectetur adipiscing elit..
      Lorem ipsum dolor sit amet, consectetur adipiscing elit..
      Lorem ipsum dolor sit amet, consectetur adipiscing elit..
      Lorem ipsum dolor sit amet, consectetur adipiscing elit..
      Lorem ipsum dolor sit amet, consectetur adipiscing elit..'''
    },
    {
      'title': 'Another news article',
      'category': 'TECH',
      'image': 'https://placehold.co/600x400/png',
      'date': 'Sep 08, 2021, 02:30 PM IST',
      'content': 'This is another news article content...'
    },
    // Add more news articles here
  ];

  void _nextNews() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _news.length;
    });
  }

  void _previousNews() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _news.length) % _news.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Image.network(
                            _news[_currentIndex]['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _news[_currentIndex]['category']!,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _news[_currentIndex]['title']!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _news[_currentIndex]['date']!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(
                        _news[_currentIndex]['content']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _previousNews,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 224, 219, 219)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, color: Color(0xFF004797)),
                      SizedBox(width: 8),
                      Text('Previous',
                          style: TextStyle(color: Color(0xFF004797))),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                  onPressed: _nextNews,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 224, 219, 219)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                  ),
                  child: const Row(
                    children: [
                      Text('Next', style: TextStyle(color: Color(0xFF004797))),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Color(0xFF004797)),
                    ],
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

// void main() {
//   runApp(MaterialApp(
//     home: NewsPage(),
//   ));
// }
