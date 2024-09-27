import 'package:flutter/material.dart';

class LoadingAnimation extends StatelessWidget {
  final double size; // Allows adjusting the size if needed
  const LoadingAnimation({
    Key? key,
    this.size = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/icons/kssiaLogo.png',
        height: size,
        width: size,
      ),
    );
  }
}
