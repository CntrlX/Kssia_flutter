

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/news_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'news_api.g.dart';
const String baseUrl = 'http://43.205.89.79/api/v1/api-docs/';

@riverpod
Future<List<News>> fetchNews(FetchNewsRef ref) async {
  final url = Uri.parse('$baseUrl/chargingStations/list');
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
    final List<dynamic> data = json.decode(response.body)['result'];
    List<News> news = [];

    for (var item in data) {
      news.add(News.fromJson(item));
    }
    print(news);
    return news;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}