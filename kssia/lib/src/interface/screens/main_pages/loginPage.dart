import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/kssia_logo.png', // Replace with the actual path to your Kssia logo image
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Kssia',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Add your login form here
          ],
        ),
      ),
    );
  }
}