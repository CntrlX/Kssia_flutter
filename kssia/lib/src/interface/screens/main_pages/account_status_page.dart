import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/screens/main_pages/loginPage.dart';

class AccountStatusPage extends StatelessWidget {
  const AccountStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Colors.redAccent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 48,
            ),
            SizedBox(height: 10),
            Text(
              "Your account is Suspended",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "Please contact Admin to know more",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            customButton(
                labelColor: Colors.redAccent,
                sideColor: const Color.fromARGB(255, 239, 236, 236),
                buttonColor: const Color.fromARGB(255, 239, 236, 236),
                label: 'Logout',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneNumberScreen(),
                      ));
                })
          ],
        ),
      ),
    ));
  }
}
