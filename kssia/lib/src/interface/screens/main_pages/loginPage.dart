import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kssia/src/data/api_routes/api_routes.dart';
import 'package:kssia/src/interface/common/custom_switch.dart';
import 'package:kssia/src/interface/common/components/svg_icon.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/screens/main_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:permission_handler/permission_handler.dart';

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
          // PhoneNumberScreen(onNext: _nextPage),
          // OTPScreen(onNext: _nextPage),
          ProfileCompletionScreen(onNext: _nextPage),
          const DetailsPage(),
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
              style: const TextStyle(
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
                      foregroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF004797)),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF004797)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side: const BorderSide(color: Color(0xFF004797)),
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
              style: const TextStyle(
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
                      foregroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF004797)),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF004797)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side: const BorderSide(color: Color(0xFF004797)),
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
              decoration: const BoxDecoration(),
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
                  child: customButton(label: 'Next', onPressed: onNext)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainPage()));
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

class DetailsPage extends ConsumerStatefulWidget {
  const DetailsPage({super.key});

  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  final isPhoneNumberVisibleProvider = StateProvider<bool>((ref) => false);
  final isContactDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isSocialDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isWebsiteDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isVideoDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isAwardsDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isProductsDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isCertificateDetailsVisibleProvider =
      StateProvider<bool>((ref) => false);
  final isBrochureDetailsVisibleProvider = StateProvider<bool>((ref) => false);

  final TextEditingController nameController = TextEditingController();

  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profilePictureController =
      TextEditingController();
  final TextEditingController personalPhoneController = TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController whatsappBusinessController =
      TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _invalidAddress = false;

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    nameController.dispose();
    bloodGroupController.dispose();
    emailController.dispose();
    profilePictureController.dispose();
    personalPhoneController.dispose();
    landlineController.dispose();
    companyPhoneController.dispose();
    whatsappController.dispose();
    whatsappBusinessController.dispose();
    designationController.dispose();
    companyNameController.dispose();
    companyEmailController.dispose();
    bioController.dispose();
    addressController.dispose();

    super.dispose();
  }

  void _submitData() {
    String fullName = nameController.text;

    List<String> nameParts = fullName.split(' ');

    String firstName = nameParts[0];
    String middleName = nameParts.length > 2 ? nameParts[1] : ' ';
    String lastName = nameParts.length > 1 ? nameParts.last : ' ';
    String address =
        addressController.text.trim().replaceAll(RegExp(r'\s*\.\s*$'), '');
    final RegExp regex = RegExp(
      r'^\s*(?<street>[^,.\s]+(?:\s+[^,.\s]+)*),\s*(?<city>[^,.\s]+(?:\s+[^,.\s]+)*),\s*(?<state>[^,.\s]+(?:\s+[^,.\s]+)*),\s*(?<zip>\d{5,6})\s*$',
    );

    final match = regex.firstMatch(address);
    String? street;
    String? city;
    String? state;
    String? zip;
    if (match != null) {
      street = match.namedGroup('street')?.trim();
      city = match.namedGroup('city')?.trim();
      state = match.namedGroup('state')?.trim();
      zip = match.namedGroup('zip')?.trim();

      print('Street: $street');
      print('City: $city');
      print('State: $state');
      print('Zip: $zip');
    } else {
      print('Address format is invalid.');
      _invalidAddress = true;
    }

    final Map<String, dynamic> profileData = {
      "name": {
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
      },
      "blood_group": bloodGroupController.text,
      "email": emailController.text,
      "profile_picture": profilePictureController.text,
      "phone_numbers": {
        "personal": int.tryParse(personalPhoneController.text) ?? 0,
        "landline": int.tryParse(landlineController.text) ?? 0,
        "company_phone_number": int.tryParse(companyPhoneController.text) ?? 0,
        "whatsapp_number": int.tryParse(whatsappController.text) ?? 0,
        "whatsapp_business_number":
            int.tryParse(whatsappBusinessController.text) ?? 0,
      },
      "designation": designationController.text,
      "company_name": companyNameController.text,
      "company_email": companyEmailController.text,
      "bio": bioController.text,
      "address": {
        "street": street,
        "city": city,
        "state": state,
        "zip": zip,
      },
    };

    // ApiRoutes apiRoutes = ApiRoutes();
    // apiRoutes.editUser(profileData);
    print(profileData);
  }

  Future<void> _selectImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    print('$image');
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else if (source == ImageSource.gallery) {
      status = await Permission.photos.request();
    } else {
      return;
    }

    if (status.isGranted) {
      _selectImage(source);
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog(true);
    } else {
      _showPermissionDeniedDialog(false);
    }
  }

  void _showPermissionDeniedDialog(bool isPermanentlyDenied) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: Text(isPermanentlyDenied
              ? 'Permission is permanently denied. Please enable it from the app settings.'
              : 'Permission is denied. Please grant the permission to proceed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isPermanentlyDenied) {
                  openAppSettings();
                }
              },
              child: Text(isPermanentlyDenied ? 'Open Settings' : 'OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneNumberVisible = ref.watch(isPhoneNumberVisibleProvider);
    final isContactDetailsVisible = ref.watch(isContactDetailsVisibleProvider);
    final isSocialDetailsVisible = ref.watch(isSocialDetailsVisibleProvider);
    final isWebsiteDetailsVisible = ref.watch(isWebsiteDetailsVisibleProvider);
    final isVideoDetailsVisible = ref.watch(isVideoDetailsVisibleProvider);
    final isAwardsDetailsVisible = ref.watch(isAwardsDetailsVisibleProvider);
    final isProductsDetailsVisible =
        ref.watch(isProductsDetailsVisibleProvider);
    final isCertificateDetailsVisible =
        ref.watch(isCertificateDetailsVisibleProvider);
    final isBrochureDetailsVisible =
        ref.watch(isBrochureDetailsVisibleProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      leadingWidth: 100,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/icons/kssiaLogo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MainPage()));
                          },
                          child: const Text(
                            'Skip',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Stack(
                      children: [
                        DottedBorder(
                          borderType: BorderType.Circle,
                          dashPattern: [6, 3],
                          color: Colors.grey,
                          strokeWidth: 2,
                          child: ClipOval(
                            child: Container(
                              width: 120,
                              height: 120,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: _imageFile == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    )
                                  : Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    _buildImagePickerOptions(context),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xFF004797),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 60, left: 16, bottom: 10),
                        child: Text(
                          'Personal Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Column(
                      children: [
                        CustomTextField(
                          textController: nameController,
                          labelText: 'Enter your Full name',
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextField(
                            textController: designationController,
                            labelText: 'Designation'),
                        const SizedBox(height: 20.0),
                        CustomTextField(
                            textController: bioController,
                            labelText: 'Bio',
                            maxLines: 5),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Add more',
                          style: TextStyle(
                              color: Color(0xFF004797),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        Icon(
                          Icons.add,
                          color: Color(0xFF004797),
                          size: 18,
                        )
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 60, left: 16, bottom: 10),
                        child: Text(
                          'Company Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Stack(
                      children: [
                        DottedBorder(
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          dashPattern: [6, 3],
                          color: Colors.grey,
                          strokeWidth: 2,
                          child: ClipRRect(
                            child: Container(
                                width: 110,
                                height: 100,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: const Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Upload',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Company',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Logo',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: InkWell(
                            onTap: () {
                              // Add functionality to select image from files or gallery
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(-1, -1),
                                    blurRadius: 4,
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xFF004797),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: CustomTextField(
                        labelText: 'Enter Company Name',
                        textController: companyNameController),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomTextField(
                      labelText: 'Enter Company Address',
                      textController: addressController,
                      maxLines: 3,
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: Color(0xFF004797),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isPhoneNumberVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(isPhoneNumberVisibleProvider.notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isPhoneNumberVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 10),
                      child: CustomTextField(
                        textController: personalPhoneController,
                        labelText: 'Enter phone number',
                        prefixIcon:
                            const Icon(Icons.phone, color: Color(0xFF004797)),
                      ),
                    ),
                  if (isPhoneNumberVisible)
                    const Padding(
                      padding: EdgeInsets.only(right: 20, bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Add more',
                            style: TextStyle(
                                color: Color(0xFF004797),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          Icon(
                            Icons.add,
                            color: Color(0xFF004797),
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Contact Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isContactDetailsVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(
                                      isContactDetailsVisibleProvider.notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isContactDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 10),
                      child: CustomTextField(
                        textController: emailController,
                        labelText: 'Enter Email',
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xFF004797)),
                      ),
                    ),
                  if (isContactDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: CustomTextField(
                        textController: whatsappBusinessController,
                        labelText: 'Enter Business Whatsapp',
                        prefixIcon: const SvgIcon(
                          assetName: 'assets/icons/whatsapp-business.svg',
                          color: Color(0xFF004797),
                          size: 10,
                        ),
                      ),
                    ),
                  if (isContactDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: CustomTextField(
                        textController: whatsappController,
                        labelText: 'Enter Whatsapp',
                        prefixIcon: const SvgIcon(
                          assetName: 'assets/icons/whatsapp.svg',
                          color: Color(0xFF004797),
                          size: 13,
                        ),
                      ),
                    ),
                  if (isContactDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: CustomTextField(
                        textController: addressController,
                        labelText: 'Enter Address',
                        maxLines: 3,
                        prefixIcon: const Icon(Icons.location_on,
                            color: Color(0xFF004797)),
                      ),
                    ),
                  if (isContactDetailsVisible)
                    const Padding(
                      padding: EdgeInsets.only(right: 20, bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Add more',
                            style: TextStyle(
                                color: Color(0xFF004797),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          Icon(
                            Icons.add,
                            color: Color(0xFF004797),
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Social Media',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isSocialDetailsVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(isSocialDetailsVisibleProvider.notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isSocialDetailsVisible)
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: CustomTextField(
                        labelText: 'Enter Ig',
                        prefixIcon: SvgIcon(
                          assetName: 'assets/icons/instagram.svg',
                          size: 10,
                          color: Color(0xFF004797),
                        ),
                      ),
                    ),
                  if (isSocialDetailsVisible)
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: CustomTextField(
                        labelText: 'Enter Linkedin',
                        prefixIcon: SvgIcon(
                          assetName: 'assets/icons/linkedin.svg',
                          color: Color(0xFF004797),
                          size: 10,
                        ),
                      ),
                    ),
                  if (isSocialDetailsVisible)
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: CustomTextField(
                        labelText: 'Enter Twitter',
                        prefixIcon: SvgIcon(
                          assetName: 'assets/icons/twitter.svg',
                          color: Color(0xFF004797),
                          size: 13,
                        ),
                      ),
                    ),
                  if (isSocialDetailsVisible)
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: CustomTextField(
                        labelText: 'Enter Facebook',
                        prefixIcon: Icon(
                          Icons.facebook,
                          color: Color(0xFF004797),
                          size: 28,
                        ),
                      ),
                    ),
                  if (isSocialDetailsVisible)
                    const Padding(
                      padding: EdgeInsets.only(right: 20, bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Add more',
                            style: TextStyle(
                                color: Color(0xFF004797),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          Icon(
                            Icons.add,
                            color: Color(0xFF004797),
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Website',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isWebsiteDetailsVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(
                                      isWebsiteDetailsVisibleProvider.notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isWebsiteDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: CustomTextField(
                        readOnly: true,
                        labelText: 'Enter Website Link',
                        suffixIcon: const Icon(
                          Icons.add,
                          color: Color(0xFF004797),
                        ),
                        onTap: () {
                          _showWlinkorVlinkSheet(
                              fieldName: 'Add Website Link',
                              title: 'Add Website',
                              context: context);
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Video Link',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isVideoDetailsVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(isVideoDetailsVisibleProvider.notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isVideoDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
                      child: CustomTextField(
                        onTap: () {
                          _showWlinkorVlinkSheet(
                              fieldName: 'Add Youtube Link',
                              title: 'Add Video Link',
                              context: context);
                        },
                        labelText: 'Enter Video Link',
                        suffixIcon: const Icon(
                          Icons.add,
                          color: Color(0xFF004797),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enter Awards',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isAwardsDetailsVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(isAwardsDetailsVisibleProvider.notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isAwardsDetailsVisible)
                    GestureDetector(
                      onTap: _showEnterAwardtSheet,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 60),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color(0xFF004797),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Enter Awards',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 17),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enter Products',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isProductsDetailsVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(
                                      isProductsDetailsVisibleProvider.notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isProductsDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, bottom: 60),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Color(0xFF004797),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Enter Products',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enter Certificates',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isCertificateDetailsVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(isCertificateDetailsVisibleProvider
                                      .notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isCertificateDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, bottom: 60),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Color(0xFF004797),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Enter Certificates',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enter Awards',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CustomSwitch(
                          value: ref.watch(isBrochureDetailsVisibleProvider),
                          onChanged: (bool value) {
                            setState(() {
                              ref
                                  .read(
                                      isBrochureDetailsVisibleProvider.notifier)
                                  .state = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isBrochureDetailsVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, bottom: 60),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Color(0xFF004797),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Enter Brochure',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: SizedBox(
                    height: 50,
                    child: customButton(
                        label: 'Save & Proceed',
                        onPressed: () {
                          _submitData();
                        }))),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOptions(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Choose from Gallery'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.gallery);
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take a Photo'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.camera);
          },
        ),
      ],
    );
  }

  void _showEnterAwardtSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Awards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Handle image upload
                },
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 27, color: Color(0xFF004797)),
                        SizedBox(height: 10),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                              color: Color.fromARGB(255, 102, 101, 101)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Add content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey, // Set the border color to light grey
                      width: 1.0, // You can adjust the width as needed
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 185, 181, 181),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 185, 181, 181),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    // Handle post requirement
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFF004797)),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFF004797)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Color(0xFF004797)),
                      ),
                    ),
                  ),
                  child: const Text(
                    'POST REQUIREMENT/UPDATE',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool readOnly;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? textController;
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.onTap,
    this.suffixIcon,
    this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: textController,
      maxLines: maxLines,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        fillColor: const Color(0xFFF2F2F2),
        filled: true,
        prefixIcon: prefixIcon != null && maxLines > 1
            ? Padding(
                padding: const EdgeInsets.only(
                    bottom: 50, left: 10, right: 10, top: 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  widthFactor: 1.0,
                  heightFactor: maxLines > 1 ? null : 1.0,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      width: 42,
                      height: 42,
                      child: prefixIcon),
                ),
              )
            : prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Align(
                      alignment: Alignment.topCenter,
                      widthFactor: 1.0,
                      heightFactor: maxLines > 1 ? null : 1.0,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          width: 42,
                          height: 42,
                          child: prefixIcon),
                    ),
                  )
                : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      width: 42,
                      height: 42,
                      child: suffixIcon),
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color:
                  Color.fromARGB(255, 212, 209, 209)), // Unfocused border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color:
                  Color.fromARGB(255, 223, 220, 220)), // Focused border color
        ),
      ),
    );
  }
}

void _showWlinkorVlinkSheet(
    {required String title,
    required String fieldName,
    required BuildContext context}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Stack(
        clipBehavior: Clip.none, // Allow content to overflow outside the stack
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Add Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 203, 203)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 203, 203)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: fieldName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 203, 203)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 203, 203)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                customButton(label: 'SAVE', onPressed: () {}),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Positioned(
            right: 5,
            top: -50,
            child: Container(
              padding: const EdgeInsets.all(0),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      );
    },
  );
}
