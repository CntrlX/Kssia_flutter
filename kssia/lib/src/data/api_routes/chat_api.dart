import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendMessage(String from, String to, String content,
    String attachments, String token) async {
  final url = Uri.parse('http://43.205.89.79/api/v1/chats/send');
  print('Requesting URL: $url');

  var request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] = 'Bearer $token'
    ..headers['accept'] = 'application/json'
    ..fields['from'] = from
    ..fields['to'] = to
    ..fields['content'] = content
    ..fields['attachments'] = attachments;

  final response = await request.send();

  if (response.statusCode == 200) {
    final responseBody = await response.stream.bytesToString();
    print('Response data: $responseBody');
  } else {
    final responseBody = await response.stream.bytesToString();
    print('Error: ${json.decode(responseBody)['message']}');
    throw Exception(json.decode(responseBody)['message']);
  }
}

Future<void> fetchChatThread(String threadId, String token) async {
  final url = Uri.parse('http://43.205.89.79/api/v1/chats/threads/$threadId');
  print('Requesting URL: $url');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Response data: $data');
  } else {
    print('Error: ${json.decode(response.body)['message']}');
    throw Exception(json.decode(response.body)['message']);
  }
}
