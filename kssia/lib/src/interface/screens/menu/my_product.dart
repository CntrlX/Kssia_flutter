import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/common/upgrade_dialog.dart';

class MyProductPage extends ConsumerStatefulWidget {
  MyProductPage({super.key});

  @override
  ConsumerState<MyProductPage> createState() => _MyProductPageState();
}

class _MyProductPageState extends ConsumerState<MyProductPage> {
  TextEditingController productPriceType = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productMoqController = TextEditingController();
  final TextEditingController productActualPriceController =
      TextEditingController();
  final TextEditingController productOfferPriceController =
      TextEditingController();
  File? _productImageFIle;

  ApiRoutes api = ApiRoutes();

  String productUrl = '';

  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      // Check if the file size is more than or equal to 1 MB (1 MB = 1024 * 1024 bytes)
      // if (result.files.single.size >= 1024 * 1024) {
      //   CustomSnackbar.showSnackbar(context, 'File size cannot exceed 1MB');

      //   return null; // Exit the function if the file is too large
      // }

      // Set the selected file if it's within the size limit and matches the specified image type
      if (imageType == 'product') {
        _productImageFIle = File(result.files.single.path!);
        return _productImageFIle;
      }
    }

    return null;
  }

  // Future<void> _addNewProduct({required List<String> selectedTags}) async {
  //   productUrl =
  //       await api.createFileUrl(file: _productImageFIle!, token: token);
  //   log('product price type:${productPriceType.text}');
  //   final createdProduct = await api.uploadProduct(
  //       token,
  //       productNameController.text,
  //       productActualPriceController.text,
  //       productOfferPriceController.text,
  //       productDescriptionController.text,
  //       productMoqController.text,
  //       productUrl,
  //       productPriceType.text,
  //       selectedTags,
  //       context);
  //   if (createdProduct == null) {
  //     print('couldnt create new product');
  //   } else {
  //     final newProduct = Product(
  //       id: createdProduct.id,
  //       name: productNameController.text,
  //       image: productUrl,
  //       description: productDescriptionController.text,
  //       moq: int.parse(productMoqController.text),
  //       offerPrice: int.parse(productOfferPriceController.text),
  //       price: int.parse(productActualPriceController.text),
  //       sellerId: SellerId(id: id),
  //       status: 'pending',
  //     );
  //     ref.read(userProvider.notifier).updateProduct(
  //         [...?ref.read(userProvider).value?.products, newProduct]);
  //   }
  // }

  void _removeProduct(int index) async {
    api.deleteProduct(ref.read(userProvider).value!.products![index].id ?? '');
    ref
        .read(userProvider.notifier)
        .removeProduct(ref.read(userProvider).value!.products![index]);
  }

  void _openModalSheet({required String sheet}) {
    if (sheet == 'product') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EnterProductsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "My Products",
              style: TextStyle(fontSize: 17),
            ),
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: asyncUser.when(
            loading: () => const Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              return Center(
                child: LoadingAnimation(),
              );
            },
            data: (user) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InfoCard(
                              title: 'Products',
                              count: user.products!.length.toString(),
                            ),
                            // const _InfoCard(title: 'Messages', count: '30'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap:
                                true, // Let GridView take up only as much space as it needs
                            // Disable GridView's internal scrolling
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 212,
                              crossAxisCount: 2,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 20.0,
                            ),
                            itemCount: user.products!.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                  product: user.products![index],
                                  onRemove: () => _removeProduct(index));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 36,
                    right: 16,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        if (subscription == 'premium') {
                          _openModalSheet(sheet: 'product');
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => const UpgradeDialog(),
                          );
                        }
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Add Product',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 27,
                      ),
                      backgroundColor: const Color(0xFF004797),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String count;

  const _InfoCard({
    Key? key,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
