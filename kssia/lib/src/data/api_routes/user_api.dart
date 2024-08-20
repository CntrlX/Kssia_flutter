import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_api.g.dart';

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
    final String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwidXNlcklkIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.gw7m0eu3gxSoavEQa4aIt48YZVQz_EsuZ0nJDrjXKuI'; // Replace with your Bearer token

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

  Future<void> deleteFile(String token, String fileUrl) async {
    final url = Uri.parse(
        'http://43.205.89.79/api/v1/files/delete/images_20240820_d810d54f6caf3f66e1fe7af93f8ea321.jpeg');
    final response = await http.delete(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Image deleted successfully');
    } else {
      print('Failed to delete image: ${response.statusCode}');
    }
  }

  Future<Product?> uploadProduct(
      String token,
      String name,
      String price,
      String description,
      String moq,
      File productImage,
      String sellerId) async {
    final url = Uri.parse('$baseUrl/products');

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add headers
    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    // Add fields
    request.fields['name'] = name;
    request.fields['price'] = price;
    request.fields['offer_price'] = price;
    request.fields['description'] = description;
    request.fields['moq'] = moq;
    request.fields['seller_id'] = sellerId;

    // Add the image file
    var stream = http.ByteStream(productImage.openRead());
    stream.cast();
    var length = await productImage.length();
    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: basename(productImage.path),
      contentType: MediaType('image', 'png'),
    );

    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Product uploaded successfully');
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      final Product product = Product.fromJson(jsonResponse);

      return product;
    } else {
      print('Failed to upload product: ${response.statusCode}');
      return null;
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

const String baseUrl = 'http://43.205.89.79/api/v1';

@riverpod
Future<User> fetchUserDetails(
    FetchUserDetailsRef ref, String token, String userId) async {
  final url = Uri.parse('$baseUrl/user/$userId');
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
    final dynamic data = json.decode(response.body)['data'];
    print(data);

    return User.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<List<User>> fetchUsers(FetchUsersRef ref, String token) async {
  final url = Uri.parse('$baseUrl/admin/users');
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
    List<User> events = [];

    for (var item in data) {
      events.add(User.fromJson(item));
    }
    print(events);
    return events;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
