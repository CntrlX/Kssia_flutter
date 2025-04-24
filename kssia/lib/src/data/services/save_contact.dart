import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';

Future<void> saveContact({
  required String number,
  required String name,
  required String email,
  String? imageUrl,
  required BuildContext context,
}) async {
  if (!await FlutterContacts.requestPermission()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Permission to access contacts denied')),
    );
    return;
  }
  Uint8List? photoBytes;

  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        photoBytes = response.bodyBytes;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading image: $e')),
      );
      return;
    }
  }

  final contact = Contact()
    ..name.first = name
    ..phones = [Phone(number)]
    ..emails = [Email(email)]
    ..photo = photoBytes;

  await contact.insert();
  CustomSnackbar.showSnackbar(context, 'Contact Saved Successfully');
}
