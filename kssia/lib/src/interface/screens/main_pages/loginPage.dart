import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/screens/main_page.dart';
import 'package:kssia/src/interface/screens/main_pages/home_page.dart';

TextEditingController _mobileController = TextEditingController();
TextEditingController _otpController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: [
          PhoneNumberScreen(onNext: _nextPage),
          OTPScreen(onNext: _nextPage),
          ProfileCompletionScreen(onNext: _nextPage),
          MainPage(),
        ],
      ),
    );
  }
}

class PhoneNumberScreen extends StatelessWidget {
  final VoidCallback onNext;

  PhoneNumberScreen({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/icons/kssiaLogo.png',
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter your Phone Number',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            const SizedBox(height: 20),
            IntlPhoneField(
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                letterSpacing: 5.0,
              ),
              readOnly: true,
              controller: _mobileController,
              disableLengthCheck: true,
              showCountryFlag: false,
              decoration: const InputDecoration(
                hintText: '0000000000',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 5.0,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              initialCountryCode: 'IN',
              onChanged: (PhoneNumber phone) {
                print(phone.completeNumber);
              },
              flagsButtonPadding: EdgeInsets.zero,
              showDropdownIcon: true,
              dropdownIconPosition: IconPosition.trailing,
              dropdownTextStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'We will send you the 4 digit Verification code',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '1', model: 'mobile'),
                    _buildbutton(label: '3', model: 'mobile'),
                    _buildbutton(label: '3', model: 'mobile')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '4', model: 'mobile'),
                    _buildbutton(label: '5', model: 'mobile'),
                    _buildbutton(label: '6', model: 'mobile')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '7', model: 'mobile'),
                    _buildbutton(label: '8', model: 'mobile'),
                    _buildbutton(label: '9', model: 'mobile')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: 'ABC', model: ''),
                    _buildbutton(label: '0', model: 'mobile'),
                    _buildbutton(
                        label: 'back',
                        icondata: Icons.arrow_back_ios,
                        model: 'mobile')
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SizedBox(
                height: 47,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: onNext,
                    style: ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Color(0xFF004797)),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Color(0xFF004797)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side: BorderSide(color: Color(0xFF004797)),
                        ),
                      ),
                    ),
                    child: const Text(
                      'GENERATE OTP',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final VoidCallback onNext;
  OTPScreen({required this.onNext});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  Timer? _timer;

  int _start = 20;

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isButtonDisabled = true;
    _start = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resendCode() {
    startTimer();
    // Add your resend code logic here
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/icons/kssiaLogo.png',
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter your OTP',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            const SizedBox(height: 20),
            TextField(
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                letterSpacing: 5.0,
              ),
              readOnly: true,
              controller: _otpController,
              decoration: const InputDecoration(
                hintText: '00000',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 5.0,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                print(value);
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isButtonDisabled
                  ? null
                  : () {
                      resendCode();
                    },
              child: Text(
                _isButtonDisabled ? 'Resend Code in $_start s' : 'Resend Code',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _isButtonDisabled ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '1', model: 'otp'),
                    _buildbutton(label: '3', model: 'otp'),
                    _buildbutton(label: '3', model: 'otp')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '4', model: 'otp'),
                    _buildbutton(label: '5', model: 'otp'),
                    _buildbutton(label: '6', model: 'otp')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '7', model: 'otp'),
                    _buildbutton(label: '8', model: 'otp'),
                    _buildbutton(label: '9', model: 'otp')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: 'ABC', model: ''),
                    _buildbutton(label: '0', model: 'otp'),
                    _buildbutton(
                        label: 'back',
                        icondata: Icons.arrow_back_ios,
                        model: 'otp')
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SizedBox(
                height: 47,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: widget.onNext,
                    style: ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Color(0xFF004797)),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Color(0xFF004797)),
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
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

InkWell _buildbutton({
  required String label,
  IconData? icondata,
  required String model,
}) {
  return InkWell(
      onTap: () {
        _onbuttonTap(label, model);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          width: 100,
          child: DecoratedBox(
              decoration: BoxDecoration(),
              child: Center(
                  child: icondata != null
                      ? Icon(icondata,
                          size: 19,
                          color: const Color.fromARGB(255, 139, 138, 138))
                      : Text(
                          label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: Color.fromARGB(255, 117, 116, 116)),
                        ))),
        ),
      ));
}

_onbuttonTap(var value, String model) {
  if (model == "mobile") {
    if (value == 'back') {
      if (_mobileController.text.isNotEmpty) {
        _mobileController.text = _mobileController.text
            .substring(0, _mobileController.text.length - 1);
      }
    } else if (_mobileController.text.length < 10) {
      _mobileController.text += value;
    } else {}
  } else if (model == "otp") {
    if (value == 'back') {
      if (_otpController.text.isNotEmpty) {
        _otpController.text =
            _otpController.text.substring(0, _otpController.text.length - 1);
      }
    } else {
      if (_otpController.text.length < 5) {
        _otpController.text += value;
        if (_otpController.text.length == 5) {}
      } else {}
    }
  } else {}
}

class ProfileCompletionScreen extends StatelessWidget {
  final VoidCallback onNext;

  ProfileCompletionScreen({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace SvgPicture.asset with any image you are using
            Image.asset('assets/letsgetstarted.png', width: 150),

            const Text(
              "Let's Get Started,\nComplete your profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 118, 121, 124),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: customButton(onPressed: () {})),
            ),
            TextButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainPage()));
              },
              child: const Text('Skip',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
            )
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: const Color(0xFF004797),
      ),
      body: const Center(
        child: Text('Welcome to the Main Page!'),
      ),
    );
  }
}
