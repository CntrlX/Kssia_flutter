// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:kssia/src/data/services/launch_url.dart';
// import 'package:kssia/src/interface/common/custom_button.dart';

// class ReceiptPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Receipt",
//           style: TextStyle(fontSize: 17),
//         ),
//         backgroundColor: Colors.white,
//         scrolledUnderElevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "*Please send us your receipt within 24:00 hrs.",
//               style: TextStyle(
//                 color: Colors.red,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//                 // boxShadow: [
//                 //   BoxShadow(
//                 //     color: Colors.black12,
//                 //     blurRadius: 4,
//                 //     offset: Offset(0, 2),
//                 //   ),
//                 // ],
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   launchURL('https://wa.me/+918078955514');
//                 },
//                 child: const Padding(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                   child: Row(
//                     children: [
//                       Icon(
//                         FontAwesomeIcons.whatsapp,
//                         color: Colors.green,
//                         size: 30,
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(left: 8.0),
//                               child: Text(
//                                 "Send your payment receipt via KSSIA's Whatsapp link here",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Padding(
//                               padding: EdgeInsets.only(left: 8.0),
//                               child: Text(
//                                 "(Receipt format: PNG, JPG, or PDF)",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 16,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             RichText(
//               text: const TextSpan(
//                 text: "*Note: ",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 children: [
//                   TextSpan(
//                     text:
//                         "Your plan will be updated by our team in the next 24 hours, we will contact you upon payment confirmation",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Spacer()
//             // customButton(label: , onPressed: onPressed)
//           ],
//         ),
//       ),
//     );
//   }
// }
