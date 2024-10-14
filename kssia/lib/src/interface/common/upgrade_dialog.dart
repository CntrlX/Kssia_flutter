import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/custom_button.dart';

class UpgradeDialog extends StatelessWidget {
  const UpgradeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Arrow Image
            Image.asset(
              'assets/upgrade.png', // Placeholder arrow image
              height: 80,
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              'Upgrade required !',
            ),
            const SizedBox(height: 8),

            // Subtitle
            SizedBox(
              child: Text(
                'Please upgrade to premium to access this feature',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customButton(
                      labelColor: Colors.black,
                      sideColor: Color(0xFFF2F2F7),
                      buttonColor: Color(0xFFF2F2F7),
                      label: 'Cancel',
                      onPressed: () {}),
                )),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customButton(label: 'Upgrade', onPressed: () {}),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build buttons
  Widget _buildDialogButton(
    BuildContext context,
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
      ),
    );
  }
}
