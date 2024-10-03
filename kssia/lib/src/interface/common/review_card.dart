import 'package:flutter/material.dart';
import 'package:kssia/src/data/models/user_model.dart';

class ReviewsCard extends StatelessWidget {
  final Map<int, int> ratingDistribution;
  final double averageRating;
  final int totalReviews;
  final Review review;

  const ReviewsCard({
    super.key,
    required this.ratingDistribution,
    required this.averageRating,
    required this.totalReviews,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start, // Align at the top
        children: [
          Column(
            children: [
              review.reviewer?.profilePicture != null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(review.reviewer!.profilePicture!),
                    )
                  : const Icon(Icons.person),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            // Ensures the content stays within the available width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${review.reviewer?.firstName ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color.fromARGB(255, 42, 41, 41),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  review.content ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: null, // Allows for multiple lines
                  overflow: TextOverflow.clip, // Prevents overflowing text
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
