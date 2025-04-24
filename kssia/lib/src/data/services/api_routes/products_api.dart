import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'products_api.g.dart';



@riverpod
Future<List<Product>> fetchProducts(
  FetchProductsRef ref, {
  int pageNo = 1,
  int limit = 10,
  String? search,
  String? category,
  String? subcategory,
}) async {
  // Construct query parameters manually
  String queryString = 'pageNo=$pageNo&limit=$limit';

  if (search != null && search.isNotEmpty) {
    queryString += '&search=$search';
  }
  if (category != null && category.isNotEmpty) {
    queryString += '&category=$category';
    log('Filtering by category: $category');
  }
  if (subcategory != null && subcategory.isNotEmpty) {
    queryString += '&subcategory=$subcategory';
    log('Filtering by subcategory: $subcategory');
  }

  final String url = '$baseUrl/products?$queryString';
  log('Requesting products from URL: $url');

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    log('Received response [${response.statusCode}] for $url');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'];

      log('Decoding ${data.length} products');

      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      final body = json.decode(response.body);
      final errorMsg = body['message'] ?? 'Unknown error';
      log('Failed to fetch products: $errorMsg', level: 1000);
      throw Exception(errorMsg);
    }
  } catch (e, stack) {
    log('Exception occurred while fetching products: $e', level: 1000);
    log('Stack trace:\n$stack');
    throw Exception('Something went wrong while fetching products.');
  }
}

@riverpod
Future<List<ProductCategoryModel>> fetchProductCategories(
  Ref ref,
) async {
  String url = '$baseUrl/products/categories';
  print('Requesting URL: $url');
  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<ProductCategoryModel> products = [];

    for (var item in data) {
      products.add(ProductCategoryModel.fromJson(item));
    }
    print(products);
    return products;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

Future<void> deleteProduct(String productId) async {
  final url = Uri.parse('$baseUrl/products/$productId');
  print('requesting url:$url');
  final response = await http.delete(
    url,
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('product removed successfully');
  } else {
    final jsonResponse = json.decode(response.body);

    print(jsonResponse['message']);
    print('Failed to delete image: ${response.statusCode}');
  }
}

Future<Product?> uploadProduct(
  String token,
  String name,
  String price,
  String offerPrice,
  String description,
  String moq,
  String productImage,
  String productPriceType,
  List<String> selectedSubCategories,
  String selectedCategory,
  context,
) async {
  final url = Uri.parse('$baseUrl/products');

  final body = {
    'name': name,
    'price': price,
    'offer_price': offerPrice,
    'description': description,
    'seller_id': id,
    'moq': moq,
    'category': selectedCategory,
    'subcategory': selectedSubCategories,
    'status': 'pending',
    'units': productPriceType,
    'image': productImage,
  };
  log(body.toString());
  try {
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      print('Product uploaded successfully');
      final jsonResponse = json.decode(response.body);
      final Product product = Product.fromJson(jsonResponse['data']);
      return product;
    } else {
      final jsonResponse = json.decode(response.body);
      CustomSnackbar.showSnackbar(context, jsonResponse['message']);
      print('Failed to upload product: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    CustomSnackbar.showSnackbar(
        context, 'Something went wrong. Please try again.');
    return null;
  }
}

Future<void> updateProduct(Product product) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  } catch (e) {
    throw Exception('Failed to update product: $e');
  }
}
