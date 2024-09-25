import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

Future<void> saveScreenshot(Uint8List? imageBytes, BuildContext context) async {
  bool isAndroid10OrHigher = Platform.isAndroid && (await _getSdkInt() >= 29);

  if (!isAndroid10OrHigher) {
    // Request storage permission for Android versions below 10
    if (!(await Permission.storage.request().isGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Storage permission denied')),
      );
      return;
    }
  }

  if (imageBytes != null) {
    // Access the public external storage directory
    String directoryPath;
    if (isAndroid10OrHigher) {
      directoryPath = '/storage/emulated/0'; // Root of the internal storage
    } else {
      Directory? directory = await getExternalStorageDirectory();
      directoryPath = directory?.path ?? '/storage/emulated/0'; // Fallback
    }

    // Save the image directly in the internal storage
    final imagePath =
        '$directoryPath/KSSIA_QR${DateTime.now().millisecondsSinceEpoch}.png';

    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageBytes);

    // Notify the user about the saved screenshot
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Screenshot saved to $imagePath')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Failed to capture screenshot')),
    );
  }
}

Future<int> _getSdkInt() async {
  var version = await Process.run('getprop', ['ro.build.version.sdk']);
  return int.parse(version.stdout.trim());
}

// Future<void> captureAndShareScreenshot(Uint8List? screenshot) async {
//   log('im inside share');
//   try {
//     // Capture the screenshot as an image
//     ;
//     log(screenshot.toString());
//     if (screenshot != null) {
//       // Save the screenshot to a temporary directory
//       await Share.files(
//         'kssia image',
//         {'kssia_qr.png': screenshot},
//         {'*/*'},
//       );
//     } else {}
//   } catch (e) {
//     log('Error capturing screenshot: $e');
//   }
// }
