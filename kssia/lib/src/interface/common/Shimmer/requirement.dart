import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReusableFeedPostSkeleton extends StatelessWidget {
  const ReusableFeedPostSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Skeleton
            _buildShimmerContainer(height: 200.0, width: double.infinity),
            SizedBox(height: 16),
            // Content Text Skeleton
            _buildShimmerContainer(height: 14, width: double.infinity),
            SizedBox(height: 16),
            // User Info Skeleton
            Row(
              children: [
                // User Avatar
                ClipOval(
                  child: _buildShimmerContainer(height: 30, width: 30),
                ),
                SizedBox(width: 8),
                // User Info (Name, Company)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerContainer(height: 12, width: 100),
                    SizedBox(height: 4),
                    _buildShimmerContainer(height: 12, width: 60),
                  ],
                ),
                Spacer(),
                // Post Date Skeleton
                _buildShimmerContainer(height: 12, width: 80),
              ],
            ),
            SizedBox(height: 16),
            // Action Buttons Skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildShimmerCircle(height: 30, width: 30),
                    SizedBox(width: 8),
                    _buildShimmerCircle(height: 30, width: 30),
                    SizedBox(width: 8),
                    _buildShimmerCircle(height: 30, width: 30),
                  ],
                ),
                // Likes Count Skeleton
                _buildShimmerContainer(height: 14, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(
      {required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildShimmerCircle({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
