import 'package:flutter/material.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/custom_button.dart';

class ReportMemberModal extends StatefulWidget {
  final String reportType;
  final String reportedItemId;
  const ReportMemberModal(
      {super.key, required this.reportType, required this.reportedItemId});

  @override
  _ReportMemberModalState createState() => _ReportMemberModalState();
}

class _ReportMemberModalState extends State<ReportMemberModal> {
  late Map<String, bool> _reportReasons;

  @override
  void initState() {
    super.initState();
    // Initialize _reportReasons based on reportType
    _reportReasons = _getReportReasons(widget.reportType);
  }

  Map<String, bool> _getReportReasons(String reportType) {
    if (reportType == 'product') {
      return {
        'Counterfeit Product': false,
        'Product Not as Described': false,
        'Faulty or Damaged': false,
        'Spam or Misleading Information': false,
        'Others': false,
      };
    } else if (reportType == 'user') {
      return {
        'Fraud or Scams:': false,
        'Inappropriate Content': false,
        'Spam': false,
        'Fraudulent Seller Activity': false,
        'Harassment or Bullying': false,
        'Others': false,
      };
    } else if (reportType == 'requirement') {
      return {
        'Fake request': false,
        'Inappropriate content': false,
        'Offensive/ illegal requirement': false,
        'Others': false,
      };
    } else {
      return {
        'Abusive': false,
        'false information': false,
        'Others': false,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            'Select your reason?',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          // List of report reasons
          ..._reportReasons.keys.map((reason) => _buildCheckboxOption(reason)),
          const SizedBox(height: 16.0),
          // Submit button
          Center(
            child: SizedBox(
              width: 170,
              child: customButton(
                fontSize: 13,
                label: 'SUBMIT REPORT',
                onPressed: () async {
                  // Handle the selected reasons
                  final selectedReasons = _reportReasons.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();
                  String reasons = selectedReasons.join(', ');
                  ApiRoutes userAPi = ApiRoutes();
                  await userAPi.createReport(
                      reportedItemId: widget.reportedItemId,
                      context: context,
                      content: reasons,
                      reportType: widget.reportType);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 4.0), // Adds spacing between items
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2), // Light grey background
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: CheckboxListTile(
        value: _reportReasons[title],
        onChanged: (bool? value) {
          setState(() {
            _reportReasons[title] = value ?? false;
          });
        },
        title: Text(title),
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        contentPadding:
            EdgeInsets.zero, // Removes default padding from CheckboxListTile
        activeColor:
            const Color(0xFF004797), // Blue color when checkbox is selected
        checkColor: Colors.white, // White check mark color
        // Set border color for the unchecked checkbox
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            width: 2.0,
            color:
                const Color(0xFF004797), // Blue color for the checkbox border
          ),
        ),
      ),
    );
  }
}

void showReportMemberModal(
    {required BuildContext context,
    required String reportType,
    required String reportedItemId}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return ReportMemberModal(
        reportType: reportType,
        reportedItemId: reportedItemId,
      );
    },
  );
}
