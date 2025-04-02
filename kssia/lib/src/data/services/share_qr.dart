import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:path_provider/path_provider.dart'; // For accessing file directories

import 'package:screenshot/screenshot.dart'; // For capturing screenshots
import 'package:share_plus/share_plus.dart'; // For sharing files

Future<void> shareQr(
    {required ScreenshotController screenshotController,
    required BuildContext context}) async {
  try {
    // Capture the screenshot
    Uint8List? screenshotBytes = await screenshotController.capture();

    if (screenshotBytes != null) {
      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/screenshot.png';

      // Save the screenshot as a file
      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(screenshotBytes);

      // Share the image using share_plus
      await Share.shareXFiles([XFile(imagePath)],
          text: 'Check out My profile on KSSIA!');
    }
  } catch (e) {
    CustomSnackbar.showSnackbar(context, 'Error Sharing profile!');
  }
}
