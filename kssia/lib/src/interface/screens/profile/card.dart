import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/services/request_permissions.dart';
import 'package:kssia/src/data/services/save_qr.dart';
import 'package:kssia/src/data/services/share_qr.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();
    final isFullScreenProvider = StateProvider<bool>((ref) => false);

    return Consumer(
      builder: (context, ref, child) {
        final isFullScreen = ref.watch(isFullScreenProvider);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: !isFullScreen
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(65.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 231, 226, 226),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: AppBar(
                      toolbarHeight: 45.0,
                      scrolledUnderElevation: 0,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      leadingWidth: 100,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/icons/kssiaLogo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuPage()),
                            );
                          },
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Profile')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                            icon: Icon(isFullScreen
                                ? Icons.close_fullscreen
                                : Icons.open_in_full),
                            onPressed: () {
                              SystemChrome.setEnabledSystemUIMode(isFullScreen
                                  ? SystemUiMode.edgeToEdge
                                  : SystemUiMode.immersiveSticky);
                              ref.read(isFullScreenProvider.notifier).state =
                                  !isFullScreen;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Screenshot(
                    controller: screenshotController,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          onBackgroundImageError: (_, __) =>
                                              Image.asset(
                                                  'assets/dummy_person_large.png'),
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              user.profilePicture ?? ''),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${user.name?.firstName ?? ''} ${user.name?.middleName ?? ''} ${user.name?.lastName ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    if (user.companyLogo !=
                                                            null &&
                                                        user.companyLogo!
                                                            .isNotEmpty)
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(9),
                                                        child: Image.network(
                                                          user.companyLogo!,
                                                          height: 33,
                                                          width: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    else
                                                      Image.asset(
                                                        'assets/icons/dummy_company.png',
                                                        height: 33,
                                                        width: 40,
                                                      ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (user.designation !=
                                                              null)
                                                            Text(
                                                              user.designation!,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        42,
                                                                        41,
                                                                        41),
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          if (user.companyName !=
                                                              null)
                                                            Text(
                                                              maxLines: 2,
                                                              user.companyName!,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          QrImageView(
                            size: 300,
                            data:
                                'https://admin.kssiathrissur.com/user/${user.id}',
                          ),
                          const SizedBox(height: 20),
                          if (user.phoneNumbers != null)
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Color(0xFF004797)),
                                const SizedBox(width: 10),
                                Text(user.phoneNumbers?.personal ?? ''),
                              ],
                            ),
                          const SizedBox(height: 10),
                          if (user.email != null)
                            Row(
                              children: [
                                const Icon(Icons.email,
                                    color: Color(0xFF004797)),
                                const SizedBox(width: 10),
                                Text(user.email!),
                              ],
                            ),
                          const SizedBox(height: 10),
                          if (user.address != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xFF004797)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    user.address!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  if (!isFullScreen)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: customButton(
                              buttonHeight: 60,
                              fontSize: 16,
                              label: 'SHARE',
                              onPressed: () async {
                                shareQr(
                                  context: context,
                                  screenshotController: screenshotController,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: customButton(
                              sideColor:
                                  const Color.fromARGB(255, 219, 217, 217),
                              labelColor: const Color(0xFF2C2829),
                              buttonColor:
                                  const Color.fromARGB(255, 222, 218, 218),
                              buttonHeight: 60,
                              fontSize: 16,
                              label: 'DOWNLOAD QR',
                              onPressed: () async {
                                await saveQr(
                                  context: context,
                                  screenshotController: screenshotController,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
