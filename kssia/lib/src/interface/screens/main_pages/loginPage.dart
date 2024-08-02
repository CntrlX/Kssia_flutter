import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 

void main() {
  runApp(MaterialApp(
    home: PhoneNumberScreen(),
  ));
}

class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your Phone number'),
        backgroundColor: Color(0xFF004797),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/kssia_logo.png', width: 200),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                prefixText: '+91 ',
                hintText: '0000000000',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OTPScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF004797),
            ),
            child: Text('GENERATE OTP'),
          ),
        ],
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your OTP'),
        backgroundColor: Color(0xFF004797),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _otpController,
              decoration: InputDecoration(
                hintText: 'OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileCompletionScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF004797),
            ),
            child: Text('VERIFY OTP'),
          ),
        ],
      ),
    );
  }
}

class ProfileCompletionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
        backgroundColor: Color(0xFF004797),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/loginVector.svg', width: 150),
            SizedBox(height: 20),
            Text(
              "Let's Get Started,\nComplete your profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF004797),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF004797),
              ),
              child: Text('NEXT'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Skip', style: TextStyle(color: Color(0xFF004797))),
            )
          ],
        ),
      ),
    );
  }
}
