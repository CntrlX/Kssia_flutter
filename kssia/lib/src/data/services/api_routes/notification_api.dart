import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/notification_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notification_api.g.dart';



@riverpod
Future<List<NotificationModel>> fetchUnreadNotifications(
    Ref ref, String token) async {
  final url = Uri.parse('$baseUrl/notification/in-app/unread/$id');
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
    List<NotificationModel> unReadNotifications = [];

    for (var item in data) {
      unReadNotifications.add(NotificationModel.fromJson(item));
    }
    print(unReadNotifications);
    return unReadNotifications;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<List<NotificationModel>> fetchreadNotifications(
    FetchreadNotificationsRef ref, String token) async {
  final url = Uri.parse('$baseUrl/notification/in-app/read/$id');
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
    List<NotificationModel> readNotifications = [];

    for (var item in data) {
      readNotifications.add(NotificationModel.fromJson(item));
    }
    print(readNotifications);
    return readNotifications;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
