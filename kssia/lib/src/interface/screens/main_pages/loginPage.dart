import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kssia/src/data/notifiers/loading_notifier.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/interface/common/Shimmer/edit_user_shimmer.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/customTextfields.dart';
import 'package:kssia/src/interface/common/custom_switch.dart';
import 'package:kssia/src/interface/common/components/svg_icon.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/common/upgrade_dialog.dart';
import 'package:kssia/src/interface/common/website_video_cards.dart';
import 'package:kssia/src/interface/screens/main_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/interface/screens/profile/user_details.dart';
import 'package:kssia/src/validate_urls.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

TextEditingController _mobileController = TextEditingController();
TextEditingController _otpController = TextEditingController();

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color.fromARGB(255, 197, 217, 234);

    final path = Path();
    // Start at the bottom left corner
    path.moveTo(0, size.height);
    // Draw to the top left corner
    path.lineTo(0, size.height * 0.6);
    // Draw to the bottom right corner
    path.lineTo(size.width, size.height);
    // Close the path back to the starting point
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

final countryCodeProvider = StateProvider<String?>((ref) => '91');

class PhoneNumberScreen extends ConsumerWidget {
  PhoneNumberScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final countryCode = ref.watch(countryCodeProvider);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TrianglePainter(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/loginPeople.png',
              scale: 1.2,
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Image.asset(
                        'assets/icons/demo_companylogo.png',
                        scale: 8,
                      ),
                    ),
                    const SizedBox(height: 80),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottomInset),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Please enter your mobile number',
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 20),
                              IntlPhoneField(
                                validator: (phone) {
                                  if (phone!.number.length > 9) {
                                    if (phone.number.length > 10) {
                                      return 'Phone number cannot exceed 10 digits';
                                    }
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  letterSpacing: 8,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                controller: _mobileController,
                                disableLengthCheck: true,
                                showCountryFlag: true,
                                decoration: InputDecoration(
                                  hintText: 'Enter your phone number',
                                  hintStyle: const TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 10.0,
                                  ),
                                ),
                                onCountryChanged: (value) {
                                  ref.read(countryCodeProvider.notifier).state =
                                      value.dialCode;
                                },
                                initialCountryCode: 'IN',
                                onChanged: (PhoneNumber phone) {
                                  print(phone.completeNumber);
                                },
                                flagsButtonPadding: const EdgeInsets.only(
                                    left: 10, right: 10.0),
                                showDropdownIcon: true,
                                dropdownIconPosition: IconPosition.trailing,
                                dropdownTextStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'A 6 digit verification code will be sent',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  height: 47,
                                  width: double.infinity,
                                  child: customButton(
                                    label: 'GENERATE OTP',
                                    onPressed: isLoading
                                        ? () {}
                                        : () {
                                            _handleOtpGeneration(context, ref);
                                          },
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: LoadingAnimation(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleOtpGeneration(BuildContext context, WidgetRef ref) async {
    final countryCode = ref.watch(countryCodeProvider);
    ref.read(loadingProvider.notifier).startLoading();

    try {
      if (countryCode == '971') {
        if (_mobileController.text.length != 9) {
          CustomSnackbar.showSnackbar(
              context, 'Please Enter valid mobile number');
        } else {
          ApiRoutes userApi = ApiRoutes();

          final data = await userApi.submitPhoneNumber(
              countryCode == '971'
                  ? 9710.toString()
                  : countryCode ?? 91.toString(),
              context,
              _mobileController.text);
          final verificationId = data['verificationId'];
          final resendToken = data['resendToken'];
          if (verificationId != null && verificationId.isNotEmpty) {
            log('Otp Sent successfully');

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => OTPScreen(
                phone: _mobileController.text,
                verificationId: verificationId,
                resendToken: resendToken ?? '',
              ),
            ));
          } else {
            CustomSnackbar.showSnackbar(context, 'Failed');
          }
        }
      } else if (countryCode != '971') {
        if (_mobileController.text.length != 10) {
          CustomSnackbar.showSnackbar(
              context, 'Please Enter valid mobile number');
        } else {
          ApiRoutes userApi = ApiRoutes();

          final data = await userApi.submitPhoneNumber(
              countryCode == '971'
                  ? 9710.toString()
                  : countryCode ?? 971.toString(),
              context,
              _mobileController.text);
          final verificationId = data['verificationId'];
          final resendToken = data['resendToken'];
          if (verificationId != null && verificationId.isNotEmpty) {
            log('Otp Sent successfully');

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => OTPScreen(
                phone: _mobileController.text,
                verificationId: verificationId,
                resendToken: resendToken ?? '',
              ),
            ));
          } else {
            CustomSnackbar.showSnackbar(context, 'Failed');
          }
        }
      }
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Failed');
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}

class OTPScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String resendToken;
  final String phone;
  const OTPScreen({
    required this.phone,
    required this.resendToken,
    super.key,
    required this.verificationId,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  Timer? _timer;

  int _start = 59;

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isButtonDisabled = true;
    _start = 59;
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
    ApiRoutes userApi = ApiRoutes();
    userApi.resendOTP(widget.phone, widget.verificationId, widget.resendToken);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TrianglePainter(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/loginPeople.png',
              scale: 1.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/icons/demo_companylogo.png',
                    scale: 8,
                  ),
                ),
                const SizedBox(height: 80),
                const Text(
                  'Enter your OTP',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6, // Number of OTP digits
                    obscureText: false,
                    keyboardType: TextInputType.number, // Number-only keyboard
                    animationType: AnimationType.fade,
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 5.0,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 55,
                      fieldWidth: 50, selectedColor: Colors.blue,
                      activeColor: const Color.fromARGB(255, 232, 226, 226),
                      inactiveColor: const Color.fromARGB(
                          255, 232, 226, 226), // Box color when not focused
                      activeFillColor: Colors.white, // Box color when focused
                      selectedFillColor:
                          Colors.white, // Box color when selected
                      inactiveFillColor:
                          Colors.white, // Box fill color when not selected
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _otpController,
                    onChanged: (value) {
                      // Handle input change
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        _isButtonDisabled
                            ? 'Resend OTP in $_start seconds'
                            : 'Enter your OTP',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _isButtonDisabled ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isButtonDisabled ? null : resendCode,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          _isButtonDisabled ? '' : 'Resend Code',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _isButtonDisabled ? Colors.grey : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: SizedBox(
                    height: 47,
                    width: double.infinity,
                    child: customButton(
                      label: 'CONTINUE',
                      onPressed: isLoading
                          ? () {}
                          : () {
                              _handleOtpVerification(context, ref);
                            },
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: LoadingAnimation(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleOtpVerification(
      BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).startLoading();

    try {
      print(_otpController.text);

      ApiRoutes userApi = ApiRoutes();
      Map<String, dynamic> responseMap = await userApi.verifyOTP(
          verificationId: widget.verificationId,
          fcmToken: fcmToken,
          smsCode: _otpController.text,
          context: context);

      String savedToken = responseMap['token'];
      String savedId = responseMap['userId'];

      if (savedToken.isNotEmpty && savedId.isNotEmpty) {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        await preferences.setString('token', savedToken);
        await preferences.setString('id', savedId);
        token = savedToken;
        id = savedId;
        log('savedToken: $savedToken');
        log('savedId: $savedId');
        ref.invalidate(userProvider);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfileCompletionScreen()));
      } else {
        // CustomSnackbar.showSnackbar(context, 'Wrong OTP');
      }
    } catch (e) {
      // CustomSnackbar.showSnackbar(context, 'Wrong OTP');
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}

InkWell _buildbutton(
    {required String label,
    IconData? icondata,
    required String model,
    String? countryCode}) {
  return InkWell(
      onTap: () {
        _onbuttonTap(label, model, countryCode ?? '971');
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          width: 80, // Adjusted width to fit better
          child: DecoratedBox(
            decoration: const BoxDecoration(),
            child: Center(
              child: icondata != null
                  ? Icon(icondata,
                      size: 19, color: const Color.fromARGB(255, 139, 138, 138))
                  : Text(
                      label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                          color: Color.fromARGB(255, 117, 116, 116)),
                    ),
            ),
          ),
        ),
      ));
}

_onbuttonTap(var value, String model, String countryCode) {
  if (model == "mobile") {
    if (value == 'back') {
      if (_mobileController.text.isNotEmpty) {
        _mobileController.text = _mobileController.text
            .substring(0, _mobileController.text.length - 1);
      }
    } else if (countryCode == '971' && _mobileController.text.length < 9) {
      log('Country code:$countryCode');
      _mobileController.text += value;
    } else if (countryCode != '971' && _mobileController.text.length < 10) {
      log('Country code:$countryCode');
      _mobileController.text += value;
    } else {}
  } else if (model == "otp") {
    if (value == 'back') {
      if (_otpController.text.isNotEmpty) {
        _otpController.text =
            _otpController.text.substring(0, _otpController.text.length - 1);
      }
    } else {
      if (_otpController.text.length < 6) {
        _otpController.text += value;
        if (_otpController.text.length == 5) {}
      } else {}
    }
  } else {}
}

class ProfileCompletionScreen extends StatelessWidget {
  ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  child: Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                          label: 'Next',
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    settings: RouteSettings(
                                        name: 'ProfileCompletion'),
                                    builder: (context) => const DetailsPage()));
                            ref.invalidate(userProvider);
                          },
                          fontSize: 16);
                    },
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const MainPage()));
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
