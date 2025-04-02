import 'dart:math';

import 'package:contact_add/contact.dart';
import 'package:contact_add/contact_add.dart';
import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';

Future<void> saveContact(
    {required String number,
   required String name,required String email,
    required BuildContext context}) async {


    final Contact contact = Contact(
        firstname: name,

        phone: number,
        email: email);

    final bool success = await ContactAdd.addContact(contact);

    if (success) {
      CustomSnackbar.showSnackbar(context, 'Contact saved successfully!');
    } else {
      CustomSnackbar.showSnackbar(context, 'Contact saving failed!');
    }
 
}
