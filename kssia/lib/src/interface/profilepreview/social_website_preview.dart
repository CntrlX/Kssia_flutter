import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/services/launch_url.dart';
import 'package:kssia/src/interface/common/components/svg_icon.dart';

final List<String> svgIcons = [
  'assets/icons/instagram.svg',
  'assets/icons/linkedin.svg',
  'assets/icons/twitter.svg',
  'assets/icons/icons8-facebook.svg'
];

Padding customSocialPreview(int index, {SocialMedia? social}) {
  log('Icons: ${svgIcons[index]}');
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: GestureDetector(
      onTap: () {
        if (social != null) {
          launchURL(social.url ?? '');
        }
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF2F2F2),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Align(
                    alignment: Alignment.topCenter,
                    widthFactor: 1.0,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        width: 42,
                        height: 42,
                        child: SvgIcon(
                          assetName: svgIcons[index],
                          color: Color(0xFF004797),
                        ))),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text('${social?.platform}')),
            ],
          )),
    ),
  );
}

Padding customWebsitePreview(int index, {Website? website}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: GestureDetector(
      onTap: () {
        if (website != null) {
          launchURL(website.url ?? '');
        }
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF2F2F2),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  widthFactor: 1.0,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      width: 42,
                      height: 42,
                      child: Icon(
                        Icons.language,
                        color: Color(0xFF004797),
                      )),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text('${website?.name ?? 'Website'}')),
            ],
          )),
    ),
  );
}
