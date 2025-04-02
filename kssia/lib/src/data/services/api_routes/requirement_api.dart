import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'requirement_api.g.dart';

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
    print(data);
    List<Requirement> requirements = [];

    for (var item in data) {
      requirements.add(Requirement.fromJson(item));
    }
    print(requirements);
    return requirements;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
