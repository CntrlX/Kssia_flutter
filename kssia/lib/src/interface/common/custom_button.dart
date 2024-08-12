import 'package:flutter/material.dart';

Widget customButton({required String label, required VoidCallback onPressed}) {
  return ElevatedButton(
      onPressed: onPressed,
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
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ));
}
