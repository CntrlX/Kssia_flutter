import 'package:flutter/material.dart';

Widget customButton({required VoidCallback onPressed}) {
  return ElevatedButton(
      onPressed: (){

      },
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Color(0xFF004797)),
        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF004797)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
            side: BorderSide(color: Color(0xFF004797)),
          ),
        ),
      ),
      child: const Text(
        'NEXT',
        style: TextStyle(color: Colors.white),
      ));
}
