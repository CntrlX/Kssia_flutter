import 'package:flutter/material.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
