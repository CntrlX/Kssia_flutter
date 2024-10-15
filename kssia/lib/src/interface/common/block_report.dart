import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/msg_model.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:kssia/src/data/notifiers/products_notifier.dart';
import 'package:kssia/src/data/notifiers/requirements_notifier.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/customdialog.dart';


class CustomDropDown extends ConsumerWidget {
  final Requirement? requirement;
  final Product? product;
  final MessageModel? msg;
  final String? userId;
  final VoidCallback? onBlockStatusChanged;
  final bool? isBlocked;

  const CustomDropDown({
    this.onBlockStatusChanged,
    this.product,
    this.userId,
    this.msg,
    super.key,
    this.requirement,
    this.isBlocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ApiRoutes userApi = ApiRoutes();

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(Icons.more_vert), // Trigger icon
        items: [
          const DropdownMenuItem(
            value: 'report',
            child: Text(
              'Report',
              style: TextStyle(color: Colors.red),
            ),
          ),
          DropdownMenuItem(
            value: 'block',
            child: isBlocked != null && !isBlocked!
                ? const Text('Block', style: TextStyle(color: Colors.red))
                : const Text('Unblock', style: TextStyle(color: Colors.red)),
          ),
        ],
        onChanged: (value) async {
          if (value == 'report') {
            _handleReport(context);
          } else if (value == 'block') {
            await _handleBlock(context, ref);
          }
        },
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: 180,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          offset: const Offset(0, 0),
        ),
      ),
    );
  }

  void _handleReport(BuildContext context) {
    String reportType = '';
    if (requirement != null) {
      reportType = 'requirement';
      showReportPersonDialog(
        reportedItemId: requirement?.id ?? '',
        context: context,
        onReportStatusChanged: () {},
        reportType: reportType,
      );
    } else if (product != null) {
      log('product id: ${product?.id ?? ''}');
      reportType = 'product';
      showReportPersonDialog(
        reportedItemId: product?.id ?? '',
        context: context,
        onReportStatusChanged: () {},
        reportType: reportType,
      );
    } else if (userId != null) {
      log(userId.toString());
      reportType = 'user';
      showReportPersonDialog(
        reportedItemId: userId ?? '',
        context: context,
        userId: userId ?? '',
        onReportStatusChanged: () {},
        reportType: reportType,
      );
    } else {
      reportType = 'chat';
      showReportPersonDialog(
        reportedItemId: msg?.id ?? '',
        context: context,
        onReportStatusChanged: () {},
        reportType: reportType,
      );
    }
  }

  Future<void> _handleBlock(BuildContext context, WidgetRef ref) async {
    if (requirement != null) {
      showBlockPersonDialog(
        context: context,
        userId: requirement?.author?.id ?? '',
        onBlockStatusChanged: () {
          if (context.mounted) {
            ref
                .read(requirementsNotifierProvider.notifier)
                .removeRequirementsByAuthor(requirement!.author?.id ?? '');
          }
        },
      );
    } else if (product != null) {
      log('product id in block report widget: ${product?.id ?? ''}');
      showBlockPersonDialog(
        context: context,
        userId: product?.sellerId?.id ?? '',
        onBlockStatusChanged: () {
          if (context.mounted) {
            ref.invalidate(productsNotifierProvider);
          }
        },
      );
    } else if (userId != null) {
      showBlockPersonDialog(
        context: context,
        userId: userId ?? '',
        onBlockStatusChanged: () {
          if (onBlockStatusChanged != null) {
            onBlockStatusChanged!(); // Properly invoke the callback
          }
        },
      );
    }
  }
}
