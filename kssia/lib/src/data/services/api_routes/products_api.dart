import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'products_api.g.dart';

const String baseUrl = 'https://api.kssiathrissur.com/api/v1';

@riverpod
Future<List<Product>> fetchProducts(FetchProductsRef ref,
    {int pageNo = 1, int limit = 10}) async {
  final url = Uri.parse('$baseUrl/products?pageNo=$pageNo&limit=$limit');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Product> products = [];

    for (var item in data) {
      products.add(Product.fromJson(item));
    }
    print(products);
    return products;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
