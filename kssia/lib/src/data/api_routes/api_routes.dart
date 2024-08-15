import 'dart:convert';

import 'package:http/http.dart' as http;
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
