import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/customTextfields.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';

void showWlinkorVlinkSheet(
    {required String title,
    required String fieldName,
    required BuildContext context,
    required TextEditingController textController1,
    required TextEditingController textController2}) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Form(
        key: _formKey,
        child: Stack(
          clipBehavior:
              Clip.none, // Allow content to overflow outside the stack
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
                  ModalSheetTextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This is a required field';
                        }
                        return null;
                      },
                      label: 'Add name',
                      textController: textController1),
                  const SizedBox(
                    height: 10,
                  ),
                  ModalSheetTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is a required field';
                      }
                      return null;
                    },
                    label: fieldName,
                    textController: textController2,
                  ),
                  const SizedBox(height: 10),
                  customButton(
                      label: 'SAVE',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved')),
                          );
                          Navigator.pop(context);
                        }
                      },
                      fontSize: 16),
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
        ),
      );
    },
  );
}

class ShowEnterAwardtSheet extends StatelessWidget {
  final TextEditingController textController1;
  final BuildContext context1;
  final TextEditingController textController2;
  final VoidCallback addAwardCard;
  final String imageType;
  final File? awardImage;
  final Future<void> Function({required String imageType}) pickImage;

  const ShowEnterAwardtSheet(
      {required this.textController1,
      required this.textController2,
      required this.addAwardCard,
      required this.pickImage,
      required this.imageType,
      required this.awardImage,
      super.key,
      required this.context1});

  @override
  Widget build(BuildContext context1) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context1).viewInsets.bottom),
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
                onPressed: () => Navigator.of(context1).pop(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              pickImage(imageType: imageType);
            },
            child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: awardImage == null
                    ? Center(
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
                      )
                    : Center(
                        child: Image.file(
                        awardImage!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ))),
          ),
          const SizedBox(height: 20),
          ModalSheetTextFormField(
            label: 'Add name',
            textController: textController1,
          ),
          SizedBox(
            height: 10,
          ),
          ModalSheetTextFormField(
            label: 'Add Authority name',
            textController: textController2,
          ),
          const SizedBox(height: 10),
          customButton(
              label: 'SAVE',
              onPressed: () {
                addAwardCard();
                Navigator.pop(context1);
              },
              fontSize: 16),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class ShowAddCertificateSheet extends StatefulWidget {
  final TextEditingController textController;
  final String imageType;
  File? certificateImage;
  final Future<File?> Function({required String imageType}) pickImage;
  final VoidCallback addCertificateCard;

  ShowAddCertificateSheet({
    super.key,
    required this.textController,
    required this.imageType,
    this.certificateImage,
    required this.pickImage,
    required this.addCertificateCard,
  });

  @override
  State<ShowAddCertificateSheet> createState() =>
      _ShowAddCertificateSheetState();
}

class _ShowAddCertificateSheetState extends State<ShowAddCertificateSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Certificates',
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
            onTap: () async {
              final pickedFile =
                  await widget.pickImage(imageType: 'certificate');
              setState(() {
                widget.certificateImage = pickedFile;
              });
            },
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.certificateImage == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 27, color: Color(0xFF004797)),
                          SizedBox(height: 10),
                          Text(
                            'Upload Image',
                            style: TextStyle(
                                color: Color.fromARGB(255, 102, 101, 101)),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Image.file(
                        widget.certificateImage!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          ModalSheetTextFormField(
            label: 'Add Name',
            textController: widget.textController,
          ),
          const SizedBox(height: 10),
          customButton(
            label: 'SAVE',
            onPressed: () {
              widget.addCertificateCard();
              Navigator.pop(context);
            },
            fontSize: 16,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ShowAddBrochureSheet extends StatelessWidget {
  final TextEditingController textController;
  final Future<void> Function({required String imageType}) pickPdf;
  final VoidCallback addBrochureCard;
  final String brochureName;
  final String imageType;
  const ShowAddBrochureSheet({
    Key? key,
    required this.textController,
    required this.pickPdf,
    required this.addBrochureCard,
    required this.brochureName,
    required this.imageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Brochure',
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
              pickPdf(imageType: imageType);
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
                      'Upload PDF',
                      style:
                          TextStyle(color: Color.fromARGB(255, 102, 101, 101)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ModalSheetTextFormField(
            label: 'Add Name',
            textController: textController,
          ),
          const SizedBox(height: 10),
          customButton(
              label: 'SAVE',
              onPressed: () {
                addBrochureCard();
                Navigator.pop(context);
              },
              fontSize: 16),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ShowEnterProductsSheet extends StatelessWidget {
  String productPriceType;
  final TextEditingController productNameText;
  final TextEditingController descriptionText;
  final TextEditingController moqText;
  final TextEditingController actualPriceText;
  final TextEditingController offerPriceText;
  final BuildContext context1;
  final VoidCallback addProductCard;
  final String imageType;
  final File? productImage;
  final Future<void> Function({required String imageType}) pickImage;
  ShowEnterProductsSheet(
      {super.key,
      required this.productPriceType,
      required this.productNameText,
      required this.descriptionText,
      required this.moqText,
      required this.actualPriceText,
      required this.offerPriceText,
      required this.addProductCard,
      required this.imageType,
      this.productImage,
      required this.pickImage,
      required this.context1});

  @override
  Widget build(BuildContext context1) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context1).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context1).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // Show loading screen
                showDialog(
                  context: context1,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: LoadingAnimation(),
                    );
                  },
                );

                // Run the pickImage function
                await pickImage(imageType: imageType);

                // Dismiss the loading screen
                Navigator.of(context1).pop();
              },
              child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: productImage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,
                                  size: 27, color: Color(0xFF004797)),
                              SizedBox(height: 10),
                              Text(
                                'Upload Image',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101)),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Image.file(
                          productImage!,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ))),
            ),
            const SizedBox(height: 20),
            ModalSheetTextFormField(
              textController: productNameText,
              label: 'Add name',
            ),
            const SizedBox(height: 10),
            ModalSheetTextFormField(
              textController: descriptionText,
              label: 'Add description',
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            ModalSheetTextFormField(textController: moqText, label: 'Add MOQ'),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                    child: ModalSheetTextFormField(
                        textController: actualPriceText,
                        label: 'Actual price')),
                const SizedBox(width: 10),
                Flexible(
                    child: ModalSheetTextFormField(
                        textController: offerPriceText, label: 'Offer price')),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 185, 181, 181),
                    width: 1.0,
                  ),
                ),
              ),
              onPressed: () {
                _showProductPriceTypeDialog(context1).then((value) {
                  if (value != null) {
                    // setState(() {
                    productPriceType = value;
                    // });
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productPriceType,
                    style:
                        TextStyle(color: const Color.fromARGB(255, 94, 93, 93)),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            customButton(
                label: 'Save',
                onPressed: () {
                  //function for getting product id
                  addProductCard();
                  Navigator.pop(context1);
                },
                fontSize: 16),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

Future<String?> _showProductPriceTypeDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text('Select an Option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Price per unit'),
              onTap: () {
                Navigator.of(context).pop('Price per unit');
              },
            ),
            ListTile(
              title: Text('Option 2'),
              onTap: () {
                Navigator.of(context).pop('Option 2');
              },
            ),
          ],
        ),
      );
    },
  );
}

class ShowAddRequirementSheet extends StatelessWidget {
  final Future<void> Function({required String imageType}) pickImage;
  final TextEditingController textController;
  final String imageType;
  final File? requirementImage;
  final BuildContext context1;
  const ShowAddRequirementSheet(
      {super.key,
      required this.textController,
      required this.imageType,
      required this.pickImage,
      this.requirementImage,
      required this.context1});

  @override
  Widget build(BuildContext context) {
    ApiRoutes api = ApiRoutes();
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context1).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Post a Requirement/update',
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
              pickImage(imageType: imageType);
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
                      style:
                          TextStyle(color: Color.fromARGB(255, 102, 101, 101)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: textController,
            maxLines: ((MediaQuery.sizeOf(context1).height) / 200).toInt(),
            decoration: InputDecoration(
              hintText: 'Add content',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                api.uploadRequirement(token, id, textController.text, 'pending',
                    requirementImage!);
              },
              style: ButtonStyle(
                foregroundColor:
                    WidgetStateProperty.all<Color>(Color(0xFF004797)),
                backgroundColor:
                    WidgetStateProperty.all<Color>(Color(0xFF004797)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Color(0xFF004797)),
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
  }
}

class ShowPaymentUploadSheet extends StatefulWidget {
  final Future<File?> Function({required String imageType}) pickImage;
  final TextEditingController textController;
  final String imageType;
  File? paymentImage;
  final BuildContext context1;
  final String subscriptionType;
  ShowPaymentUploadSheet(
      {super.key,
      required this.pickImage,
      required this.textController,
      required this.imageType,
      this.paymentImage,
      required this.context1,
      required this.subscriptionType});

  @override
  State<ShowPaymentUploadSheet> createState() => _ShowPaymentUploadSheetState();
}

class _ShowPaymentUploadSheetState extends State<ShowPaymentUploadSheet> {
  ApiRoutes api = ApiRoutes();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Payment Details',
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
            onTap: () async {
              final pickedFile = await widget.pickImage(imageType: 'payment');
              setState(() {
                widget.paymentImage = pickedFile;
              });
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.paymentImage == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 27, color: Color(0xFF004797)),
                          SizedBox(height: 10),
                          Text(
                            'Upload Image',
                            style: TextStyle(
                                color: Color.fromARGB(255, 102, 101, 101)),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Image.file(
                        widget.paymentImage!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Remarks',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          customButton(
              label: 'SAVE',
              onPressed: () {
                api.uploadPayment(token, widget.subscriptionType,
                    widget.textController.text, widget.paymentImage!);
                Navigator.pop(context);
              },
              fontSize: 16)
        ],
      ),
    );
  }
}
