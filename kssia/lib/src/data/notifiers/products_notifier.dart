import 'dart:developer';

import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_notifier.g.dart';

@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  List<Product> products = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;

  String? currentSearchQuery;
  String? currentCategory;
  String? currentSubcategory;

  @override
  List<Product> build() {
    log('ProductsNotifier initialized');
    return [];
  }

  void removeProductsBySeller(String sellerId) {
    log('Removing products by sellerId: $sellerId');
    products = products.where((product) => product.sellerId != sellerId).toList();
    state = products;
    log('Products after removal: ${products.length}');
  }

  Future<void> fetchMoreProducts() async {
    if (isLoading) {
      log('Already loading. Skipping fetchMoreProducts call.');
      return;
    }
    if (!hasMore) {
      log('No more products to fetch.');
      return;
    }

    isLoading = true;
    log('Fetching more products. Page: $pageNo, Limit: $limit');

    try {
      final newProducts = await ref.read(
        fetchProductsProvider(pageNo: pageNo, limit: limit).future,
      );
      log('Fetched ${newProducts.length} products');

      products = [...products, ...newProducts];
      pageNo++;
      hasMore = newProducts.length == limit;
      state = products;
      log('Total products after fetch: ${products.length}');
    } catch (e, stackTrace) {
      log('Error fetching more products: $e', level: 1000);
      log('Stack trace:\n$stackTrace');
    } finally {
      isLoading = false;
    }
  }

  Future<void> searchProducts(
    String query, {
    String? category,
    String? subcategory,
  }) async {
    isLoading = true;
    pageNo = 1;
    products = [];
    currentSearchQuery = query;
    currentCategory = category;
    currentSubcategory = subcategory;

    log('Searching products with: '
        'query="$query", category="$category", subcategory="$subcategory"');

    try {
      final newProducts = await ref.read(
        fetchProductsProvider(
          pageNo: pageNo,
          limit: limit,
          search: query,
          category: category,
          subcategory: subcategory,
        ).future,
      );

      log('Search returned ${newProducts.length} products');

      products = [...newProducts];
      hasMore = newProducts.length == limit;
      state = [...products];

      log('Search completed. Total products: ${products.length}');
    } catch (e, stackTrace) {
      log('Error searching products: $e', level: 1000);
      log('Stack trace:\n$stackTrace');
    } finally {
      isLoading = false;
    }
  }
}
