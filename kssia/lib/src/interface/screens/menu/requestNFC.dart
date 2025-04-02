import 'package:flutter/material.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';

class RequestNFCPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Request NFC'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color.fromRGBO(51, 51, 51, 0.2),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect\nwith Ease',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004797),
              ),
            ),
            Flexible(
              child: Text(
                  'Tired of carrying bulky business cards or typing out contact details? Upgrade to the future with our sleek NFC card! Just a simple tap, and your contact information, website, or social media instantly appears on any smartphone.'),
            ),
            SizedBox(height: 16),
            SizedBox(height: 24),
            Center(
              child: Image.asset(
                scale: 2.5,
                'assets/NFC.png', // Replace with your image URL
              ),
            ),
            customButton(
                label: 'REQUEST NFC',
                onPressed: () async {
                  // Show the loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent dismissal by tapping outside
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Center(
                          child: LoadingAnimation(),
                        ),
                      );
                    },
                  );

                  try {
                    // Make the NFC request
                    ApiRoutes userApi = ApiRoutes();
                    await userApi.requestNFC(context);
                  } finally {
                    // Remove the loading dialog once the request is completed
                    Navigator.of(context).pop();
                  }
                },
                fontSize: 16),
         
          ],
        ),
      ),
    );
  }
}
