import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/notifiers/products_notifier.dart';

import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/Shimmer/product_card._shimmer.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/filters/product_filter.dart';

import 'dart:async';

import 'package:kssia/src/interface/common/loading.dart';

class ProductView extends ConsumerStatefulWidget {
  const ProductView({
    super.key,
  });

  @override
  ConsumerState<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductView> {
  FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      ref.read(productsNotifierProvider.notifier).fetchMoreProducts();
    });
  }

  // void _onSearchFocusChange() {
  //   if (_searchFocus.hasFocus && !_hasSearched) {
  //     // Display all products when search bar is focused
  //     ref.read(productsNotifierProvider.notifier).fetchMoreProducts();
  //     _hasSearched = true; // Set flag to avoid fetching multiple times
  //   }
  // }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(productsNotifierProvider.notifier).fetchMoreProducts();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(productsNotifierProvider.notifier).searchProducts(query);
    });
  }

  void _onSearchSubmitted(String query) {
    if (query != '')
      ref.read(productsNotifierProvider.notifier).searchProducts(query);
  }

  void _onFilterSaved(String query) {
    // Perform search when search is submitted
    ref.read(productsNotifierProvider.notifier).searchProducts(query,
        category: selectedCategory, subcategory: selectedSubCategory);
  }

  String? selectedCategory;
  String? selectedSubCategory;
  void _showProductDetails(
      {required BuildContext context,
      required Product product,
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
      final notifier = ref.read(productsNotifierProvider.notifier);
      final isLoading = notifier.isLoading;
      final isFirstLoad = notifier.isFirstLoad;

      return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (_searchFocus.hasFocus) {
            _searchFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔍 Search bar + filter
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
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
                          onChanged: _onSearchChanged,
                          onSubmitted: _onSearchSubmitted,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          Map<String, String>? filter =
                              await showModalBottomSheet<Map<String, String>?>(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => ShowProductFilter(),
                          );
                          if (filter != null) {
                            selectedCategory = filter['selectedCategory'];
                            selectedSubCategory = filter['selectedSubCategory'];
                            _onFilterSaved('');
                          }
                        },
                        icon: const Icon(Icons.filter_alt_outlined),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (isFirstLoad)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 212,
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemCount: 6,
                    itemBuilder: (_, __) => const ProductCardShimmer(),
                  )
                else if (products.isNotEmpty)
                  Column(
                    children: [
                     GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    mainAxisExtent: 212,
    crossAxisCount: 2,
    crossAxisSpacing: 0.0,
    mainAxisSpacing: 20.0,
  ),
  itemCount: products.length + (isLoading && !isFirstLoad ? 1 : 0),
  itemBuilder: (context, index) {

    if (index == products.length && isLoading && !isFirstLoad) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: LoadingAnimation(),
        ),
      );
    }

    final asyncProductOwner = ref.watch(
      fetchUserDetailsProvider(token, products[index].sellerId ?? ''),
    );

    return asyncProductOwner.when(
      data: (productOwner) {
        final receiver = Participant(
          name: productOwner.name ?? '',
          id: productOwner.id,
          profilePicture: productOwner.profilePicture,
        );
        return GestureDetector(
          onTap: () => _showProductDetails(
            receiver: receiver,
            sender: Participant(id: id),
            context: context,
            product: products[index],
          ),
          child: ProductCard(
            onEdit: null,
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
      loading: () => const ProductCardShimmer(),
    );
  },
)
,

                      if (isLoading && !isFirstLoad)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: LoadingAnimation()),
                        ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _searchFocus.dispose();
    super.dispose();
  }
}
