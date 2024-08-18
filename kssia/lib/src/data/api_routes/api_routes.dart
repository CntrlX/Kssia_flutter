import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kssia/src/data/globals.dart';

class ApiRoutes {
  final String baseUrl = 'http://43.205.89.79/api/v1/';
  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/sendOtp/$mobile'),
      headers: {"Content-Type": "application/json"},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> verifyUser(String mobile, String otp) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/login/$mobile'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"otp": otp}),
    );
    return _handleResponse(response);
  }

  Future<void> editUser(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/user/edit/$id');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred');
    }
  }



Future<dynamic> createFileUrl({required File file}) async {
  final url = Uri.parse('http://43.205.89.79/api/v1/files/upload');
  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwidXNlcklkIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.gw7m0eu3gxSoavEQa4aIt48YZVQz_EsuZ0nJDrjXKuI'; // Replace with your Bearer token

  // Determine MIME type
  String fileName = file.path.split('/').last;
  String? mimeType;
  if (fileName.endsWith('.png')) {
    mimeType = 'image/png';
  } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
    mimeType = 'image/jpeg';
  } else if (fileName.endsWith('.pdf')) {
    mimeType = 'application/pdf';
  } else {
    return null; // Return null if the file type is unsupported
  }

  // Create multipart request
  final request = http.MultipartRequest('PUT', url)
    ..headers['Authorization'] = 'Bearer $token'
    ..headers['accept'] = 'application/json'
    ..headers['Content-Type'] = 'multipart/form-data'
    ..files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType.parse(mimeType),
    ));

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      return jsonResponse['data']; // Return the data part of the response
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Error Response Body: $responseBody');
      return null; // Return null or an error message
    }
  } catch (e) {
    print(e);
    return null; // Return null or an error message in case of an exception
  }
}


  Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(responseBody['message']);
      return {"status": true, "data": responseBody};
    } else {
      print(responseBody['message']);
      return {
        "status": false,
        "message": responseBody['message'] ?? 'Unknown error'
      };
    }
  }
}
