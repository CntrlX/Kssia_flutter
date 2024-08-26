import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class ProductView extends StatelessWidget {
  const ProductView({super.key});
  void _showProductDetails({required BuildContext context, required product}) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => ProductDetailsModal(
        product: product,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final searchQuery = ref.watch(searchQueryProvider);
      final productsAsyncValue = ref.watch(fetchProductsProvider(token));

      return Scaffold(
        body: productsAsyncValue.when(
          data: (products) {
            final filteredProducts = products.where((product) {
              return product.name!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        onChanged: (query) {
                          ref.read(searchQueryProvider.notifier).state = query;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search your Products',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 16),
                  if (filteredProducts.isNotEmpty)
                    GridView.builder(
                      shrinkWrap:
                          true, // Let GridView take up only as much space as it needs
                      physics:
                          NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 1.0, // Space between columns
                        mainAxisSpacing: 2.0, // Space between rows
                        childAspectRatio: .914, // Aspect ratio for the cards
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showProductDetails(
                              context: context, product: products[index]),
                          child: ProductCard(
                            product: filteredProducts[index],
                            onRemove: null,
                          ),
                        );
                      },
                    )
                  else
                    Column(
                      children: [
                        SizedBox(height: 100),
                        SvgPicture.asset(
                          'assets/icons/feed_productBag.svg',
                          height: 120,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Search for Products',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'that you need',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      );
    });
  }
}

class ProductDetailsModal extends StatelessWidget {
  final Product product;
  const ProductDetailsModal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser =
            ref.watch(fetchUserDetailsProvider(token, product.sellerId!.id!));
        return Material(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(height: 16),
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.network(
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                                fit: BoxFit.cover,
                                'https://placehold.co/600x400/png');
                          },
                          product.image!, // Replace with your image URL
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 16),
                        Text(
                          product.name!,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        product.offerPrice != null
                            ? Text(
                                'INR ${product.offerPrice} / piece',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )
                            : Text(
                                'INR ${product.price} / piece',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                        Text(
                          'MOQ : ${product.moq}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          product.description!,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        asyncUser.when(
                          data: (user) {
                            print(user);
                            return Row(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ClipOval(
                                    child: Image.network(
                                      product.sellerId!.id ??
                                          'https://placehold.co/600x400/png', // Fallback URL if sellerId is null
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                          'https://placehold.co/600x400/png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${user!.name!.firstName} ${user!.name!.middleName} ${user!.name!.lastName}'),
                                    Text('${user!.companyName}'),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.orange),
                                    Text('4.5'),
                                    Text('(24 Reviews)'),
                                  ],
                                )
                              ],
                            );
                          },
                          loading: () => Center(child: LoadingAnimation()),
                          error: (error, stackTrace) {
                            // Handle error state
                            return Center(
                              child: Text('Error loading promotions: $error'),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {},
                            ),
                            SizedBox(width: 16),
                            Text('1,224', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        customButton(
                            label: 'Get Qoute', onPressed: () {}, fontSize: 16)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
