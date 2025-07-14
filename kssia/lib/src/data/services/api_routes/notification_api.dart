import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/notification_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notification_api.g.dart';

class NotificationApiService {
  final String token;

  NotificationApiService({required this.token});

  Future<List<NotificationModel>> fetchUnreadNotifications(
      String userId) async {
    final url = Uri.parse('$baseUrl/notification/in-app/unread/$userId');
    print('Requesting URL: $url');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print('Status: ${json.decode(response.body)['status']}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      print(response.body);
      return data.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<List<NotificationModel>> fetchReadNotifications(String userId) async {
    final url = Uri.parse('$baseUrl/notification/in-app/read/$userId');
    print('Requesting URL: $url');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print('Status: ${json.decode(response.body)['status']}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      print(response.body);
      return data.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }
}

@riverpod
NotificationApiService notificationApiService(Ref ref, String token) {
  return NotificationApiService(token: token);
}

@riverpod
Future<List<NotificationModel>> fetchUnreadNotifications(
  Ref ref,
  String token,
  String userId,
) async {
  final service = ref.watch(notificationApiServiceProvider(token));
  return service.fetchUnreadNotifications(userId);
}

@riverpod
Future<List<NotificationModel>> fetchReadNotifications(
  Ref ref,
  String token,
  String userId,
) async {
  final service = ref.watch(notificationApiServiceProvider(token));
  return service.fetchReadNotifications(userId);
}
