import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/product_category_model.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/notifiers/people_notifier.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/services/getRatings.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:kssia/src/interface/common/customTextfields.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/common/selection_drop_down.dart';
import 'package:kssia/src/interface/common/upgrade_dialog.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';
import 'package:kssia/src/validate_urls.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

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
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'This is a required field';
                    //   }
                    //   return null;
                    // },
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
                              const SnackBar(content: Text('Saved')),
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
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
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
                    label: 'Add name',
                    textController: textController1,
                  ),
                  const SizedBox(height: 10),
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
                            addVideo();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved')),
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
  final Future<void> Function()? addAwardCard;
  final Future<void> Function()? editAwardCard;
  final String imageType;
  final Future<File?> Function({required String imageType}) pickImage;
  final String? imageUrl;
  const ShowEnterAwardSheet({
    required this.textController1,
    required this.textController2,
    this.addAwardCard,
    required this.pickImage,
    required this.imageType,
    super.key,
    this.editAwardCard,
    this.imageUrl,
  });

  @override
  State<ShowEnterAwardSheet> createState() => _ShowEnterAwardSheetState();
}

class _ShowEnterAwardSheetState extends State<ShowEnterAwardSheet> {
  final _formKey = GlobalKey<FormState>();
  File? awardImage; // Moved awardImage to State
  bool get isEditMode => widget.editAwardCard != null;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.textController1.text = '';
        widget.textController2.text = '';
      },
      child: Padding(
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
                initialValue: awardImage,
                validator: (value) {
                  // Skip validation if in edit mode and no new image is selected
                  if (isEditMode && awardImage == null) {
                    return null;
                  }
                  // Only validate if in add mode or if new image is selected
                  if (!isEditMode && value == null && widget.imageUrl == null) {
                    return 'Please upload an image';
                  }
                  return null;
                },
                builder: (FormFieldState<File> state) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await widget.pickImage(
                              imageType: widget.imageType);
                          if (pickedFile == null) {
                            return; // Don't pop if no image selected
                          }
                          setState(() {
                            awardImage = pickedFile;
                            state.didChange(
                                pickedFile); // Update form field state
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
                          child: awardImage == null
                              ? widget.imageUrl != null
                                  ? Center(
                                      child:
                                          Image.network(widget.imageUrl ?? ''),
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 27,
                                            color: Color(0xFF004797),
                                          ),
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
                                  awardImage!,
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
                label: isEditMode ? 'UPDATE' : 'SAVE',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: LoadingAnimation()),
                    );

                    try {
                      if (isEditMode) {
                        // Edit mode - handle both text-only and image updates
                        await widget.editAwardCard!();
                      } else {
                        // Add mode - always needs image
                        await widget.addAwardCard!();
                      }

                      widget.textController1.clear();
                      widget.textController2.clear();

                      if (awardImage != null) {
                        setState(() {
                          awardImage = null; // Clear the image after saving
                        });
                      }
                    } catch (e) {
                      print('Error updating award: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update award: $e')),
                      );
                    } finally {
                      Navigator.of(context).pop(); // Close loading dialog
                      Navigator.pop(context); // Close modal sheet
                    }
                  }
                },
                fontSize: 16,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowAddCertificateSheet extends StatefulWidget {
  final TextEditingController textController;
  final String imageType;
  final String? imageUrl;
  final Future<File?> Function({required String imageType}) pickImage;
  final Future<void> Function() addCertificateCard;

  ShowAddCertificateSheet({
    super.key,
    required this.textController,
    required this.imageType,
    required this.pickImage,
    required this.addCertificateCard,
    this.imageUrl,
  });

  @override
  State<ShowAddCertificateSheet> createState() =>
      _ShowAddCertificateSheetState();
}

class _ShowAddCertificateSheetState extends State<ShowAddCertificateSheet> {
  File? certificateImage;
  final _formKey = GlobalKey<FormState>();
  bool get isEditMode => widget.imageUrl != null;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.textController.text = '';
      },
      child: Padding(
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
                initialValue: certificateImage,
                validator: (value) {
                  if (isEditMode && certificateImage == null) {
                    return null;
                  }
                  if (!isEditMode && value == null && widget.imageUrl == null) {
                    return 'Please upload an image';
                  }
                  return null;
                },
                builder: (FormFieldState<File> state) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await widget.pickImage(
                              imageType: widget.imageType);
                          if (pickedFile == null) {
                            return; // Don't pop if no image selected
                          }
                          setState(() {
                            certificateImage = pickedFile;
                            state.didChange(
                                pickedFile); // Update form field state
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
                          child: certificateImage == null
                              ? widget.imageUrl != null
                                  ? Center(
                                      child:
                                          Image.network(widget.imageUrl ?? ''),
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 27,
                                            color: Color(0xFF004797),
                                          ),
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
                                    certificateImage!,
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
                label: isEditMode ? 'UPDATE' : 'SAVE',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: LoadingAnimation()),
                    );

                    try {
                      if (isEditMode) {
                        // Edit mode - handle both text-only and image updates
                        await widget.addCertificateCard();
                      } else {
                        // Add mode - always needs image
                        await widget.addCertificateCard();
                      }

                      widget.textController.clear();

                      if (certificateImage != null) {
                        setState(() {
                          certificateImage =
                              null; // Clear the image after saving
                        });
                      }
                    } catch (e) {
                      print('Error updating certificate: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to update certificate: $e')),
                      );
                    } finally {
                      Navigator.of(context).pop(); // Close loading dialog
                      Navigator.pop(context); // Close modal sheet
                    }
                  }
                },
                fontSize: 16,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowAddBrochureSheet extends StatefulWidget {
  final TextEditingController textController;
  final Future<File?> Function({required String imageType}) pickPdf;
  final Future<void> Function() addBrochureCard;
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.textController.text = '';
      },
      child: Padding(
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
                          if (pickedFile == null) {
                            Navigator.pop(context);
                          }
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
                maxLength: 15,
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: LoadingAnimation()),
                    );

                    try {
                      // Pass awardImage to addAwardCard
                      await widget.addBrochureCard();
                      widget.textController.clear();

                      if (brochurePdf != null) {
                        setState(() {
                          brochurePdf = null; // Clear the image after saving
                        });
                      }
                    } finally {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    }
                  }
                },
                fontSize: 16,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class EnterProductsPage extends ConsumerStatefulWidget {
  final bool isEditing;
  final Product? product;
  final Function(Product)? onEdit;
  final String? imageUrl;
  const EnterProductsPage({
    this.imageUrl,
    super.key,
    this.isEditing = false,
    this.product,
    this.onEdit,
  });

  @override
  ConsumerState<EnterProductsPage> createState() => _EnterProductsPageState();
}

class _EnterProductsPageState extends ConsumerState<EnterProductsPage> {
  File? productImage;
  final _formKey = GlobalKey<FormState>();

  // Initialize controllers
  late TextEditingController productPriceType;
  late TextEditingController productNameController;
  late TextEditingController productDescriptionController;
  late TextEditingController productMoqController;
  late TextEditingController productActualPriceController;
  late TextEditingController productOfferPriceController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if editing
    productPriceType = TextEditingController(
        text: widget.isEditing ? widget.product?.units : "Price per unit");
    productNameController = TextEditingController(
        text: widget.isEditing ? widget.product?.name : '');
    productDescriptionController = TextEditingController(
        text: widget.isEditing ? widget.product?.description : '');
    productMoqController = TextEditingController(
        text: widget.isEditing ? widget.product?.moq?.toString() : '');
    productActualPriceController = TextEditingController(
        text: widget.isEditing ? widget.product?.price?.toString() : '');
    productOfferPriceController = TextEditingController(
        text: widget.isEditing ? widget.product?.offerPrice?.toString() : '');

    // Pre-select category and subcategories if editing
    if (widget.isEditing && widget.product != null) {
      selectedCategory = widget.product?.category;
      _selectedItems = widget.product?.subcategory ?? [];
    }
  }

  @override
  void dispose() {
    productPriceType.dispose();
    productNameController.dispose();
    productDescriptionController.dispose();
    productMoqController.dispose();
    productActualPriceController.dispose();
    productOfferPriceController.dispose();
    super.dispose();
  }

  String? selectedCategory;
  List<String> _selectedItems = [];

  void _showMultiSelect(List items, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: items.map((e) => MultiSelectItem(e, e)).toList(),
          initialValue: _selectedItems,
          onConfirm: (values) {
            setState(() {
              _selectedItems = values.cast<String>();
            });
          },
          title: const Text(
            "Select Subcategory",
            style: TextStyle(
                color: Color(0xFF004797), fontWeight: FontWeight.bold),
          ),
          selectedColor: const Color(0xFF004797),
          checkColor: Colors.white,
          searchable: true,
          confirmText: const Text("CONFIRM",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF004797),
              )),
          cancelText: const Text("CANCEL",
              style: TextStyle(color: Color.fromARGB(255, 130, 130, 130))),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  ApiRoutes api = ApiRoutes();

  Future<void> _addNewProduct(
      {required List<String> selectedSubCategories,
      required String selectedCategory}) async {
    final createdProduct = await uploadProduct(
        token,
        productNameController.text,
        productActualPriceController.text,
        productOfferPriceController.text,
        productDescriptionController.text,
        productMoqController.text,
        await api.createFileUrl(productImage!.path),
        productPriceType.text,
        selectedSubCategories,
        selectedCategory,
        context);
    if (createdProduct == null) {
      print('couldnt create new product');
    } else {
      final newProduct = Product(
        id: createdProduct.id,
        name: productNameController.text,
        image: await api.createFileUrl(productImage!.path),
        description: productDescriptionController.text,
        moq: int.parse(productMoqController.text),
        offerPrice: double.parse(productOfferPriceController.text),
        price: double.parse(productActualPriceController.text),
        sellerId: id,
        category: selectedCategory,
        subcategory: selectedSubCategories,
        units: productPriceType.text,
        status: 'pending',
      );
      ref.read(userProvider.notifier).updateProduct(
          [...?ref.read(userProvider).value?.products, newProduct]);
    }
  }

  File? _productImageFIle;
  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
      ],
    );

    if (result != null) {
      _productImageFIle = File(result.files.single.path!);
      return _productImageFIle;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<String> subCategories = productCategories
        .where((category) => category.name == selectedCategory)
        .map((category) => category.subcategories)
        .expand((sub) => sub) // Flatten the list of lists
        .toList();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 231, 226, 226),
                  width: 1.0,
                ),
              ),
            ),
            child: AppBar(
              toolbarHeight: 45.0,
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_back,
                            color: Colors.blue,
                            size: 17,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Add Product',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: KeyboardAvoider(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormField<File>(
                      initialValue: productImage,
                      validator: (value) {
                        if (value == null) {
                          if (!widget.isEditing) {
                            return 'Please upload an image';
                          } else {
                            return null;
                          }
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
                                    return const Center(
                                      child: LoadingAnimation(),
                                    );
                                  },
                                );

                                final pickedFile =
                                    await _pickFile(imageType: 'product');
                                if (pickedFile == null) {
                                  Navigator.pop(context);
                                }

                                setState(() {
                                  productImage = pickedFile;
                                  state.didChange(
                                      pickedFile); // Update form state
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
                                child: productImage == null
                                    ? widget.imageUrl != null
                                        ? Center(
                                            child: Image.network(
                                                widget.imageUrl ?? ''),
                                          )
                                        : const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add,
                                                    size: 27,
                                                    color: Color(0xFF004797)),
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
                                          productImage!,
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
                      textController: productNameController,
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
                      textController: productDescriptionController,
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
                    SelectionDropDown(
                      hintText: 'Add Category',
                      value: selectedCategory,
                      items: productCategories.map((state) {
                        return DropdownMenuItem<String>(
                          value: state.name,
                          child: Text(state.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    if (selectedCategory != null && subCategories.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _showMultiSelect(subCategories, context);
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add Subcategory",
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (subCategories.isNotEmpty)
                      const SizedBox(
                        height: 10,
                      ),
                    MultiSelectChipDisplay(
                      items: _selectedItems.length <= 6
                          ? _selectedItems
                              .map((e) => MultiSelectItem(e, e))
                              .toList()
                          : [
                              ..._selectedItems
                                  .take(6)
                                  .map((e) => MultiSelectItem(e, e)),
                              // MultiSelectItem(
                              //   '+${_selectedItems.length - 6} more',
                              //   '+${_selectedItems.length - 6} more',
                              // ),
                            ],
                      onTap: (value) {
                        if (!value.startsWith('+')) {
                          setState(() {
                            _selectedItems.remove(value);
                          });
                        } else {
                          // Optional: Handle tap on "+N more" if needed
                          debugPrint(
                              'Show remaining items or any desired action.');
                        }
                      },
                      icon: const Icon(Icons.close),
                      chipColor: const Color.fromARGB(255, 224, 224, 224),
                      textStyle: const TextStyle(color: Colors.black),
                    ),
                    if (_selectedItems.length > 6)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Ensure it doesn't stretch
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 226, 222, 222),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                      '+${_selectedItems.length - 6} more')),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),
                    ModalSheetTextFormField(
                      textInputType: const TextInputType.numberWithOptions(),
                      textController: productMoqController,
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
                            textInputType:
                                const TextInputType.numberWithOptions(),
                            textController: productActualPriceController,
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
                            textInputType:
                                const TextInputType.numberWithOptions(),
                            textController: productOfferPriceController,
                            label: 'Offer price',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the offer price';
                              }
                              if (double.parse(
                                      productOfferPriceController.text) >
                                  double.parse(
                                      productActualPriceController.text)) {
                                return 'Make actual price higher';
                              }
                              if (double.parse(
                                      productActualPriceController.text) ==
                                  double.parse(
                                      productOfferPriceController.text)) {
                                return 'Prices should be different';
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
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
                            setState(() {
                              productPriceType.text = value;
                            });

                            log('Selected price per unit: ${productPriceType}');
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productPriceType.text,
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
                      label: widget.isEditing ? 'UPDATE' : 'SAVE',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                const Center(child: LoadingAnimation()),
                          );

                          try {
                            if (widget.isEditing && widget.onEdit != null) {
                              // Create updated product
                              final updatedProduct = Product(
                                id: widget.product!.id,
                                name: productNameController.text,
                                description: productDescriptionController.text,
                                moq: int.parse(productMoqController.text),
                                price: double.parse(
                                    productActualPriceController.text),
                                offerPrice: double.parse(
                                    productOfferPriceController.text),
                                units: productPriceType.text,
                                category: selectedCategory,
                                subcategory: _selectedItems,
                                image: productImage != null
                                    ? await api
                                        .createFileUrl(productImage!.path)
                                    : widget.product?.image,
                                sellerId: widget.product?.sellerId,
                                status: widget.product?.status,
                              );

                              await widget.onEdit!(updatedProduct);
                            } else {
                              await _addNewProduct(
                                selectedSubCategories: _selectedItems,
                                selectedCategory: selectedCategory ?? '',
                              );
                            }

                            // Clear form
                            productNameController.clear();
                            productDescriptionController.clear();
                            productMoqController.clear();
                            productActualPriceController.clear();
                            productOfferPriceController.clear();
                            productPriceType.clear();
                            setState(() {
                              productImage = null;
                            });
                          } finally {
                            Navigator.of(context).pop(); // Close loader
                            Navigator.pop(context); // Go back
                          }
                        }
                      },
                      fontSize: 16,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
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
        title: const Text('Select a Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Kilogram (kg)'),
              onTap: () {
                Navigator.of(context).pop('kg');
              },
            ),
            ListTile(
              title: const Text('Gram (g)'),
              onTap: () {
                Navigator.of(context).pop('g');
              },
            ),
            ListTile(
              title: const Text('Per Piece'),
              onTap: () {
                Navigator.of(context).pop('piece');
              },
            ),
            ListTile(
              title: const Text('Litre (L)'),
              onTap: () {
                Navigator.of(context).pop('L');
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

  final BuildContext context1;

  ShowAddRequirementSheet({
    super.key,
    required this.textController,
    required this.imageType,
    required this.pickImage,
    required this.context1,
  });

  @override
  State<ShowAddRequirementSheet> createState() =>
      _ShowAddRequirementSheetState();
}

class _ShowAddRequirementSheetState extends State<ShowAddRequirementSheet> {
  File? requirementImage;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ApiRoutes api = ApiRoutes();
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(widget.context1).viewInsets.bottom,
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
                  'Post a Requirement',
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
                if (pickedImage == null) {
                  Navigator.pop(context);
                }
                setState(() {
                  requirementImage = pickedImage;
                });
              },
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: requirementImage == null
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 27, color: Color(0xFF004797)),
                            SizedBox(height: 10),
                            Text(
                              'Upload Image',
                              style: TextStyle(
                                color: Color.fromARGB(255, 102, 101, 101),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Image.file(requirementImage!),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.textController,
              maxLines:
                  ((MediaQuery.sizeOf(widget.context1).height) / 200).toInt(),
              decoration: InputDecoration(
                hintText: 'Add content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Content is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            customButton(
              label: 'SAVE',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: LoadingAnimation()),
                  );

                  try {
                    ApiRoutes userApi = ApiRoutes();
                    String? image;
                    if (requirementImage != null) {
                      image = await userApi.createFileUrl(
                        requirementImage!.path,
                      );
                    }
                    await api.uploadRequirement(
                      token,
                      id,
                      widget.textController.text,
                      'pending',
                      image,
                      context,
                    );

                    CustomSnackbar.showSnackbar(
                      context,
                      "Your requirement will be reviewed by ADMIN",
                    );
                    widget.textController.clear();
                    if (requirementImage != null) {
                      setState(() {
                        requirementImage = null; // Clear the image after saving
                      });
                    }
                  } finally {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  }
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

class ShowPaymentUploadSheet extends StatefulWidget {
  final Future<File?> Function({required String imageType}) pickImage;

  final String imageType;
  File? paymentImage;
  final String subscriptionType;

  ShowPaymentUploadSheet({
    super.key,
    required this.pickImage,
    required this.imageType,
    this.paymentImage,
    required this.subscriptionType,
  });

  @override
  State<ShowPaymentUploadSheet> createState() => _ShowPaymentUploadSheetState();
}

class _ShowPaymentUploadSheetState extends State<ShowPaymentUploadSheet> {
  ApiRoutes api = ApiRoutes();
  String? selectedYearId; // Variable to store the selected academic year ID
  TextEditingController amountController = TextEditingController();
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
              if (pickedFile == null) {
                Navigator.pop(context);
              }
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
          Consumer(
            builder: (context, ref, child) {
              final asyncPaymentYears = ref.watch(getPaymentYearsProvider);
              return asyncPaymentYears.when(
                data: (paymentYears) {
                  return DropdownButtonFormField<String>(
                    value: selectedYearId,
                    hint: const Text('Select Year'),
                    items: paymentYears
                        .map(
                          (year) => DropdownMenuItem<String>(
                            value: year.id,
                            child: Text(year.academicYear ?? 'Unknown Year'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYearId = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: LoadingAnimation()),
                error: (error, stackTrace) {
                  return const Center(
                    child: LoadingAnimation(),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: amountController,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          customButton(
            label: 'SAVE',
            onPressed: () async {
              log(selectedYearId.toString());
              log(amountController.text.toString());

              if (selectedYearId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select an academic year'),
                  ),
                );
                return;
              }

              // Check if an image is uploaded
              if (widget.paymentImage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please upload an image'),
                  ),
                );
                return;
              }

              // Check if the amount is provided and valid
              if (amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter the amount'),
                  ),
                );
                return;
              }
              final String paymentImageUrl = await api.createFileUrl(
                widget.paymentImage!.path,
              );
              // Attempt to upload the payment details
              String? success = await api.uploadPayment(
                  context: context,
                  parentSub: selectedYearId ?? '',
                  catergory: widget.subscriptionType,
                  amount: amountController.text,
                  image: paymentImageUrl);

              if (success != null) {
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to upload payment details'),
                  ),
                );
              }
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    'How is your Experience with this Member?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            TextFormField(
              controller: feedbackController,
              decoration: const InputDecoration(
                hintText: 'Leave Your Feedback here',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Feedback cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: customButton(
                        labelColor: Colors.black,
                        sideColor: const Color.fromARGB(255, 234, 229, 229),
                        buttonColor: const Color.fromARGB(255, 234, 229, 229),
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        })),
                const SizedBox(width: 10),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                          label: 'Submit',
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              ApiRoutes userApi = ApiRoutes();
                              await userApi.postReview(
                                  widget.userId,
                                  feedbackController.text,
                                  selectedRating,
                                  context);

                              Navigator.of(context).pop();

                              ref.invalidate(fetchUserDetailsProvider);
                            }
                          });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
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

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.product.moq.toString();
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
      if (currentValue > 0 &&
          currentValue > num.parse(widget.product.moq.toString())) {
        _quantityController.text = (currentValue - 1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref
            .watch(fetchUserDetailsProvider(token, widget.product.sellerId!));

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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                          20), // Set the desired radius for the top left corner
                      topRight: Radius.circular(
                          20), // Set the desired radius for the top right corner
                    ),
                    child: Image.network(
                      widget.product.image!, // Replace with your image URL
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                          ),
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
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration:
                                  const BoxDecoration(color: Colors.black),
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
                      Expanded(
                        // Wrap the Text widget in Expanded to prevent overflow issues
                        child: Text(
                          widget.product.description ?? '',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
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
                                  return Image.asset(
                                      'assets/icons/dummy_person_small.png');
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    '${user.abbreviation ?? ''} ${user.name ?? ''}'),
                                Text('${user.companyName ?? ''}'),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 15,
                              ),
                              Text(
                                averageRating.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text('($totalReviews)',
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(child: LoadingAnimation()),
                  error: (error, stackTrace) {
                    return const Center(
                        child: Text('Something Went Wrong, Please try again'));
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _decrementQuantity(),
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.remove),
                          )),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                        height: 40,
                        width:
                            210, // Increase this value to expand the horizontal width
                        child: TextField(
                          style: const TextStyle(
                              color: Color(0xFF004797),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            // Border when the field is not focused and enabled
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(
                                    255, 224, 218, 218), // Default border color
                                width: 1.0,
                              ),
                            ),

                            // Border when the field is focused
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 220, 223,
                                    226), // Border color when focused
                                width: 2.0,
                              ),
                            ),

                            // Border when the field is disabled
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey
                                    .shade400, // Lighter grey for disabled state
                                width: 1.0,
                              ),
                            ),

                            // Border when an error is present (e.g., validation failed)
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.red, // Red border for error state
                                width: 1.0,
                              ),
                            ),

                            // Border when the field is both focused and has an error
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors
                                    .red, // Red border when focused and has an error
                                width: 2.0,
                              ),
                            ),

                            // Padding inside the TextField
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                          ),
                          onChanged: (value) {
                            // Ensure only valid numbers are allowed
                            if (int.tryParse(value) == null) {
                              _quantityController.text = '0';
                            }
                          },
                        )),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _incrementQuantity(),
                      child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.add),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customButton(
                      label: 'Get Quote',
                      onPressed: () async {
                        if (subscription != 'free') {
                          await sendChatMessage(
                              productId: widget.product.id,
                              userId: widget.product.sellerId!,
                              content:
                                  '''I need ${_quantityController.text}\nLet\'s Connect!''');

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IndividualPage(
                                    receiver: widget.receiver,
                                    sender: widget.sender,
                                  )));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => const UpgradeDialog(),
                          );
                        }
                      },
                      fontSize: 16),
                ),
                const SizedBox(
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
        final asyncUser =
            ref.watch(fetchUserDetailsProvider(token, requirement.author!.id!));
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.8, // Fixed height (75% of screen height)
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 70,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                asyncUser.when(
                  data: (user) {
                    final averageRating = getAverageRating(user);
                    final totalReviews = user.reviews!.length;
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 36,
                            width: 36,
                            child: ClipOval(
                              child: Image.network(
                                user.profilePicture ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/icons/dummy_person_small.png');
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${user?.name ?? ''}'),
                              Text('${user.companyName}'),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange),
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
                    return const Center(
                      child: Text('Couldn\'t fetch categories'),
                    );
                  },
                ),
                if (requirement.image != null && requirement.image != '')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        requirement.image!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (requirement.image != null && requirement.image != '')
                  const SizedBox(height: 20),
                // Make only the text content scrollable
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(requirement.content ?? ''),
                ),

                if (id != requirement.author?.id)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return customButton(
                          label: buttonText,
                          onPressed: () async {
                            if (subscription != 'free') {
                              await sendChatMessage(
                                  userId: requirement.author!.id!,
                                  content: requirement.content!,
                                  requirementId: requirement.id);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => IndividualPage(
                                        receiver: receiver,
                                        sender: sender,
                                      )));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => const UpgradeDialog(),
                              );
                            }
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
