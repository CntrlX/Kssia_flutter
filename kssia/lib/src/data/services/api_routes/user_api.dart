import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/payment_year_model.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/subscription_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/models/user_requirement_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minio_flutter/io.dart';
import 'package:minio_flutter/minio.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

part 'user_api.g.dart';

class ApiRoutes {
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

  Future<Map<String, dynamic>> verifyOTP(
      {required String verificationId,
      required String fcmToken,
      required String smsCode,
      required BuildContext context}) async {
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
        log("Verification ID:$verificationId");
        final Map<String, dynamic> tokenMap =
            await verifyUserDB(idToken!, fcmToken, context);
        return tokenMap;
      } else {
        print("User signed in, but no user information was found.");
        return {};
      }
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Wrong OTP');
      print("Failed to sign in: ${e.toString()}");
      return {};
    }
  }

  Future<Map<String, dynamic>> verifyUserDB(
      String idToken, String fcmToken, BuildContext context) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"clientToken": idToken, "fcm": fcmToken}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString());
      CustomSnackbar.showSnackbar(context, responseBody['message']);
      return responseBody['data'];
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString());
      CustomSnackbar.showSnackbar(context, responseBody['message']);
      return {};
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      log(responseBody.toString());
      CustomSnackbar.showSnackbar(context, responseBody['message']);
      return {};
    }
  }

  Future<String> editUser(Map<String, dynamic> profileData) async {
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
      return json.decode(response.body)['message'];
    } else {
      print(json.decode(response.body)['message']);

      print('Failed to update profile. Status code: ${response.statusCode}');
      return json.decode(response.body)['message'];
      // throw Exception('Failed to update profile');
    }
  }

  Future<String> createFileUrl(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    print("Original image size: ${imageBytes.lengthInBytes / 1024} KB");

    // Check if the image is larger than 1 MB
    if (imageBytes.lengthInBytes > 1024 * 1024) {
      img.Image? image = img.decodeImage(imageBytes);
      if (image != null) {
        img.Image resizedImage =
            img.copyResize(image, width: (image.width * 0.5).toInt());
        imageBytes =
            Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
        print("Compressed image size: ${imageBytes.lengthInBytes / 1024} KB");

        // Save compressed image
        imageFile = await File(imagePath).writeAsBytes(imageBytes);
      }
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload'),
    );
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return extractImageUrl(responseBody);
    } else {
      throw Exception('Failed to upload image');
    }
  }

  String extractImageUrl(String responseBody) {
    final responseJson = jsonDecode(responseBody);
    log(name: "image upload response", responseJson.toString());
    return responseJson['data'];
  }

  String removeBaseUrl(String url) {
    String baseUrl = 'https://kssia-s3-bucket.s3.ap-south-1.amazonaws.com/';
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
      CustomSnackbar.showSnackbar(
          context, "'Requirement Deleted Successfully'");
    } else {
      final jsonResponse = json.decode(response.body);
      CustomSnackbar.showSnackbar(context, jsonResponse['message']);
      print(jsonResponse['message']);
      print('Failed to delete image: ${response.statusCode}');
    }
  }

  // Future<void> markNotificationAsRead(String notificationId) async {
  //   final url = Uri.parse(
  //       'http://192.168.1.4:3000/api/v1/notification/in-app/$notificationId/read/$id');

  //   final response = await http.put(
  //     url,
  //     headers: {
  //       'accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     print('Notification marked as read successfully.');
  //   } else {
  //     print(
  //         'Failed to mark notification as read. Status code: ${response.statusCode}');
  //   }
  // }


  Future<void> createReport({
    required BuildContext context,
    required String content,
    required String reportedItemId,
    required String reportType,
  }) async {
    String url = '$baseUrl/report';
    try {
      final Map<String, dynamic> body = {
        'content': content != null && content != '' ? content : ' ',
        'reportType': reportType,
        'reportedItemId': reportedItemId
      };
      log('Report details:$body');
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Include your token if authentication is required
        },
        body: jsonEncode(body),
      );

      // Handle the response
      if (response.statusCode == 201) {
        CustomSnackbar.showSnackbar(context, 'Reported to admin');

        print('Report created successfully');
      } else {
        CustomSnackbar.showSnackbar(context, 'Failed to Report');

        print('Failed to create report: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<String?> uploadRequirement(String token, String author, String content,
      String status, String? image, BuildContext context) async {
    String url = '$baseUrl/requirements';

    // Prepare the request headers
    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Prepare the request body
    final body = jsonEncode({
      'author': author,
      'content': content,
      'status': status,
      if (image != null)
        'image': image, // Include 'image' only if it's not null
    });

    // Send the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      print('Requirement submitted successfully');
      final jsonResponse = json.decode(response.body);
      return jsonResponse['message'];
    } else {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['message']);
      print('Failed to submit requirement: ${response.statusCode}');
      return null;
    }
  }

  Future<String?> uploadPayment(
      {required String amount,
      required String image,
      required String catergory,
      required String parentSub,
      required BuildContext context}) async {
    final url = Uri.parse('$baseUrl/payments/user');

    final body = {
      'category': catergory,
      'receipt': image,
      'amount': amount,
      'parentSub': parentSub,
    };
    log(body.toString());
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('Product uploaded successfully');
        final jsonResponse = json.decode(response.body);
        CustomSnackbar.showSnackbar(context, jsonResponse['message']);
        return jsonResponse['message'];
      } else {
        final jsonResponse = json.decode(response.body);
        CustomSnackbar.showSnackbar(context, jsonResponse['message']);
        print('Failed to upload Payment: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      CustomSnackbar.showSnackbar(
          context, 'Something went wrong. Please try again.');
      return null;
    }
  }

  Future<void> postReview(
      String userId, String content, int rating, context) async {
    final url = Uri.parse('$baseUrl/user/$userId/reviews');
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
        CustomSnackbar.showSnackbar(context, 'Review Posted');
      } else {
        print('Failed to post review: ${response.statusCode}');
        print('Response body: ${response.body}');
        CustomSnackbar.showSnackbar(context, 'Failed to post Review');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> requestNFC(BuildContext context) async {
    final url = Uri.parse('$baseUrl/user/request/nfc');
    log("Requesting URL:${url}");
    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Review posted successfully');
        CustomSnackbar.showSnackbar(
            context, 'NFC requested sucessfully and we will mail you shortly');
      } else {
        print('Response body: ${response.body}');
        CustomSnackbar.showSnackbar(context, 'Failed to request');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> blockUser(
      String userId, String? reason, context, WidgetRef ref) async {
    final String url = '$baseUrl/user/block/$userId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
            {"reason": reason != null && reason != '' ? reason : 'No reason'}),
      );
      final dynamic message = json.decode(response.body)['message'];
      log(message);
      if (response.statusCode == 200) {
        // Success
        // ref.read(userProvider.notifier).refreshUser();
        print('User Blocked successfully');
        CustomSnackbar.showSnackbar(context, 'User Blocked');
      } else {
        // Handle error
        print('Failed to Block: ${response.statusCode}');
        final dynamic message = json.decode(response.body)['message'];
        log(message);
        CustomSnackbar.showSnackbar(context, 'Failed to block');
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
    }
  }

  Future<void> unBlockUser(String userId, context, WidgetRef ref) async {
    final String url = '$baseUrl/user/unblock/$userId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Success\
        // ref.read(userProvider.notifier).refreshUser();
        print('User unBlocked successfully');
        CustomSnackbar.showSnackbar(context, 'User unblocked');
      } else {
        // Handle error
        print('Failed to unBlock: ${response.statusCode}');
        final dynamic message = json.decode(response.body)['message'];
        log(message);
        CustomSnackbar.showSnackbar(context, 'Failed to block');
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
    }
  }

  Future<void> markEventAsRSVP(String eventId, context) async {
    final String url = '$baseUrl/events/rsvp/$eventId/mark';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Success
        print('RSVP marked successfully');
        CustomSnackbar.showSnackbar(context, 'Registered successfully');
      } else {
        // Handle error
        print('Failed to mark RSVP: ${response.statusCode}');
        CustomSnackbar.showSnackbar(context, 'Failed to register');
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
    }
  }
  
Future<UserModel> fetchUserDetails(
   String userId) async {
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
}

@riverpod
Future<List<PaymentYearModel>> getPaymentYears(GetPaymentYearsRef ref) async {
  final url = Uri.parse('$baseUrl/payments/parent-subscription');
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
    List<PaymentYearModel> paymentYears = [];

    for (var item in data) {
      paymentYears.add(PaymentYearModel.fromJson(item));
    }
    print(paymentYears);
    return paymentYears;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
  
}

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
    {int pageNo = 1, int limit = 20, String? query}) async {
  // Construct the base URL
  Uri url = Uri.parse('$baseUrl/admin/users?pageNo=$pageNo&limit=$limit');

  // Append query parameter if provided
  if (query != null && query.isNotEmpty) {
    url = Uri.parse(
        '$baseUrl/admin/users?pageNo=$pageNo&limit=$limit&search=$query');
  }

  final response = await http.get(
    url,
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
  final url = Uri.parse('$baseUrl/events/user/rsvpd');
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

@riverpod
Future<List<Subscription>> getSubscription(GetSubscriptionRef ref) async {
  final String url = '$baseUrl/payments/user/$id';
  log('requesting url:$url');
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      log(response.body);
      List<Subscription> subscriptions = [];

      for (var item in data) {
        subscriptions.add(Subscription.fromJson(item));
      }
      print('subscriptions::::::$subscriptions');

      return subscriptions;
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error in loading subscription details: $e');
    return [];
  }
}
