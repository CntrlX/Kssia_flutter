import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/api_routes/transactions_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/main_page.dart';

class MembershipSubscription extends StatefulWidget {
  const MembershipSubscription({super.key});

  @override
  State<MembershipSubscription> createState() => _MembershipSubscriptionState();
}

class _MembershipSubscriptionState extends State<MembershipSubscription> {
  TextEditingController remarksController = TextEditingController();

  File? _paymentImage;

  ApiRoutes api = ApiRoutes();

  void _openModalSheet({required String sheet, required subscriptionType}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ShowPaymentUploadSheet(
            subscriptionType: subscriptionType,
            pickImage: _pickFile,
            textController: remarksController,
            imageType: 'payment',
            paymentImage: _paymentImage,
          );
        });
  }

  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
      ],
    );

    if (result != null) {
      setState(() {
        _paymentImage = File(result.files.single.path!);
      });
      return _paymentImage;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncTransactions = ref.watch(fetchTransactionsProvider(token));
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(fetchTransactionsProvider),
          child: Scaffold(
              body: asyncTransactions.when(
            data: (transactions) {
              String membershipFormattedRenewalDate = transactions[0].renewal ==
                      null
                  ? ''
                  : DateFormat('dd MMMM yyyy').format(transactions[0].renewal!);
              String membershipFormattedRenewedDate =
                  transactions[0].renewal == null
                      ? ''
                      : DateFormat('dd MMMM yyyy')
                          .format(transactions[0].time ?? DateTime.parse(''));
              if (transactions.isEmpty ||
                  transactions[0].status != 'accepted') {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 20),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              const BoxShadow(
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
                              const SizedBox(height: 10),

                              // Plan Title
                              const Text(
                                'Membership Fee',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 5),

                              // Price Section
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600),
                                    '₹2000  ',
                                  ),
                                  Text(
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                    'per year',
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 218, 206, 206)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Membership status:',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: transactions[0].status ==
                                                        'accepted'
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              transactions.isNotEmpty &&
                                                      transactions[0].status ==
                                                          'accepted'
                                                  ? 'Active'
                                                  : 'Inactive',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    transactions.isNotEmpty &&
                                                            transactions[0]
                                                                    .status ==
                                                                'accepted'
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Last renewed on:',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          const Spacer(),
                                          Text(
                                            membershipFormattedRenewedDate,
                                            style: const TextStyle(
                                              decorationColor:
                                                  Color(0xFF004797),
                                              decoration: TextDecoration
                                                  .underline, // Adds underline
                                              fontStyle: FontStyle
                                                  .italic, // Makes text italic
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF004797),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Next renewal on:',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          const Spacer(),
                                          Text(
                                            membershipFormattedRenewalDate,
                                            style: const TextStyle(
                                              decorationColor:
                                                  Color(0xFF004797),
                                              decoration: TextDecoration
                                                  .underline, // Adds underline
                                              fontStyle: FontStyle
                                                  .italic, // Makes text italic
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF004797),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Features List
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 233, 246, 255),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Column(
                                  children: [
                                    _buildBasicCard(
                                        'Access to News and updates'),
                                    _buildBasicCard('Access to Product search'),
                                    _buildBasicCard('Access to Feeds'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Action Button
                              SizedBox(
                                  width: double.infinity,
                                  child: customButton(
                                      sideColor: transactions.isNotEmpty &&
                                              transactions[0].status ==
                                                  'accepted'
                                          ? Colors.green
                                          : Colors.red,
                                      buttonColor: transactions.isNotEmpty &&
                                              transactions[0].status ==
                                                  'accepted'
                                          ? Colors.green
                                          : Colors.red,
                                      label:
                                          transactions[0].status == 'accepted'
                                              ? 'ACTIVE'
                                              : 'INACTIVE',
                                      onPressed: () {
                                        if (transactions.isNotEmpty &&
                                            transactions[0].status !=
                                                'accepted') {
                                          _openModalSheet(
                                              sheet: 'payment',
                                              subscriptionType: 'membership');
                                        }
                                      })),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ));
              }
            },
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              // Handle error state
              return Center(
                child: Text(''),
              );
            },
          )),
        );
      },
    );
  }

  Widget _buildBasicCard(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF004797), size: 18),
          const SizedBox(width: 10),
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
