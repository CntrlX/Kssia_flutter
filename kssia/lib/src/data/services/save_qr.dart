import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart'; // Optional, for saving with gallery indexing
import 'package:mime/mime.dart'; // To identify the file type

Future<void> saveScreenshot(Uint8List? imageBytes, BuildContext context) async {
  bool isAndroid10OrHigher = Platform.isAndroid && (await _getSdkInt() >= 29);

  // Request appropriate storage permissions based on the SDK version
  if (isAndroid10OrHigher) {
    if (!(await Permission.manageExternalStorage.request().isGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Manage External Storage permission denied')),
      );
      return;
    }
  } else {
    if (!(await Permission.storage.request().isGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
      return;
    }
  }

  if (imageBytes != null) {
    String directoryPath = '/storage/emulated/0';

    final imagePath =
        '$directoryPath/KSSIA_QR${DateTime.now().millisecondsSinceEpoch}.png';
    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageBytes);

    // Notify the user about the saved screenshot
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Screenshot saved to $imagePath')),
    );

    // Add image to gallery using ImageGallerySaver
    await _addImageToGallery(imagePath);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to capture screenshot')),
    );
  }
}

// Function to add image to gallery using ImageGallerySaver
Future<void> _addImageToGallery(String filePath) async {
  final result = await ImageGallerySaver.saveFile(filePath);
  if (result['isSuccess']) {
    debugPrint("Image successfully added to gallery.");
  } else {
    debugPrint("Failed to add image to gallery.");
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
