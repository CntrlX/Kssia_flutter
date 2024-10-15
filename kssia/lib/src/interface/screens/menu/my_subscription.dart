// import 'dart:developer';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:kssia/src/data/services/api_routes/user_api.dart';
// import 'package:kssia/src/interface/common/customModalsheets.dart';
// import 'package:kssia/src/interface/common/custom_button.dart';
// import 'package:kssia/src/interface/common/loading.dart';

// class MySubscriptionPage extends StatefulWidget {
//   const MySubscriptionPage({super.key});

//   @override
//   State<MySubscriptionPage> createState() => _MySubscriptionPageState();
// }

// class _MySubscriptionPageState extends State<MySubscriptionPage> {
//   TextEditingController remarksController = TextEditingController();
//   File? _paymentImage;
//   ApiRoutes api = ApiRoutes();

//   void _openModalSheet({required String sheet, required subscriptionType}) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return ShowPaymentUploadSheet(
//             subscriptionType: subscriptionType,
//             pickImage: _pickFile,
//             textController: remarksController,
//             imageType: 'payment',
//             paymentImage: _paymentImage,
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final asyncSubDetails = ref.watch(getUserPaymentsProvider);
//         return Scaffold(
//             backgroundColor: Colors.white,
//             resizeToAvoidBottomInset: true,
//             appBar: AppBar(
//               title: Text(
//                 "My Subscription",
//                 style: TextStyle(fontSize: 15),
//               ),
//               backgroundColor: Colors.white,
//               scrolledUnderElevation: 0,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//             body:
//             //  asyncSubDetails.when(
//             //   data: (subscription) {
//             //     if (subscription.isEmpty) {
//             //       return Center(child: Text('No Subscriptions Found'));
//             //     }

//             //     log('Subscription Data: ${subscription.toString()}'); // Log entire subscription data

//             //     // Ensure all values are not null before accessing them
//             //     final category = subscription[0].category ?? '-';
//             //     final renewalDate = subscription[0].renewal != null
//             //         ? DateFormat("d'th' MMMM y")
//             //             .format(subscription[0].renewal!)
//             //         : '-';
//             //     final amount = subscription[0].amount != null
//             //         ? subscription[0].amount.toString()
//             //         : '-';
//             //     final timeDate = subscription[0].time != null
//             //         ? DateFormat("d'th' MMMM y").format(subscription[0].time!)
//             //         : '-';

//                ListView(
//                   children: [
//                     subscriptionCard(
//                       context,
//                       'membership',
//                       'Active',
//                       '-',
//                       '-',
//                       '-',
//                       Colors.green,
//                     ),
//                     subscriptionCard(context, 'app', 'Premium', '-', '-', '-',
//                         Colors.orange),
//                     SizedBox(
//                       height: 30,
//                     )
//                   ],
//                 ));
//               },
//             //   loading: () => const Center(child: LoadingAnimation()),
//             //   error: (error, stackTrace) {
//             //     return Center(
//             //       child: Text(error.toString()),
//             //     );
//             //   },
//             // )
//             );
//       }

//   Widget subscriptionCard(
//       BuildContext context,
//       String subscriptionType,
//       String planStatus,
//       String lastRenewedDate,
//       String amount,
//       String dueDate,
//       Color statusColor) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             border:
//                 Border.all(color: const Color.fromARGB(255, 225, 217, 217))),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 subscriptionType,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Plan',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF616161),
//                     ),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFFFFFFF),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: statusColor),
//                     ),
//                     child: Text(
//                       planStatus,
//                       style: TextStyle(
//                         color: statusColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               detailRow('Last Renewed date', lastRenewedDate),
//               detailRow('Amount to be paid', amount),
//               detailRow(
//                   subscriptionType == 'Membership subscription'
//                       ? 'Due date'
//                       : 'Expiry date',
//                   dueDate),
//               const SizedBox(height: 16),
//               Center(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF004797),
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size.fromHeight(50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                   onPressed: () => _openModalSheet(
//                       sheet: 'payment', subscriptionType: subscriptionType),
//                   child: const Text('UPLOAD RECEIPT'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget detailRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Expanded(
//               child: Text(title,
//                   style: TextStyle(color: Color(0xFF616161), fontSize: 16))),
//           Text(value, style: const TextStyle(fontSize: 16)),
//         ],
//       ),
//     );
//   }

//   Future<File?> _pickFile({required String imageType}) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: [
//         'png',
//         'jpg',
//         'jpeg',
//       ],
//     );

//     if (result != null) {
//       setState(() {
//         _paymentImage = File(result.files.single.path!);
//       });
//       return _paymentImage;
//     } else {
//       return null;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/upgrade_dialog.dart';

class MySubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Subscription",
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon Image Section
                      Image.asset('assets/basic.png'),
                      SizedBox(height: 10),

                      // Plan Title
                      Text(
                        'BASIC PLAN',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 5),

                      // Price Section
                      Text(
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                        '₹0 per month',
                      ),
                      SizedBox(height: 10),

                      // Features List
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 246, 255),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Column(
                          children: [
                            _buildBasicCard('Access to News and updates'),
                            _buildBasicCard('Access to Product search'),
                            _buildBasicCard('Chat with limited members'),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),

                      // Action Button
                      SizedBox(
                          width: double.infinity,
                          child:
                              customButton(label: 'ACTIVE', onPressed: () {})),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon Image Section
                      Image.asset(
                        'assets/premium.png',
                        height: 80,
                      ),
                      SizedBox(height: 10),

                      // Plan Title
                      Text(
                        style: TextStyle(fontWeight: FontWeight.w600),
                        'PREMIUM PLAN',
                      ),
                      SizedBox(height: 5),

                      // Price Section
                      Text(
                        style: TextStyle(fontWeight: FontWeight.w600),
                        '₹499 per month',
                      ),
                      SizedBox(height: 10),

                      // Features List
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 231, 192),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildPremiumCard('Access to news and updates'),
                            _buildPremiumCard('Access to product search'),
                            _buildPremiumCard('Chat with unlimited members'),
                            _buildPremiumCard(
                                'Access to add products and requirements'),
                            _buildPremiumCard(
                                'Register to attend exciting events'),
                            _buildPremiumCard('Access to report and block'),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),

                      // Subscribe Button
                      SizedBox(
                          width: double.infinity,
                          child: customButton(
                            buttonHeight: 40,
                            sideColor: Color(0xFFF76412),
                            buttonColor: Color(0xFFF76412),
                            label: 'SUBSCRIBE',
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => const UpgradeDialog(),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBasicCard(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF004797), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.orange, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
            ),
          ),
        ],
      ),
    );
  }
}
