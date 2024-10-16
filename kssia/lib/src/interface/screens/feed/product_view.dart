import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/notifiers/products_notifier.dart';

import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/Shimmer/product_card._shimmer.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/loading.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchfield/searchfield.dart';
import 'dart:async';

class ProductView extends ConsumerStatefulWidget {
  const ProductView({super.key});

  @override
  ConsumerState<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductView> {
  FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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

  void _onSearchChanged(String query) {
    log('im inside search');
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(productsNotifierProvider.notifier)
          .searchProducts(query); // Call the search function
    });
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
      final products = ref.watch(productsNotifierProvider);
      final isLoading = ref.read(productsNotifierProvider.notifier).isLoading;

      return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (_searchFocus.hasFocus) {
            _searchFocus.unfocus();
          }
        },
        child: Scaffold(
            body: SingleChildScrollView(
          controller: _scrollController, // Attach scroll controller here
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SearchField(
                    suggestions: products
                        .map((e) => SearchFieldListItem(e.name.toString(),
                            child: Text(e.name.toString())))
                        .toList(),
                    controller: _searchController,
                    suggestionState: Suggestion.expand,
                    searchInputDecoration: SearchInputDecoration(
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
                    onSubmit: (query) =>
                        _onSearchChanged(query), // Trigger search
                  )),
              const SizedBox(height: 16),
              if (products.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 212,
                    crossAxisCount: 2,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final asyncProductOwner = ref.watch(
                            fetchUserDetailsProvider(
                                token, products[index].sellerId?.id ?? ''));
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
                                  product: products[index]),
                              child: ProductCard(
                                isOthersProduct: true,
                                product: products[index],
                                onRemove: null,
                              ),
                            );
                          },
                          error: (error, stackTrace) {
                            log(error.toString());
                            return const SizedBox();
                          },
                          loading: () {
                            return const ProductCardShimmer();
                          },
                        );
                      },
                    );
                  },
                )
              else
                const Column(
                  children: [
                    SizedBox(height: 100),
                    Text(
                      'No Products Found',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        )),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
