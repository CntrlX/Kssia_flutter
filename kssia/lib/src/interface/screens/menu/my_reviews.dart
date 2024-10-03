import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/getRatings.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/common/review_card.dart';

class ReviewsState extends StateNotifier<int> {
  ReviewsState() : super(1);

  void showMoreReviews(int totalReviews) {
    state = (state + 2).clamp(0, totalReviews);
  }
}

final reviewsProvider = StateNotifierProvider<ReviewsState, int>((ref) {
  return ReviewsState();
});

class MyReviewsPage extends ConsumerStatefulWidget {
  const MyReviewsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends ConsumerState<MyReviewsPage> {
  @override
  void initState() {
    super.initState();
    // Move invalidate call to initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(userProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final reviewsToShow = ref.watch(reviewsProvider);
        final asyncUser = ref.watch(userProvider);
        if (reviewsToShow == 0) {
          return const Center(
            child: Text('No Reviews'),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'My Reviews',
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
            body: asyncUser.when(
              loading: () => Center(child: LoadingAnimation()),
              error: (error, stackTrace) {
                return Center(
                  child: LoadingAnimation(),
                );
              },
              data: (user) {
                final ratingDistribution = getRatingDistribution(user);
                final averageRating = getAverageRating(user);
                final totalReviews = user.reviews!.length;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 1.0,
                        color: Colors.grey[300], // Divider color
                      ),
                      if (totalReviews != 0)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ReviewBarChart(
                            ratingDistribution: ratingDistribution,
                            averageRating: averageRating,
                            totalReviews: totalReviews,
                          ),
                        ),
                      if (user.reviews!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: reviewsToShow,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReviewsCard(
                                  review: user.reviews![index],
                                  ratingDistribution: ratingDistribution,
                                  averageRating: averageRating,
                                  totalReviews: totalReviews,
                                ),
                              );
                            },
                          ),
                        ),
                      if (reviewsToShow < user.reviews!.length)
                        TextButton(
                          onPressed: () {
                            ref
                                .read(reviewsProvider.notifier)
                                .showMoreReviews(user.reviews!.length);
                          },
                          child: Text('View More'),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class ReviewBarChart extends StatelessWidget {
  final Map<int, int> ratingDistribution;
  final double averageRating;
  final int totalReviews;

  const ReviewBarChart({
    Key? key,
    required this.ratingDistribution,
    required this.averageRating,
    required this.totalReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: Star icon, average rating, and total reviews
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  height: 60,
                  width: 80,
                  color: Color(0xFFFFFCF2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Color(0xFFF5B358)),
                      SizedBox(width: 4),
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyle(
                            color: Color(0xFFF5B358),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '$totalReviews Reviews',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 16), // Space between left and right side

        // Right side: Rating bars
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(5, (index) {
                int starCount = 5 - index;
                int reviewCount = ratingDistribution[starCount] ?? 0;
                double percentage =
                    totalReviews > 0 ? reviewCount / totalReviews : 0;

                return Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 4.5,
                        borderRadius: BorderRadius.circular(10),
                        value: percentage,
                        backgroundColor: Colors.grey[300],
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$starCount',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
