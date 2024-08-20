import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kssia/src/data/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/customTextfields.dart';
import 'package:kssia/src/interface/common/custom_switch.dart';
import 'package:kssia/src/interface/common/components/svg_icon.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/main_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:kssia/src/interface/screens/main_pages/user_provider.dart';
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
                  child: customButton(
                      label: 'Next', onPressed: onNext, fontSize: 16)),
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
  String _productPriceType = 'Price per unit';
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
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController igController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController twtitterController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController websiteNameController = TextEditingController();
  final TextEditingController websiteLinkController = TextEditingController();
  final TextEditingController videoNameController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();
  final TextEditingController awardNameController = TextEditingController();
  final TextEditingController awardAuthorityController =
      TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productMoqController = TextEditingController();
  final TextEditingController productActualPriceController =
      TextEditingController();
  final TextEditingController productOfferPriceController =
      TextEditingController();
  final TextEditingController certificateNameController =
      TextEditingController();
  final TextEditingController brochureNameController = TextEditingController();
  File? _profileImageFile;
  File? _companyImageFile;
  File? _awardImageFIle;
  File? _productImageFIle;
  File? _certificateImageFIle;
  File? _brochurePdfFile;

  final _formKey = GlobalKey<FormState>();
  ApiRoutes api = ApiRoutes();
  String awardUrl = '';
  String profileUrl = '';
  String companyUrl = '';
  String productUrl = '';
  String certificateUrl = '';
  String brochureUrl = '';
  List<Award> awards = [];
  List<Product> products = [];
  List<Certificate> certificates = [];
  List<Brochure> brochures = [];

  Future<void> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      if (imageType == 'profile') {
        setState(() {
          _profileImageFile = File(result.files.single.path!);
          api.createFileUrl(file: _profileImageFile!).then((url) {
            profileUrl = url;
            print((profileUrl));
          });
        });
      } else if (imageType == 'award') {
        _awardImageFIle = File(result.files.single.path!);
      } else if (imageType == 'product') {
        _productImageFIle = File(result.files.single.path!);
      } else if (imageType == 'certificate') {
        _certificateImageFIle = File(result.files.single.path!);
      } else if (imageType == 'company') {
        setState(() {
          _companyImageFile = File(result.files.single.path!);
          api.createFileUrl(file: _companyImageFile!).then((url) {
            companyUrl = url;
            print((companyUrl));
          });
        });
      } else {
        _brochurePdfFile = File(result.files.single.path!);
      }
    }
  }

  // void _addAwardCard() async {
  // await api.createFileUrl(file: _awardImageFIle!).then((url) {
  //   awardUrl = url;
  //   print((awardUrl));
  // });
  //   ref.read(userProvider.notifier).updateAwards([...?ref.read(userProvider).value?.awards, newAward]);
  // }

  void _addNewAward() async {
    await api.createFileUrl(file: _awardImageFIle!).then((url) {
      awardUrl = url;
      print((awardUrl));
    });
    final newAward = Award(
      name: awardNameController.text,
      url: awardUrl,
      authorityName: awardAuthorityController.text,
    );

    ref
        .read(userProvider.notifier)
        .updateAwards([...?ref.read(userProvider).value?.awards, newAward]);
  }

  void _removeAward(int index) async {
    await api.deleteFile(
        token, ref.read(userProvider).value!.awards![index].url!);
    ref
        .read(userProvider.notifier)
        .removeAward(ref.read(userProvider).value!.awards![index]);
  }

  _addNewProduct() async {
    final createdProduct = await api.uploadProduct(
        token,
        productNameController.text,
        productActualPriceController.text,
        productDescriptionController.text,
        productMoqController.text,
        _productImageFIle!,
        id);
    if (createdProduct == null) {
      print('couldnt create new product');
    } else {
      // add more product details if want
      final newProduct = Product(
          id: createdProduct.id,
          name: productNameController.text,
          image: productUrl,
          description: productDescriptionController.text,
          moq: int.parse(productMoqController.text) ,
          offerPrice: int.parse(productOfferPriceController.text),
          price: int.parse(productActualPriceController.text),
          sellerId: SellerId(id: id),
          status: true,       
          );
      ref.read(userProvider.notifier).updateProduct(
          [...?ref.read(userProvider).value?.products, newProduct]);
    }
  }

  void _removeProduct(int index) async {
    await api.deleteFile(
        token, ref.read(userProvider).value!.awards![index].url!);
    ref
        .read(userProvider.notifier)
        .removeAward(ref.read(userProvider).value!.awards![index]);
  }

  Future<void> _addProductCard({required String productId}) async {
    await api.createFileUrl(file: _productImageFIle!).then((url) {
      productUrl = url;
      print((awardUrl));
    });
    setState(() {
      products.add(Product(
        id: productId,
        sellerId: SellerId(id: id),
        name: productNameController.text,
        image: productUrl,
        price: int.parse(productActualPriceController.text),
        offerPrice: int.parse(productOfferPriceController.text),
        description: productDescriptionController.text,
        moq: int.parse(productMoqController.text),
        units: 0,
        status: true,
        tags: [],
      ));
    });
  }

  void _removeProductCard(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void _addCertificateCard() async {
    await api.createFileUrl(file: _certificateImageFIle!).then((url) {
      certificateUrl = url;
      print((certificateUrl));
    });
    setState(() {
      certificates.add(
        Certificate(
          name: certificateNameController.text,
          url: certificateUrl,
        ),
      );
    });
  }

  void _removeCertificateCard(int index) {
    setState(() {
      certificates.removeAt(index);
    });
  }

  void _addBrochureCard() async {
    await api.createFileUrl(file: _brochurePdfFile!).then((url) {
      brochureUrl = url;
      print((brochureUrl));
    });
    setState(() {
      brochures
          .add(Brochure(name: brochureNameController.text, url: brochureUrl));
    });
  }

  void _removeBrochureCard(int index) {
    setState(() {
      brochures.removeAt(index);
    });
  }

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
      "company_address": companyEmailController.text,
      "bio": bioController.text,
      "address": {
        "street": street,
        "city": city,
        "state": state,
        "zip": zip,
        "social_media": [
          {"platform": "string", "url": igController.text}
        ],
        "websites": [
          {"name": websiteNameController.text, "url": websiteLinkController}
        ],
        "video": [
          {"name": videoNameController, "url": videoLinkController}
        ],
        "awards": [
          {
            "name": awardNameController,
            "url": "string",
            "authority_name": "string"
          }
        ],
        "certificates": [
          {"name": certificateNameController, "url": "string"}
        ],
        "brochure": [
          {"name": brochureNameController, "url": "string"}
        ],
        "product": [
          {
            "_id": "string",
            "seller_id": "string",
            "name": "string",
            "image": "string",
            "price": 0,
            "offer_price": 0,
            "description": "string",
            "moq": 0,
            "units": "string",
            "status": "string",
            "tags": ["string"]
          }
        ]
      },
    };

    // ApiRoutes apiRoutes = ApiRoutes();
    // apiRoutes.editUser(profileData);
    print(profileData);
  }

  // Future<void> _selectImageFile(ImageSource source, String imageType) async {
  //   final XFile? image = await _picker.pickImage(source: source);
  //   print('$image');
  //   if (image != null && imageType == 'profile') {
  //     setState(() {
  //       _profileImageFile = _pickFile()
  //     });
  //   } else if (image != null && imageType == 'company') {
  //     setState(() {
  //       _companyImageFile = File(image.path);
  //     });
  //   }
  // }

  Future<void> _pickImage(ImageSource source, String imageType) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else if (source == ImageSource.gallery) {
      status = await Permission.photos.request();
    } else {
      return;
    }

    if (status.isGranted) {
      _pickFile(imageType: imageType);
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

  void _openModalSheet(
      {required String sheet, String brochureName = 'Sample'}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        if (sheet == 'award') {
          return ShowEnterAwardtSheet(
            pickImage: _pickFile,
            addAwardCard: _addNewAward,
            imageType: sheet,
            awardImage: _awardImageFIle,
            textController1: awardNameController,
            textController2: awardAuthorityController,
          );
        } else if (sheet == 'product') {
          return ShowEnterProductsSheet(
              productImage: _productImageFIle,
              imageType: sheet,
              pickImage: _pickFile,
              addProductCard: _addProductCard,
              productNameText: productNameController,
              descriptionText: productDescriptionController,
              moqText: productMoqController,
              actualPriceText: productActualPriceController,
              offerPriceText: productOfferPriceController,
              productPriceType: _productPriceType);
        } else if (sheet == 'certificate') {
          return ShowAddCertificateSheet(
              certificateImage: _certificateImageFIle,
              addCertificateCard: _addCertificateCard,
              textController: certificateNameController,
              imageType: sheet,
              pickImage: _pickFile);
        } else {
          return ShowAddBrochureSheet(
              brochureName: brochureName,
              textController: brochureNameController,
              pickPdf: _pickFile,
              imageType: sheet,
              addBrochureCard: _addBrochureCard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(userProvider);
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
          body: asyncUser.when(
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              return Center(
                child: Text('Error loading User: $error'),
              );
            },
            data: (user) {
              print(user);
              print(user.awards);
              nameController.text =
                  '${user.name!.firstName} ${user.name!.middleName} ${user.name!.lastName}';
              designationController.text = user.designation!;
              bioController.text = user.bio!;
              companyNameController.text = user.companyName!;
              companyAddressController.text = user.companyAddress!;
              personalPhoneController.text =
                  user.phoneNumbers!.personal.toString();
              landlineController.text = user.phoneNumbers!.landline.toString();
              emailController.text = user.email!;
              whatsappBusinessController.text =
                  user.phoneNumbers!.whatsappBusinessNumber == 0
                      ? ''
                      : user.phoneNumbers!.whatsappBusinessNumber.toString();
              whatsappController.text = user.phoneNumbers!.whatsappNumber == 0
                  ? ''
                  : user.phoneNumbers!.whatsappNumber.toString();
              addressController.text = user.address!;
              List<TextEditingController> socialLinkControllers = [
                igController,
                linkedinController,
                twtitterController,
                facebookController
              ];

              for (int i = 0; i < socialLinkControllers.length; i++) {
                if (i < user.socialMedia!.length) {
                  socialLinkControllers[i].text =
                      user.socialMedia![i].url ?? '';
                } else {
                  socialLinkControllers[i].clear();
                }
              }

              List<TextEditingController> websiteLinkControllers = [
                websiteLinkController
              ];
              List<TextEditingController> websiteNameControllers = [
                websiteNameController
              ];

              for (int i = 0; i < websiteLinkControllers.length; i++) {
                if (i < user.websites!.length) {
                  websiteLinkControllers[i].text = user.websites![i].url ?? '';
                  websiteNameControllers[i].text = user.websites![i].name ?? '';
                } else {
                  websiteLinkControllers[i].clear();
                  websiteNameControllers[i].clear();
                }
              }

              List<TextEditingController> videoLinkControllers = [
                videoLinkController
              ];
              List<TextEditingController> videoNameControllers = [
                videoNameController
              ];

              for (int i = 0; i < videoLinkControllers.length; i++) {
                if (i < user.video!.length) {
                  videoLinkControllers[i].text = user.video![i].url ?? '';
                  videoNameControllers[i].text = user.video![i].name ?? '';
                } else {
                  videoLinkControllers[i].clear();
                  videoNameControllers[i].clear();
                }
              }

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
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
                              scrolledUnderElevation: 0,
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
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),
                          FormField<File>(
                            validator: (value) {
                              if (_profileImageFile == null) {
                                return 'Please select a profile image';
                              }
                              return null;
                            },
                            builder: (FormFieldState<File> state) {
                              return Center(
                                child: Column(
                                  children: [
                                    Stack(
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
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: _profileImageFile == null
                                                  ? const Icon(
                                                      Icons.person,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    )
                                                  : Image.file(
                                                      _profileImageFile!,
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
                                                    _buildImagePickerOptions(
                                                        context, 'profile'),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
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
                                    if (state.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          state.errorText ?? '',
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 60, left: 16, bottom: 10),
                                child: Text(
                                  'Personal Details',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Your Full Name';
                                    }
                                    return null;
                                  },
                                  textController: nameController,
                                  labelText: 'Enter your Full name',
                                ),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Your Designation';
                                      }
                                      return null;
                                    },
                                    textController: designationController,
                                    labelText: 'Designation'),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Your Bio';
                                      }
                                      return null;
                                    },
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
                                padding: EdgeInsets.only(
                                    top: 60, left: 16, bottom: 10),
                                child: Text(
                                  'Company Details',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          FormField<File>(
                            validator: (value) {
                              if (_profileImageFile == null) {
                                return 'Please select a company logo';
                              }
                              return null;
                            },
                            builder: (FormFieldState<File> state) {
                              return Center(
                                child: Column(
                                  children: [
                                    Stack(
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
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: _companyImageFile == null
                                                  ? const Center(
                                                      child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Upload',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Company',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Logo',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ))
                                                  : Image.file(
                                                      _companyImageFile!,
                                                      fit: BoxFit.cover,
                                                      width: 120,
                                                      height: 120,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -4,
                                          right: -4,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    _buildImagePickerOptions(
                                                        context, 'company'),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    offset:
                                                        const Offset(-1, -1),
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
                                    if (state.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          state.errorText ?? '',
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 10),
                            child: CustomTextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Your Company Name';
                                  }
                                  return null;
                                },
                                labelText: 'Enter Company Name',
                                textController: companyNameController),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Your Company Address (street, city, state, zip)';
                                }
                                return null;
                              },
                              labelText: 'Enter Company Address',
                              textController: companyAddressController,
                              maxLines: 3,
                              prefixIcon: const Icon(
                                Icons.location_city,
                                color: Color(0xFF004797),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value:
                                      ref.watch(isPhoneNumberVisibleProvider),
                                  onChanged: (bool value) {
                                    ref
                                        .read(isPhoneNumberVisibleProvider
                                            .notifier)
                                        .state = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (isPhoneNumberVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 0, bottom: 10),
                              child: CustomTextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Your Phone Number';
                                  }
                                  return null;
                                },
                                textController: personalPhoneController,
                                labelText: 'Enter phone number',
                                prefixIcon: const Icon(Icons.phone,
                                    color: Color(0xFF004797)),
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
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Contact Details',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref
                                      .watch(isContactDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isContactDetailsVisibleProvider
                                              .notifier)
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
                              child: CustomTextFormField(
                                textController: emailController,
                                labelText: 'Enter Email',
                                prefixIcon: const Icon(Icons.email,
                                    color: Color(0xFF004797)),
                              ),
                            ),
                          if (isContactDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: whatsappBusinessController,
                                labelText: 'Enter Business Whatsapp',
                                prefixIcon: const SvgIcon(
                                  assetName:
                                      'assets/icons/whatsapp-business.svg',
                                  color: Color(0xFF004797),
                                  size: 10,
                                ),
                              ),
                            ),
                          if (isContactDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
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
                              child: CustomTextFormField(
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value:
                                      ref.watch(isSocialDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isSocialDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (isSocialDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: igController,
                                labelText: 'Enter Ig',
                                prefixIcon: const SvgIcon(
                                  assetName: 'assets/icons/instagram.svg',
                                  size: 10,
                                  color: Color(0xFF004797),
                                ),
                              ),
                            ),
                          if (isSocialDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: linkedinController,
                                labelText: 'Enter Linkedin',
                                prefixIcon: const SvgIcon(
                                  assetName: 'assets/icons/linkedin.svg',
                                  color: Color(0xFF004797),
                                  size: 10,
                                ),
                              ),
                            ),
                          if (isSocialDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: twtitterController,
                                labelText: 'Enter Twitter',
                                prefixIcon: const SvgIcon(
                                  assetName: 'assets/icons/twitter.svg',
                                  color: Color(0xFF004797),
                                  size: 13,
                                ),
                              ),
                            ),
                          if (isSocialDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: facebookController,
                                labelText: 'Enter Facebook',
                                prefixIcon: const Icon(
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref
                                      .watch(isWebsiteDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isWebsiteDetailsVisibleProvider
                                              .notifier)
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
                              child: CustomTextFormField(
                                textController: websiteLinkController,
                                readOnly: true,
                                labelText: 'Enter Website Link',
                                suffixIcon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF004797),
                                ),
                                onTap: () {
                                  showWlinkorVlinkSheet(
                                      textController1: websiteNameController,
                                      textController2: websiteLinkController,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value:
                                      ref.watch(isVideoDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isVideoDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (isVideoDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 70),
                              child: CustomTextFormField(
                                textController: videoLinkController,
                                readOnly: true,
                                onTap: () {
                                  showWlinkorVlinkSheet(
                                      textController1: videoNameController,
                                      textController2: videoLinkController,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value:
                                      ref.watch(isAwardsDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    ref
                                        .read(isAwardsDetailsVisibleProvider
                                            .notifier)
                                        .state = value;

                                    // if (value == false) {
                                    //   setState(
                                    //     () {
                                    //       awards = [];
                                    //     },
                                    //   );
                                    // }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 10, right: 10),
                            child: GridView.builder(
                              shrinkWrap:
                                  true, // Let GridView take up only as much space as it needs
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Number of columns
                                crossAxisSpacing: 8.0, // Space between columns
                                mainAxisSpacing: 8.0, // Space between rows
                                childAspectRatio:
                                    .9, // Aspect ratio for the cards
                              ),
                              itemCount: user.awards!.length,
                              itemBuilder: (context, index) {
                                return AwardCard(
                                  award: user.awards![index],
                                  onRemove: () => _removeAward(index),
                                );
                              },
                            ),
                          ),
                          if (isAwardsDetailsVisible)
                            GestureDetector(
                              onTap: () {
                                _openModalSheet(
                                  sheet: 'award',
                                );
                              },
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref
                                      .watch(isProductsDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isProductsDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                    if (value == false) {
                                      setState(
                                        () {
                                          products = [];
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (user.products != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 10, right: 10),
                              child: GridView.builder(
                                shrinkWrap:
                                    true, // Let GridView take up only as much space as it needs
                                physics:
                                    NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  crossAxisSpacing:
                                      8.0, // Space between columns
                                  mainAxisSpacing: 8.0, // Space between rows
                                  childAspectRatio:
                                      .9, // Aspect ratio for the cards
                                ),
                                itemCount: user.products!.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    product: user.products![index],
                                    onRemove: () => _removeProductCard(index),
                                  );
                                },
                              ),
                            ),
                          if (isProductsDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 60),
                              child: GestureDetector(
                                onTap: () {
                                  _openModalSheet(
                                    sheet: 'product',
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  'Enter Certificates',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref.watch(
                                      isCertificateDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(
                                              isCertificateDetailsVisibleProvider
                                                  .notifier)
                                          .state = value;
                                    });
                                    if (value == false) {
                                      setState(
                                        () {
                                          certificates = [];
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (certificates.isNotEmpty)
                            ListView.builder(
                              shrinkWrap:
                                  true, // Let ListView take up only as much space as it needs
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable ListView's internal scrolling
                              itemCount: certificates.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0), // Space between items
                                  child: CertificateCard(
                                    certificate: certificates[index],
                                    onRemove: () =>
                                        _removeCertificateCard(index),
                                  ),
                                );
                              },
                            ),
                          if (isCertificateDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 60),
                              child: GestureDetector(
                                onTap: () =>
                                    _openModalSheet(sheet: 'certificate'),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  'Enter Brochure',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref
                                      .watch(isBrochureDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isBrochureDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                    if (value == false) {
                                      setState(
                                        () {
                                          brochures = [];
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (brochures.isNotEmpty)
                            ListView.builder(
                              shrinkWrap:
                                  true, // Let ListView take up only as much space as it needs
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable ListView's internal scrolling
                              itemCount: brochures.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0), // Space between items
                                  child: BrochureCard(
                                    brochure: brochures[index],
                                    // onRemove: () => _removeCertificateCard(index),
                                  ),
                                );
                              },
                            ),
                          if (isBrochureDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 60),
                              child: GestureDetector(
                                onTap: () => _openModalSheet(sheet: 'brochure'),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: SizedBox(
                          height: 50,
                          child: customButton(
                              fontSize: 16,
                              label: 'Save & Proceed',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Perform actions if the form is valid
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Form is valid')),
                                  );
                                }
                                _submitData();
                              }))),
                ],
              );
            },
          )),
    );
  }

  Widget _buildImagePickerOptions(BuildContext context, String imageType) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Choose from Gallery'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.gallery, imageType);
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.camera_alt),
        //   title: const Text('Take a Photo'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     _pickImage(ImageSource.camera, imageType);
        //   },
        // ),
      ],
    );
  }
}
