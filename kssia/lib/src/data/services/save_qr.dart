import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:screenshot/screenshot.dart';

Future<void> saveQr(
    {required ScreenshotController screenshotController,
    required BuildContext context}) async {
  screenshotController.capture().then((Uint8List? image) async {
    log('captured image$image');
    if (image != null) {
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(image),
        quality: 100,
        name: "screenshot_${DateTime.now().millisecondsSinceEpoch}",
      );
      print(result);
      CustomSnackbar.showSnackbar(context, 'Downloaded to gallery!');
    }
  }).catchError((onError) {
    print(onError);
    CustomSnackbar.showSnackbar(context, 'Error Saving to gallery!');
  });
}
