import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/models/user_requirement_model.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_api.g.dart';

class ApiRoutes {
  final String baseUrl = 'http://43.205.89.79/api/v1';
  Future<Map<String, String>> submitPhoneNumber(
      String countryCode, BuildContext context, String phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Completer<String> verificationIdcompleter = Completer<String>();
    Completer<String> resendTokencompleter = Completer<String>();
    log('phone:+$countryCode$phone');
    await auth.verifyPhoneNumber(
      phoneNumber: '+$countryCode$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Handle automatic verification completion if needed
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message.toString());
        verificationIdcompleter.complete(''); // Verification failed
        resendTokencompleter.complete('');
      },
      codeSent: (String verificationId, int? resendToken) {
        log(verificationId);

        verificationIdcompleter.complete(verificationId);
        resendTokencompleter.complete(resendToken.toString());
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        if (!verificationIdcompleter.isCompleted) {
          verificationIdcompleter.complete(''); // Timeout without sending code
        }
      },
    );

    return {
      "verificationId": await verificationIdcompleter.future,
      "resendToken": await resendTokencompleter.future
    };
  }

  void resendOTP(
      String phoneNumber, String verificationId, String resendToken) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      forceResendingToken: int.parse(resendToken),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto-retrieval or instant verification
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error
        print("Resend verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        resendToken = resendToken;
        print("Resend verification Sucess");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
      },
    );
  }

  Future<String> verifyOTP(
      {required String verificationId,
      required String fcmToken,
      required String smsCode}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        String? idToken = await user.getIdToken();
        log("ID Token: $idToken");
        log("fcm token:$fcmToken");
        final token = await verifyUserDB(idToken!, fcmToken, context);
        return token;
      } else {
        print("User signed in, but no user information was found.");
        return '';
      }
    } catch (e) {
      print("Failed to sign in: ${e.toString()}");
      return '';
    }
  }

  Future<String> verifyUserDB(String idToken, String fcmToken, context) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"clientToken": idToken, "fcm": fcmToken}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString());

      return responseBody['data'];
    } else if (response.statusCode == 400) {
      return '';
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString());
      return '';
    }
  }

  Future<void> editUser(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/user/edit/$id');

    final response = await http.put(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profileData),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
      print(json.decode(response.body)['message']);
    } else {
      print(json.decode(response.body)['message']);
      print('Failed to update profile. Status code: ${response.statusCode}');
      throw Exception('Failed to update profile');
    }
  }

  Future<dynamic> createFileUrl({required File file, required token}) async {
    final url = Uri.parse('$baseUrl/files/upload');

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

  String removeBaseUrl(String url) {
    String baseUrl = 'https://kssia.s3.ap-south-1.amazonaws.com/';
    return url.replaceFirst(baseUrl, '');
  }

  Future<void> deleteFile(String token, String fileUrl) async {
    final reqfileUrl = removeBaseUrl(fileUrl);
    print(reqfileUrl);
    final url = Uri.parse('$baseUrl/files/delete/$reqfileUrl');
    print('requesting url:$url');
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Image deleted successfully');
    } else {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['message']);
      print('Failed to delete image: ${response.statusCode}');
    }
  }

  Future<void> deleteRequirement(
      String token, String requirementId, context) async {
    final url = Uri.parse('$baseUrl/requirements/$requirementId');
    print('requesting url:$url');
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Requirement Deleted Successfully')));
    } else {
      final jsonResponse = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
      print(jsonResponse['message']);
      print('Failed to delete image: ${response.statusCode}');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final url = Uri.parse(
        'http://43.205.89.79/api/v1/notification/in-app/$notificationId/read/$id');

    final response = await http.put(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Notification marked as read successfully.');
    } else {
      print(
          'Failed to mark notification as read. Status code: ${response.statusCode}');
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
    request.fields['status'] = false.toString();
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

    if (response.statusCode == 201) {
      print('Product uploaded successfully');
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      print(jsonResponse['message']);
      final Product product = Product.fromJson(jsonResponse['data']);

      return product;
    } else {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      print(jsonResponse['message']);
      print('Failed to upload product: ${response.statusCode}');
      return null;
    }
  }

  // Map<String, dynamic> _handleResponse(http.Response response) {
  //   final Map<String, dynamic> responseBody = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     print(responseBody['message']);
  //     print(responseBody['data']);
  //     return {"status": true, "data": responseBody};
  //   } else {
  //     print(responseBody['message']);

  //     return {
  //       "status": false,
  //       "message": responseBody['message'] ?? 'Unknown error'
  //     };
  //   }
  // }

  Future<String?> uploadRequirement(
    String token,
    String author,
    String content,
    String status,
    File file,
  ) async {
    const String url = 'http://43.205.89.79/api/v1/requirements';

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    // Add fields
    request.fields['author'] = author;
    request.fields['content'] = content;
    request.fields['status'] = status;

    // Add the file
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(file.path),
      contentType: MediaType('image', 'png'),
    );

    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    if (response.statusCode == 201) {
      print('Requirement submitted successfully');
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      return jsonResponse['message'];
    } else {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      print(jsonResponse['message']);
      print('Failed to submit requirement: ${response.statusCode}');
      return null;
    }
  }

  Future<String?> uploadPayment(
    String token,
    String category,
    String remarks,
    File file,
  ) async {
    const String url = 'http://43.205.89.79/api/v1/payments/user';

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    // Add fields
    request.fields['category'] = category;
    request.fields['remarks'] = remarks;

    // Add the file
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(file.path),
      contentType: MediaType('image', 'png'),
    );

    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    if (response.statusCode == 201) {
      print('Payment submitted successfully');
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      return jsonResponse['message'];
    } else {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      print(jsonResponse['message']);
      print('Failed to submit Payment: ${response.statusCode}');
      return 'Failed';
    }
  }

  Future<void> postReview(
      String userId, String content, int rating, context) async {
    final url = Uri.parse('http://43.205.89.79/api/v1/user/$userId/reviews');
    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'reviewer': id,
      'content': content,
      'rating': rating,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Review posted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review posted successfully')));
      } else {
        print('Failed to post review: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to post review')));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> blockUser(String userId, String reason, context) async {
    final String url = 'http://43.205.89.79/api/v1/user/block/$userId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"reason": reason}),
      );

      if (response.statusCode == 200) {
        // Success
        print('User Blocked successfully');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User Blocked ')));
      } else {
        // Handle error
        print('Failed to Block: ${response.statusCode}');
        final dynamic message = json.decode(response.body)['message'];
        log(message);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to Block')));
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
    }
  }

  Future<void> unBlockUser(String userId, String reason, context) async {
    final String url = 'http://43.205.89.79/api/v1/user/unblock/$userId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Success
        print('User unBlocked successfully');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User unblocked ')));
      } else {
        // Handle error
        print('Failed to Block: ${response.statusCode}');
        final dynamic message = json.decode(response.body)['message'];
        log(message);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to unblock')));
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
    }
  }
}

Future<void> markEventAsRSVP(String eventId, context) async {
  final String url = 'http://43.205.89.79/api/v1/events/rsvp/$eventId/mark';
  final String bearerToken = '$token';

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      // Success
      print('RSVP marked successfully');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registered sucessfully successfully')));
    } else {
      // Handle error
      print('Failed to mark RSVP: ${response.statusCode}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to Register')));
    }
  } catch (e) {
    // Handle exceptions
    print('An error occurred: $e');
  }
}

const String baseUrl = 'http://43.205.89.79/api/v1';

@riverpod
Future<UserModel> fetchUserDetails(
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
  log('hello');
  log(response.body);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];
    print(data['products']);

    return UserModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<List<UserModel>> fetchUsers(FetchUsersRef ref,
    {int pageNo = 1, int limit = 20}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/admin/users?pageNo=$pageNo&limit=$limit'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final usersJson = data['data'] as List<dynamic>? ?? [];

    return usersJson.map((user) => UserModel.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load users');
  }
}

@riverpod
Future<List<UserRequirementModel>> fetchUserRequirements(
    FetchUserRequirementsRef ref, String token) async {
  final url = Uri.parse('$baseUrl/requirements/$id');
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
    List<UserRequirementModel> userRequirements = [];

    for (var item in data) {
      userRequirements.add(UserRequirementModel.fromJson(item));
    }
    print(userRequirements);
    return userRequirements;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<List<Event>> fetchUserRsvpdEvents(
  FetchUserRsvpdEventsRef ref,
) async {
  final url = Uri.parse('http://43.205.89.79/api/v1/events/user/rsvpd');
  print(token);
  final headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer $token'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Successfully received response
      final List<dynamic> data = json.decode(response.body)['data'];
      print(response.body);

      List<Event> registeredEvents = [];
      for (var item in data) {
        registeredEvents.add(Event.fromJson(item));
      }
      return registeredEvents;
    } else {
      // Handle error response
      print('Request failed with status: ${response.statusCode}');
      return [];
    }
  } catch (error) {
    print('Error occurred: $error');
    return [];
  }
}
