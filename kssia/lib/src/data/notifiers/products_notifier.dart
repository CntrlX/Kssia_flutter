import 'dart:developer';

import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/screens/feed/product_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_notifier.g.dart';

@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  List<Product> products = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;

  @override
  List<Product> build() {
    return [];
  }

  Future<void> fetchMoreProducts() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newProducts = await ref
          .read(fetchProductsProvider(pageNo: pageNo, limit: limit).future);
      products = [...products, ...newProducts];
      pageNo++;
      hasMore = newProducts.length == limit;
      state = products;
    } catch (e, stackTrace) {
      log(e.toString());

      log(stackTrace.toString());
    } finally {
      isLoading = false;
      log('im in people $products');
    }
  }
}