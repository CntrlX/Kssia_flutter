import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/services/launch_url.dart';
import 'package:kssia/src/interface/common/block_report.dart';
import 'package:url_launcher/url_launcher.dart';

class AwardCard extends StatelessWidget {
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;

  final Award award;

  const AwardCard(
      {required this.onRemove,
      required this.award,
      super.key,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: SizedBox(
        height: 150.0, // Set the desired fixed height for the card
        width: double.infinity, // Ensure the card width fits the screen
        child: Column(
          mainAxisSize:
              MainAxisSize.max, // Make the column take the full height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Upper part: Image fitted to the card
                Container(
                  height: 90.0, // Adjusted height to fit within the 150px card
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          award.url!), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
                if (onRemove != null)
                  Positioned(
                    top: 4.0,
                    right: 10.0,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropDownMenu(
                            onRemove: onRemove!,
                            onEdit: onEdit!,
                          ),
                        )),
                  ),
              ],
            ),
            // Lower part: Text
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFF2F2F2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              award.name ?? '',
                              style: const TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          award.authorityName ?? '',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;
  final Product product;
  final bool? isOthersProduct;
  final bool? statusNeeded;

  const ProductCard(
      {this.onRemove,
      required this.product,
      super.key,
      this.isOthersProduct,
      this.statusNeeded = false,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: statusNeeded == true ? 105.0 : 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.image!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
              ),
              Container(
                height: statusNeeded == true ? 92 : 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  color: const Color(0xFFF2F2F2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                '₹ ${product.price}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  decoration: product.offerPrice != null
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontSize: 15.0,
                                  color:
                                      const Color.fromARGB(255, 112, 112, 112),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            if (product.offerPrice != null)
                              Flexible(
                                child: Text(
                                  '₹ ${product.offerPrice}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF004797),
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        'MOQ: ${product.moq}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (statusNeeded ?? false)
                        Text(
                          'Status: ${product.status}',
                          style: TextStyle(
                            color: product.status == 'accepted'
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (onRemove != null)
            Positioned(
              top: 4.0,
              right: 10.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropDownMenu(
                    onRemove: onRemove!,
                    onEdit: onEdit!,
                  ),
                ),
              ),
            ),
          if (isOthersProduct ?? false)
            Positioned(
              top: 4.0,
              right: 10.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomDropDown(
                      product: product,
                      isBlocked: false,
                    )),
              ),
            ),
        ],
      ),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;
  final Certificate certificate;

  const CertificateCard({
    required this.onRemove,
    required this.certificate,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color.fromARGB(255, 201, 198, 198)),
        ),
        height: 220.0,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                image: DecorationImage(
                  image: NetworkImage(certificate.url!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          certificate.name ?? '',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (onRemove != null)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropDownMenu(
                              onRemove: onRemove!,
                              onEdit: onEdit!,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BrochureCard extends StatelessWidget {
  final Brochure brochure;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;

  const BrochureCard({
    super.key,
    required this.brochure,
    this.onRemove,
    this.onEdit,
  });

  Future<void> _launchUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 0),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(5),
          ),
          width: double.infinity,
          child: ListTile(
            leading: Icon(
              Icons.picture_as_pdf,
              color: Colors.red,
            ),
            title: Text(brochure.name!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () {
                    String downloadUrl = brochure.url!;
                    _launchUrl(url: downloadUrl);
                  },
                ),
                if (onRemove != null)
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: onRemove,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropDownMenu extends StatelessWidget {
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const DropDownMenu({
    super.key,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.more_vert,
          color: Colors.black,
          size: 22,
        ),
        items: [
          const DropdownMenuItem<String>(
            value: 'remove',
            child: Text(
              'Remove',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
          const DropdownMenuItem<String>(
            value: 'edit',
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
        onChanged: (value) {
          if (value == 'remove') {
            onRemove();
          } else if (value == 'edit') {
            onEdit();
          }
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
