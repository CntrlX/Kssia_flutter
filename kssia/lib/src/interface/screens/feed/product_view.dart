import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/notifiers/products_notifier.dart';

import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';


final searchQueryProvider = StateProvider<String>((ref) => '');

class ProductView extends ConsumerStatefulWidget {
  const ProductView({super.key});

  @override
  ConsumerState<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductView> {
    final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();


    _fetchInitialFeeds();
  }

  Future<void> _fetchInitialFeeds() async {
    await ref.read(productsNotifierProvider.notifier).fetchMoreProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(productsNotifierProvider.notifier).fetchMoreProducts();
    }
  }
  void _showProductDetails({required BuildContext context, required product}) {
    showModalBottomSheet(
      isScrollControlled: true,
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
      final productsAsyncValue = ref.watch(fetchProductsProvider());

      return Scaffold(
        body: productsAsyncValue.when(
          data: (products) {
            final filteredProducts = products.where((product) {
              return product.name!
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) &&
                  product.sellerId!.id != id;
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
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search your Products',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                  if (filteredProducts.isNotEmpty)
                    GridView.builder(controller: _scrollController,
                      shrinkWrap:
                          true, // Let GridView take up only as much space as it needs
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 212,
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.0,
                        mainAxisSpacing: 20.0,
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
                        const SizedBox(height: 100),
                        SvgPicture.asset(
                          'assets/icons/feed_productBag.svg',
                          height: 120,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Search for Products',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      );
    });
  }
}

