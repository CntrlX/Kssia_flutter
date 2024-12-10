// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:kssia/src/data/services/save_qr.dart';
// import 'package:kssia/src/interface/common/components/snackbar.dart';
// import 'package:kssia/src/interface/common/custom_button.dart';
// import 'package:kssia/src/interface/screens/menu/subscription_pages/receipt_page.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:screenshot/screenshot.dart';

// class PremiumPlanPage extends StatelessWidget {
//   PremiumPlanPage({super.key});
//   ScreenshotController screenshotController = ScreenshotController();
//   @override
//   Widget build(BuildContext context) {
//     const String textToCopy = 'Bank details: Canara Bank Main Branch\n'
//         'A/c no.: 0720101071990\n'
//         'A/c name: KSSIA\n'
//         'IFS code: CNRB0000720';
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           "Premium Plan",
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
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16.0),
//               const Text(
//                 'PAY NOW',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 53, 52, 52),
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     '₹1000',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 40,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(width: 8.0),
//                   Text(
//                     'per year',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24.0),
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF004797),
//                       Color(0xFF004797),
//                       Color.fromRGBO(66, 104, 147, 0.93),
//                     ],
//                     stops: [0.0, 0.7, 1.0],
//                   ),
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'BANK DETAILS',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             Clipboard.setData(ClipboardData(text: textToCopy));
//                             CustomSnackbar.showSnackbar(
//                                 context, 'Text copied to clipboard');
//                           },
//                           icon: Icon(
//                             Icons.copy,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Bank details: Canara Bank Main Branch\n'
//                       'A/c no.: 0720101071990\n'
//                       'A/c name: KSSIA\n'
//                       'IFS code: CNRB0000720',
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24.0),
//               Center(
//                 child: Column(
//                   children: [
//                     const Text(
//                       'or SCAN',
//                       style: TextStyle(
//                           color: Color.fromARGB(255, 29, 28, 28),
//                           fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 16.0),
//                     // QrImage(
//                     //   data: 'kssia@cnrb',
//                     //   size: 150.0,
//                     // ),
//                     const SizedBox(height: 8.0),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 233, 229, 229),
//                             width: 2.0), // Border color and width
//                         borderRadius:
//                             BorderRadius.circular(16.0), // Curved radius
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(
//                             16.0), // Same radius as the border
//                         child: Screenshot(
//                             controller: screenshotController,
//                             child: Image.asset('assets/payment_qr.png')),
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 50),
//                       child: customButton(
//                           label: 'Download QR Code',
//                           onPressed: () {
//                             saveQr(
//                                 screenshotController: screenshotController,
//                                 context: context);
//                           },
//                           sideColor: Color(0xFFF2F2F7),
//                           buttonColor: Color(0xFFF2F2F7),
//                           labelColor: Color(0xFF333333)),
//                     )
//                   ],
//                 ),
//               ),
//               // const Spacer(),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     child: customButton(
//                         label: 'Next',
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ReceiptPage(),
//                               ));
//                         }),
//                   )),
//               const SizedBox(height: 16.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
