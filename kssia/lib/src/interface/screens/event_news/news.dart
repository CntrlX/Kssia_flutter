import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/services/api_routes/news_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/interface/common/loading.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncNews = ref.watch(fetchNewsProvider(token));
        return asyncNews.when(
          data: (news) {
            if (news.isNotEmpty) {
              final currentIndex = ref.watch(currentIndexProvider);

              void _nextNews() {
                ref.read(currentIndexProvider.notifier).state =
                    (currentIndex + 1) % news.length;
              }

              void _previousNews() {
                ref.read(currentIndexProvider.notifier).state =
                    (currentIndex - 1 + news.length) % news.length;
              }

              String minsToRead = calculateReadingTimeAndWordCount(
                  news[currentIndex].content ?? '');
              String formattedDate =
                  '${DateFormat('MMM dd, yyyy, hh:mm a').format(news[currentIndex].updatedAt!)} IST';
              return Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Section
                            SizedBox(
                              height: 200,
                              child: Image.network(
                                news[currentIndex].image ??
                                    'https://placehold.co/600x400/png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://placehold.co/600x400/png',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category Section
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color.fromARGB(
                                          255, 192, 252, 194),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      child: Text(
                                        news[currentIndex].category ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Title Section
                                  Text(
                                    news[currentIndex].title ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Date and Reading Time Row
                                  Row(
                                    children: [
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        minsToRead,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Content Section
                                  Text(
                                    news[currentIndex].content ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                                Icon(Icons.arrow_back,
                                    color: Color(0xFF004797)),
                                SizedBox(width: 8),
                                Text('Previous',
                                    style: TextStyle(color: Color(0xFF004797))),
                              ],
                            ),
                          ),
                          const SizedBox(
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
                                Text('Next',
                                    style: TextStyle(color: Color(0xFF004797))),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward,
                                    color: Color(0xFF004797)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('No News'),
              );
            }
          },
          loading: () => Center(child: LoadingAnimation()),
          error: (error, stackTrace) {
            return Center(
              child: Text('No News'),
            );
          },
        );
      },
    );
  }
}

String calculateReadingTimeAndWordCount(String text) {
  // Count the number of words by splitting the string on whitespace
  List<String> words = text.trim().split(RegExp(r'\s+'));
  int wordCount = words.length;

  // Average reading speed in words per minute (WPM)
  const int averageWPM = 250;

  // Calculate reading time in minutes
  double readingTimeMinutes = wordCount / averageWPM;

  // Convert the decimal to minutes and seconds
  int minutes = readingTimeMinutes.floor();
  int seconds = ((readingTimeMinutes - minutes) * 60).round();

  // Format the result as 'x min y sec' or just 'x min'
  String formattedTime;
  if (minutes > 0) {
    formattedTime = '$minutes min ${seconds > 0 ? '$seconds sec' : ''}';
  } else {
    formattedTime = '$seconds sec';
  }

  return '$formattedTime read';
}
