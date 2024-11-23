import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/promotions_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'promotions_api.g.dart';



@riverpod
Future<List<Promotion>> fetchPromotions(FetchPromotionsRef ref,
    {int pageNo = 1, int limit = 10}) async {
  final url = Uri.parse('$baseUrl/promotions?pageNo=$pageNo&limit=$limit');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Promotion> promotions = [];

    for (var item in data) {
      promotions.add(Promotion.fromJson(item));
    }
    print(promotions);
    return promotions;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
