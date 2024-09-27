import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'requirement_api.g.dart';

const String baseUrl = 'https://api.kssiathrissur.com/api/v1';

@riverpod
Future<List<Requirement>> fetchRequirements(FetchRequirementsRef ref,
    {int pageNo = 1, int limit = 10}) async {
  final url = Uri.parse('$baseUrl/requirements?pageNo=$pageNo&limit=$limit');
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
    List<Requirement> events = [];

    for (var item in data) {
      events.add(Requirement.fromJson(item));
    }
    print(events);
    return events;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
