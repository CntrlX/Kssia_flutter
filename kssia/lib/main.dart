import 'package:flutter/material.dart';
import 'package:kssia/src/interface/screens/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ), // Remove the debug banner
      home: Scaffold(
        body: Center(
          child: MainPage(),
        ),
      ),
    );
  }
}
