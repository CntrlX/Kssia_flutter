import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/news_model.dart';
import 'package:kssia/src/data/services/api_routes/news_api.dart';

import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// Riverpod Provider for current index tracking
final currentNewsIndexProvider = StateProvider<int>((ref) => 0);

class NewsPage extends ConsumerWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNews = ref.watch(fetchNewsProvider(token));

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(currentNewsIndexProvider.notifier).state = 0;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(),
          body: asyncNews.when(
            data: (news) {
              if (news.isEmpty) {
                return const Center(
                  child: Text('No News'),
                );
              } else {
                return NewsPageView(news: news);
              }
            },
            loading: () => const Center(child: LoadingAnimation()),
            error: (error, stackTrace) =>
                const Center(child: Text('Failed to load news')),
          )),
    );
  }
}

class NewsPageView extends ConsumerStatefulWidget {
  final List<News> news;

  const NewsPageView({Key? key, required this.news}) : super(key: key);

  @override
  _NewsPageViewState createState() => _NewsPageViewState();
}

class _NewsPageViewState extends ConsumerState<NewsPageView> {
  late final PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: ref.read(currentNewsIndexProvider),
    );

    // Adding listener to update current page value for transitions
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to index changes in the provider and update PageController
    ref.listen<int>(currentNewsIndexProvider, (_, nextIndex) {
      _pageController.jumpToPage(nextIndex);
    });

    return Stack(
      children: [
        Column(
          children: [
            // PageView Section
            Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.news.length,
                    onPageChanged: (index) {
                      ref.read(currentNewsIndexProvider.notifier).state = index;
                    },
                    itemBuilder: (context, index) {
                      return ClipRect(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: (1 - (_currentPage - index).abs())
                              .clamp(0.0, 1.0),
                          child: NewsContent(
                            key: PageStorageKey<int>(
                                index), // Unique key for the page
                            newsItem: widget.news[index],
                          ),
                        ),
                      );
                    })),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: (1 - (_currentPage - _currentPage.round()).abs())
                    .clamp(0.0, 1.0), // Smooth transition for buttons too
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 224, 219, 219)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                      ),
                      onPressed: () {
                        int currentIndex = ref.read(currentNewsIndexProvider);
                        if (currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      // Button styling remains unchanged
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Color(0xFF004797)),
                          SizedBox(width: 8),
                          Text('Previous',
                              style: TextStyle(color: Color(0xFF004797))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 224, 219, 219)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                      ),
                      onPressed: () {
                        int currentIndex = ref.read(currentNewsIndexProvider);
                        if (currentIndex < widget.news.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      // Button styling remains unchanged
                      child: const Row(
                        children: [
                          Text('Next',
                              style: TextStyle(color: Color(0xFF004797))),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Color(0xFF004797)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Widget for displaying individual news content

class NewsContent extends StatelessWidget {
  final News newsItem;

  const NewsContent({
    Key? key,
    required this.newsItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMM dd, yyyy, hh:mm a').format(newsItem.updatedAt!);
    final minsToRead = calculateReadingTimeAndWordCount(newsItem.content ?? '');

    return Stack(
      children: [
        // News Content
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  newsItem.image ?? '',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 192, 252, 194),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Text(
                              newsItem.category ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (newsItem.pdf != null)
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                final pdfUrl = newsItem.pdf;
                                if (pdfUrl == null || pdfUrl.isEmpty) {
                                  // Handle the case where the URL is invalid
                                  print('PDF URL is null or empty');
                                  return;
                                }

                                try {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                              appBar: AppBar(
                                                title: const Text(
                                                  "Back",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                backgroundColor: Colors.white,
                                                scrolledUnderElevation: 0,
                                                leading: IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_back),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              body: SfPdfViewer.network(
                                                  newsItem.pdf ?? ''),
                                            )),
                                  );
                                } catch (e) {
                                  // Handle errors when loading the PDF
                                  print('Error loading PDF: $e');
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xFF004797))),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'View PDF',
                                        style:
                                            TextStyle(color: Color(0xFF004797)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.remove_red_eye_outlined,
                                          color: Color(0xFF004797))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title Section
                    Text(
                      newsItem.title ?? '',
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
                    const SizedBox(height: 16),
                    // Content Section
                    Text(
                      newsItem.content ?? '',
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

        // Premium Lock Overlay (Shown only if locked)
        // if (subscription == 'free')
        //   Positioned.fill(
        //     child: BackdropFilter(
        //       filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        //       child: Container(
        //         color:
        //             Colors.black.withOpacity(0.6), // Semi-transparent overlay
        //         child: Center(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               const Icon(
        //                 Icons.lock_outline,
        //                 size: 60,
        //                 color: Colors.white,
        //               ),
        //               const SizedBox(height: 16),
        //               const Text(
        //                 'Unlock Premium Content',
        //                 style: TextStyle(
        //                   fontSize: 24,
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               const SizedBox(height: 8),
        //               const Text(
        //                 'Buy Premium to access this page and more.',
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                   fontSize: 16,
        //                   color: Colors.white70,
        //                 ),
        //               ),
        //               const SizedBox(height: 24),
        //               SizedBox(
        //                   width: 250,
        //                   child: customButton(
        //                       label: 'Buy Premium',
        //                       onPressed: () {
        //                         showDialog(
        //                           context: context,
        //                           builder: (context) => const UpgradeDialog(),
        //                         );
        //                       }))
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
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
