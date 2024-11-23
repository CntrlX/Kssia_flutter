import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/globals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_api.g.dart';

@riverpod
Future<void> fetchStatus(FetchStatusRef ref) async {
  final url = Uri.parse('$baseUrl/user/get/subscription');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  log('hello');
  log(response.body);
  if (response.statusCode == 200) {
    final String data = json.decode(response.body)['data'];
    log(data);
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('subscription', data);

    subscription = data;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
