import 'package:kssia/src/interface/common/components/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

Future<void> createPdfAndDownload(ScreenshotController screenshotController, BuildContext context) async {
  try {
    // Check and request storage permissions
    if (await _requestStoragePermission()) {
      // Capture widget as an image
      final image = await screenshotController.capture();

      if (image != null) {
        // Create a PDF document
        final pdf = pw.Document();
        final pdfImage = pw.MemoryImage(image);

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pdfImage),
              ); // Center the captured image in the PDF
            },
          ),
        );

        // Define the root directory path for internal storage
        String rootPath;

        // Access the external storage root directory
        if (Platform.isAndroid) {
          final Directory? externalStorageDir = Directory("/storage/emulated/0/");
          if (externalStorageDir != null) {
            rootPath = externalStorageDir.path;
          } else {
            rootPath = "/storage/emulated/0/";
          }
        } else {
          // For other platforms, default to app-specific directories
          final directory = await getApplicationDocumentsDirectory();
          rootPath = directory.path;
        }

        // Save the PDF to the root storage directory
        final path = '$rootPath/KSSIA_PROFILE.pdf';
        final file = File(path);
        await file.writeAsBytes(await pdf.save());

        CustomSnackbar.showSnackbar(context, 'PDF Saved to $path');
      } else {
        CustomSnackbar.showSnackbar(context, 'Error capturing image');
      }
    } else {
      CustomSnackbar.showSnackbar(context, 'Storage permission denied. Please grant permissions manually.');
    }
  } catch (e) {
    CustomSnackbar.showSnackbar(context, 'Error creating PDF: $e');
  }
}

// Helper function to request storage permissions
Future<bool> _requestStoragePermission() async {
  // Check for platform compatibility
  if (Platform.isAndroid) {
    // Request and check for storage permissions based on Android version
    if (await Permission.storage.isGranted || await Permission.storage.request().isGranted) {
      return true;
    } else if (await Permission.manageExternalStorage.isGranted || await Permission.manageExternalStorage.request().isGranted) {
      return true;
    } else {
      // Return false if neither permission is granted
      return false;
    }
  } else {
    // For iOS or other platforms, assume permission is granted
    return true;
  }
}