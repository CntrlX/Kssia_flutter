import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/notifiers/products_notifier.dart';

import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/loading.dart';

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
    _scrollController.addListener(_onScroll);
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

  void _showProductDetails(
      {required BuildContext context,
      required product,
      required Participant sender,
      required Participant receiver}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => ProductDetailsModal(
        receiver: receiver,
        sender: sender,
        product: product,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final searchQuery = ref.watch(searchQueryProvider);
      final products = ref.watch(productsNotifierProvider);
      final isLoading = ref.read(productsNotifierProvider.notifier).isLoading;
      final filteredProducts = products.where((product) {
        return product.name!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) &&
            product.sellerId!.id != id;
      }).toList();
      if (!isLoading) {
        return Scaffold(
            body: SingleChildScrollView(
          controller: _scrollController, // Attach scroll controller here
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
                      filled: true,
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
                GridView.builder(
                  shrinkWrap:
                      true, // Let GridView take up only as much space as it needs
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 212,
                    crossAxisCount: 2,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final asyncProductOwner = ref.watch(
                            fetchUserDetailsProvider(token,
                                filteredProducts[index].sellerId?.id ?? ''));
                        return asyncProductOwner.when(
                          data: (productOwner) {
                            final receiver = Participant(
                                firstName: productOwner.name?.firstName ?? '',
                                middleName: productOwner.name?.middleName ?? '',
                                lastName: productOwner.name?.lastName ?? '',
                                id: productOwner.id,
                                profilePicture: productOwner.profilePicture);
                            return GestureDetector(
                              onTap: () => _showProductDetails(
                                  receiver: receiver,
                                  sender: Participant(id: id),
                                  context: context,
                                  product: filteredProducts[index]),
                              child: ProductCard(
                                isOthersProduct: true,
                                product: filteredProducts[index],
                                onRemove: null,
                              ),
                            );
                          },
                          error: (error, stackTrace) {
                            log(error.toString());
                            return SizedBox();
                          },
                          loading: () {
                            return LoadingAnimation();
                          },
                        );
                      },
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'that you need',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        ));
      } else {
        return LoadingAnimation();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
