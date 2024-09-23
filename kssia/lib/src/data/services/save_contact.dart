import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

Future<void> saveContact(
    {required BuildContext context, required String phone,required String name}) async {
  PermissionStatus permissionStatus = await Permission.contacts.status;
  permissionStatus = await Permission.contacts.request();

  if (!permissionStatus.isGranted) {
    permissionStatus = await Permission.contacts.request();
    if (!permissionStatus.isGranted) {
      // Permission not granted, handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contacts permission is required to save the contact.'),
        ),
      );
      return;
    }
  }

  // Create a new contact
  Contact newContact = Contact(
    givenName: name,
    phones: [Item(label: "mobile", value: phone)],
  );

  // Add the contact
  try {
    await ContactsService.addContact(newContact);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contact saved successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save contact: $e')),
    );
  }
}
