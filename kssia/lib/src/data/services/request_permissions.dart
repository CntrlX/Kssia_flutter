import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      log('storage permission  granted');
    } else {
      log('storage permission not granted');
    }
  }