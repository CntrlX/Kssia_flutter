import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/notifiers/people_notifier.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/services/getRatings.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:kssia/src/interface/common/customTextfields.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';
import 'package:kssia/src/validate_urls.dart';

void showWebsiteSheet({
  required VoidCallback addWebsite,
  required String title,
  required String fieldName,
  required BuildContext context,
  required TextEditingController textController1,
  required TextEditingController textController2,
}) {
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
                    textController: textController1,
                  ),
                  const SizedBox(height: 10),
                  ModalSheetTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a website';
                      }

                      return null;
                    },
                    label: fieldName,
                    textController: textController2,
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                        label: 'SAVE',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addWebsite();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Saved')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        fontSize: 16,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
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

void showVideoLinkSheet({
  required VoidCallback addVideo,
  required String title,
  required String fieldName,
  required BuildContext context,
  required TextEditingController textController1,
  required TextEditingController textController2,
}) {
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
                    textController: textController1,
                  ),
                  const SizedBox(height: 10),
                  fieldName == 'Add Youtube Link'
                      ? ModalSheetTextFormField(
                          validator: (value) => validateYouTubeUrl(value),
                          label: fieldName,
                          textController: textController2,
                        )
                      : ModalSheetTextFormField(
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
                  Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                        label: 'SAVE',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addVideo();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Saved')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        fontSize: 16,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
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
                  Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                          label: 'SAVE',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (title == 'Add Video Link') {
                                List<Video> newVideo = [];
                                newVideo.add(Video(
                                    name: textController1.text,
                                    url: textController2.text));
                                ref
                                    .read(userProvider.notifier)
                                    .updateVideo(newVideo);
                              } else {
                                List<Website> newWebsite = [];
                                newWebsite.add(Website(
                                    name: textController1.text,
                                    url: textController2.text));
                                ref
                                    .read(userProvider.notifier)
                                    .updateWebsite(newWebsite);
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Saved')),
                            );
                            Navigator.pop(context);
                          },
                          fontSize: 16);
                    },
                  ),
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

class ShowEnterAwardSheet extends StatefulWidget {
  final TextEditingController textController1;
  final TextEditingController textController2;
  final VoidCallback addAwardCard;
  final String imageType;
  File? awardImage;
  final Future<File?> Function({required String imageType}) pickImage;

  ShowEnterAwardSheet({
    required this.textController1,
    required this.textController2,
    required this.addAwardCard,
    required this.pickImage,
    required this.imageType,
    this.awardImage,
    super.key,
  });

  @override
  State<ShowEnterAwardSheet> createState() => _ShowEnterAwardSheetState();
}

class _ShowEnterAwardSheetState extends State<ShowEnterAwardSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
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
            FormField<File>(
              initialValue: widget.awardImage,
              validator: (value) {
                if (value == null) {
                  return 'Please upload an image';
                }
                return null;
              },
              builder: (FormFieldState<File> state) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile =
                            await widget.pickImage(imageType: widget.imageType);
                        setState(() {
                          widget.awardImage = pickedFile;
                          state
                              .didChange(pickedFile); // Update form field state
                        });
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: state.hasError
                              ? Border.all(color: Colors.red)
                              : null,
                        ),
                        child: widget.awardImage == null
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        size: 27, color: Color(0xFF004797)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload Image',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 101, 101)),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Image.file(
                                widget.awardImage!,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              )),
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            ModalSheetTextFormField(
              label: 'Add name',
              textController: widget.textController1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            ModalSheetTextFormField(
              label: 'Add Authority name',
              textController: widget.textController2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the authority name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            customButton(
              label: 'SAVE',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.addAwardCard();
                  Navigator.pop(context);
                }
              },
              fontSize: 16,
            ),
            const SizedBox(height: 10),
          ],
        ),
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
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
            FormField<File>(
              initialValue: widget.certificateImage,
              validator: (value) {
                if (value == null) {
                  return 'Please upload an image';
                }
                return null;
              },
              builder: (FormFieldState<File> state) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile =
                            await widget.pickImage(imageType: widget.imageType);
                        setState(() {
                          widget.certificateImage = pickedFile;
                          state
                              .didChange(pickedFile); // Update form field state
                        });
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: state.hasError
                              ? Border.all(color: Colors.red)
                              : null,
                        ),
                        child: widget.certificateImage == null
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        size: 27, color: Color(0xFF004797)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload Image',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 101, 101)),
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
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            ModalSheetTextFormField(
              label: 'Add Name',
              textController: widget.textController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            customButton(
              label: 'SAVE',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.addCertificateCard();
                  Navigator.pop(context);
                }
              },
              fontSize: 16,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ShowAddBrochureSheet extends StatefulWidget {
  final TextEditingController textController;
  final Future<File?> Function({required String imageType}) pickPdf;
  final VoidCallback addBrochureCard;
  final String brochureName;
  String imageType;

  ShowAddBrochureSheet({
    super.key,
    required this.textController,
    required this.pickPdf,
    required this.addBrochureCard,
    required this.brochureName,
    required this.imageType,
  });

  @override
  State<ShowAddBrochureSheet> createState() => _ShowAddBrochureSheetState();
}

class _ShowAddBrochureSheetState extends State<ShowAddBrochureSheet> {
  final _formKey = GlobalKey<FormState>();
  File? brochurePdf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
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
            FormField<File>(
              initialValue: brochurePdf,
              validator: (value) {
                if (value == null) {
                  return 'Please upload a PDF';
                }
                return null;
              },
              builder: (FormFieldState<File> state) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile =
                            await widget.pickPdf(imageType: widget.imageType);
                        setState(() {
                          brochurePdf = pickedFile;
                          state.didChange(pickedFile);
                        });
                      },
                      child: brochurePdf == null
                          ? Container(
                              height: 110,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: state.hasError
                                    ? Border.all(color: Colors.red)
                                    : null,
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        size: 27, color: Color(0xFF004797)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload PDF',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 101, 101)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'PDF ADDED',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            ModalSheetTextFormField(
              label: 'Add Name',
              textController: widget.textController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name for the brochure';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            customButton(
              label: 'SAVE',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.addBrochureCard();
                  Navigator.pop(context);
                }
              },
              fontSize: 16,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ShowEnterProductsSheet extends StatefulWidget {
  String productPriceType;
  final TextEditingController productNameText;
  final TextEditingController descriptionText;
  final TextEditingController moqText;
  final TextEditingController actualPriceText;
  final TextEditingController offerPriceText;

  final VoidCallback addProductCard;
  final String imageType;
  File? productImage;
  final Future<File?> Function({required String imageType}) pickImage;

  ShowEnterProductsSheet({
    super.key,
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
  });

  @override
  State<ShowEnterProductsSheet> createState() => _ShowEnterProductsSheetState();
}

class _ShowEnterProductsSheetState extends State<ShowEnterProductsSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FormField<File>(
                initialValue: widget.productImage,
                validator: (value) {
                  if (value == null) {
                    return 'Please upload an image';
                  }
                  return null;
                },
                builder: (FormFieldState<File> state) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: LoadingAnimation(),
                              );
                            },
                          );

                          final pickedFile = await widget.pickImage(
                              imageType: widget.imageType);
                          setState(() {
                            widget.productImage = pickedFile;
                            state.didChange(pickedFile); // Update form state
                          });

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: state.hasError
                                ? Border.all(color: Colors.red)
                                : null,
                          ),
                          child: widget.productImage == null
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          size: 27, color: Color(0xFF004797)),
                                      SizedBox(height: 10),
                                      Text(
                                        'Upload Image',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 102, 101, 101)),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Image.file(
                                    widget.productImage!,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            state.errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              Center(
                child: Text('Must be less than 1mb'),
              ),
              const SizedBox(height: 20),
              ModalSheetTextFormField(
                textController: widget.productNameText,
                label: 'Add name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ModalSheetTextFormField(
                textController: widget.descriptionText,
                label: 'Add description',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ModalSheetTextFormField(
                textController: widget.moqText,
                label: 'Add MOQ',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the MOQ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: ModalSheetTextFormField(
                      textController: widget.actualPriceText,
                      label: 'Actual price',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the actual price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: ModalSheetTextFormField(
                      textController: widget.offerPriceText,
                      label: 'Offer price',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the offer price';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 185, 181, 181),
                      width: 1.0,
                    ),
                  ),
                ),
                onPressed: () {
                  _showProductPriceTypeDialog(context).then((value) {
                    if (value != null) {
                      widget.productPriceType = value;
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.productPriceType,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 94, 93, 93)),
                    ),
                    const Icon(
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
                  if (_formKey.currentState!.validate()) {
                    widget.addProductCard();
                    Navigator.pop(context);
                  }
                },
                fontSize: 16,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
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
        title: const Text('Select an Option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Price per unit'),
              onTap: () {
                Navigator.of(context).pop('Price per unit');
              },
            ),
            ListTile(
              title: const Text('Option 2'),
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

class ShowAddRequirementSheet extends StatefulWidget {
  final Future<File?> Function({required String imageType}) pickImage;
  final TextEditingController textController;
  final String imageType;
  File? requirementImage;
  final BuildContext context1;
  ShowAddRequirementSheet(
      {super.key,
      required this.textController,
      required this.imageType,
      required this.pickImage,
      this.requirementImage,
      required this.context1});

  @override
  State<ShowAddRequirementSheet> createState() =>
      _ShowAddRequirementSheetState();
}

class _ShowAddRequirementSheetState extends State<ShowAddRequirementSheet> {
  @override
  Widget build(BuildContext context) {
    ApiRoutes api = ApiRoutes();
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(widget.context1).viewInsets.bottom),
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
            onTap: () async {
              final pickedImage =
                  await widget.pickImage(imageType: widget.imageType);
              setState(() {
                widget.requirementImage = pickedImage;
              });
            },
            child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.requirementImage == null
                    ? const Center(
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
                    : Image.file(widget.requirementImage!)),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.textController,
            maxLines:
                ((MediaQuery.sizeOf(widget.context1).height) / 200).toInt(),
            decoration: InputDecoration(
              hintText: 'Add content',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                await api.uploadRequirement(
                    token,
                    id,
                    widget.textController.text,
                    'pending',
                    widget.requirementImage!,
                    context);

                CustomSnackbar.showSnackbar(
                    context, "Your requirement will be reviewed by ADMIN");
                Navigator.pop(context);
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
  }
}

class ShowPaymentUploadSheet extends StatefulWidget {
  final Future<File?> Function({required String imageType}) pickImage;
  final TextEditingController textController;
  final String imageType;
  File? paymentImage;
  final String subscriptionType;

  ShowPaymentUploadSheet(
      {super.key,
      required this.pickImage,
      required this.textController,
      required this.imageType,
      this.paymentImage,
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
                  ? const Center(
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
            controller: widget.textController,
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
            onPressed: () async {
              // Make sure to handle the API call and show the snackbar conditionally
              String? success = await api.uploadPayment(
                context,
                token,
                widget.subscriptionType,
                widget.textController.text,
                widget.paymentImage!,
              );

              // Check if the widget is still mounted

              Navigator.pop(context);
            },
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

class ShowWriteReviewSheet extends StatefulWidget {
  final String userId;
  ShowWriteReviewSheet({
    super.key,
    required this.userId,
  });

  @override
  State<ShowWriteReviewSheet> createState() => _ShowWriteReviewSheetState();
}

class _ShowWriteReviewSheetState extends State<ShowWriteReviewSheet> {
  TextEditingController feedbackController = TextEditingController();
  int selectedRating = 0;
  final _formKey = GlobalKey<FormState>();

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'How is your Experience with this Member?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color: index < selectedRating ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    selectedRating = index + 1;
                  });
                },
              );
            }),
          ),
          SizedBox(height: 20),
          TextField(
            controller: feedbackController,
            decoration: InputDecoration(
              hintText: 'Leave Your Feedback here',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('CANCEL'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        ApiRoutes userApi = ApiRoutes();
                        await userApi
                            .postReview(widget.userId, feedbackController.text,
                                selectedRating, context)
                            .then(
                          (value) {
                            ref.invalidate(peopleNotifierProvider);
                          },
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text('SUBMIT'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductDetailsModal extends ConsumerStatefulWidget {
  final Product product;
  final Participant receiver;
  final Participant sender;

  const ProductDetailsModal(
      {super.key,
      required this.product,
      required this.receiver,
      required this.sender});

  @override
  _ProductDetailsModalState createState() => _ProductDetailsModalState();
}

class _ProductDetailsModalState extends ConsumerState<ProductDetailsModal> {
  TextEditingController _quantityController = TextEditingController();
  late final webSocketClient;

  @override
  void initState() {
    super.initState();
    _quantityController.text = '0';

  }

  @override
  void dispose() {
    _quantityController.dispose();

    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      int currentValue = int.tryParse(_quantityController.text) ?? 0;
      _quantityController.text = (currentValue + 1).toString();
    });
  }

  void _decrementQuantity() {
    setState(() {
      int currentValue = int.tryParse(_quantityController.text) ?? 0;
      if (currentValue > 0) {
        _quantityController.text = (currentValue - 1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(
            fetchUserDetailsProvider(token, widget.product.sellerId!.id!));

        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          20), // Set the desired radius for the top left corner
                      topRight: Radius.circular(
                          20), // Set the desired radius for the top right corner
                    ),
                    child: Image.network(
                      widget.product.image!, // Replace with your image URL
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://placehold.co/600x400/png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text(
                        widget.product.name!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                widget.product.offerPrice != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(
                              'INR ${widget.product.price} / piece',
                              style: TextStyle(
                                decoration: widget.product.offerPrice != null
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.black),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: Text(
                                  'INR ${widget.product.offerPrice?.toDouble()} / piece',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        'INR ${widget.product.price} / piece',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                if (widget.product.moq != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          'MOQ : ${widget.product.moq}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text(
                        widget.product.description!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                asyncUser.when(
                  data: (user) {
                    final averageRating = getAverageRating(user);
                    final totalReviews = user.reviews!.length;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child: Image.network(
                                user.profilePicture ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${user!.name!.firstName} ${user.name?.middleName ?? ''} ${user.name!.lastName}'),
                              Text('${user.companyName}'),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange),
                              Text(averageRating.toStringAsFixed(2)),
                              Text('($totalReviews)'),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(child: LoadingAnimation()),
                  error: (error, stackTrace) {
                    return Center(
                      child: LoadingAnimation(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decrementQuantity,
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 40,
                      width:
                          210, // Increase this value to expand the horizontal width
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 235, 229, 229),
                              width: 2.0, // Border width
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 235, 229, 229),
                              width: 1.0, // Border width when focused
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        onChanged: (value) {
                          if (int.tryParse(value) == null) {
                            _quantityController.text = '0';
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customButton(
                      label: 'Get Quote',
                      onPressed: () async {
                        await sendChatMessage(
                            productId: widget.product.id,
                            userId: widget.product.sellerId!.id!,
                            content:
                                '''I need ${_quantityController.text}\nLet\'s Connect!''');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => IndividualPage(
                                  receiver: widget.receiver,
                                  sender: widget.sender,
                                )));
                      },
                      fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class RequirementModalSheet extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final String buttonText;
  final Requirement requirement;
  final Participant sender;
  final Participant receiver;

  const RequirementModalSheet({
    Key? key,
    required this.onButtonPressed,
    required this.buttonText,
    required this.requirement,
    required this.sender,
    required this.receiver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(
            fetchUserDetailsProvider(token, requirement.author!.id!));
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    0.8, // Fixed height (75% of screen height)
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (requirement.image != null &&
                        requirement.image != '')
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20.0)),
                        child: Image.network(
                          requirement.image!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (requirement.image != null &&
                        requirement.image != '')
                      const SizedBox(height: 20),
                    // Make only the text content scrollable
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(requirement.content ?? ''),
                    ),
                    asyncUser.when(
                      data: (user) {
                        final averageRating = getAverageRating(user);
                        final totalReviews = user.reviews!.length;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: ClipOval(
                                  child: Image.network(
                                    user.profilePicture ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.person);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${user!.name!.firstName} ${user.name?.middleName ?? ''} ${user.name!.lastName}'),
                                  Text('${user.companyName}'),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.orange),
                                  Text(averageRating.toStringAsFixed(2)),
                                  Text('($totalReviews)'),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(child: LoadingAnimation()),
                      error: (error, stackTrace) {
                        return Center(
                          child: LoadingAnimation(),
                        );
                      },
                    ),
                    if (id != requirement.author?.id)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Consumer(
                          builder: (context, ref, child) {
                            return customButton(
                              label: buttonText,
                              onPressed: () async {
                                await sendChatMessage(
                                    userId: requirement.author!.id!,
                                    content: requirement.content!,
                                    requirementId: requirement.id);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => IndividualPage(
                                          receiver: receiver,
                                          sender: sender,
                                        )));
                              },
                              fontSize: 16,
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
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
}

void showRequirementModalSheet({
  required BuildContext context,
  required VoidCallback onButtonPressed,
  required String buttonText,
  required Requirement requirement,
  required Participant sender,
  required Participant receiver,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return RequirementModalSheet(
        onButtonPressed: onButtonPressed,
        buttonText: buttonText,
        requirement: requirement,
        sender: sender,
        receiver: receiver,
      );
    },
  );
}
