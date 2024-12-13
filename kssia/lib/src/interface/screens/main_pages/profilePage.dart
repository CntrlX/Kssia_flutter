import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/services/api_routes/subscription_api.dart';
import 'package:kssia/src/data/services/share_with_qr.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/common/upgrade_dialog.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';
import 'package:kssia/src/interface/screens/profile/card.dart';
import 'package:kssia/src/interface/screens/profile/profilePreview.dart';
import 'package:open_share_plus/open.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.invalidate(fetchStatusProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 182, 181, 181)
                                  .withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(.5, .5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Image that can overflow
                            Positioned.fill(
                              child: Image.asset(
                                color: Colors.black.withOpacity(0.6),
                                'assets/triangles.png',
                                fit: BoxFit.cover,
                                height: 240,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      widget.user.profilePicture != null &&
                                              widget.user.profilePicture != ''
                                          ? Container(
                                              width:
                                                  95, 
                                              height: 95,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(0xFF004797),
                                                  width: 2.0, 
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: Image.network(
                                                  widget.user.profilePicture ??
                                                      '',
                                                  width:
                                                      74, 
                                                  height: 74,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            )
                                          : Image.asset(
                                              scale: 1.3,
                                              'assets/icons/dummy_person_large.png',
                                            ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${widget.user.abbreviation ?? ''} ${widget.user.name ?? ''}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                            if (widget.user.designation != null)
                                              Text(
                                                widget.user.designation ?? '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 42, 41, 41),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            Text(
                                              widget.user.companyName ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(
                            left: 35, right: 30, top: 25, bottom: 35),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: const Border(
                            top: BorderSide(
                              color: Color.fromARGB(
                                  255, 237, 231, 231), // Your border color
                              width: 1.0, // Border width
                            ),
                          ),
                          // border: Border.all(
                          //     color: const Color.fromARGB(255, 237, 231, 231)),
                          // color: Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 0,
                          //     blurRadius: 1,
                          //     offset: const Offset(.5, .5),
                          //   ),
                          // ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Color(0xFF004797)),
                                const SizedBox(width: 10),
                                Text(widget.user.phoneNumbers?.personal
                                        .toString() ??
                                    ''),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (widget.user.email != null &&
                                widget.user.email != '')
                              Row(
                                children: [
                                  const Icon(Icons.email,
                                      color: Color(0xFF004797)),
                                  const SizedBox(width: 10),
                                  Text(widget.user.email!),
                                ],
                              ),
                            const SizedBox(height: 10),
                            if (widget.user.address != null &&
                                widget.user.address != '')
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Color(0xFF004797)),
                                  if (widget.user.address != null)
                                    Flexible(
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                              child: Text(
                                                  widget.user.address ?? '')),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  // if (user.bio != null)
                                  //   Expanded(
                                  //     child: Text(
                                  //       user.bio ?? '',
                                  //     ),
                                  //   ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          border: const Border(
                            top: BorderSide(
                              color: Color.fromARGB(
                                  255, 237, 231, 231), // Your border color
                              width: 1.0, // Border width
                            ),
                          ),
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(.5, .5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 40,
                              child: Image.asset(
                                'assets/icons/kssiaLogo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              'Member ID: ${widget.user.membershipId}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         if (subscription != 'free') {
                      //           Share.share(
                      //               'https://admin.kssiathrissur.com/user/${widget.user.id}');
                      //         } else {
                      //           showDialog(
                      //             context: context,
                      //             builder: (context) => const UpgradeDialog(),
                      //           );
                      //         }
                      //       },
                      //       child: Container(
                      //         width: 90,
                      //         height: 90,
                      //         decoration: BoxDecoration(
                      //           color: Color(0xFF004797),
                      //           borderRadius: BorderRadius.circular(
                      //               50), // Apply circular border to the outer container
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(4.0),
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(50),
                      //               color: Color(0xFF004797),
                      //             ),
                      //             child: Icon(
                      //               Icons.share,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 40),
                      //     GestureDetector(
                      //       onTap: () {
                      //         if (subscription != 'free') {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => ProfileCard(
                      //                 user: widget.user,
                      //               ), // Navigate to CardPage
                      //             ),
                      //           );
                      //         } else {
                      //           showDialog(
                      //             context: context,
                      //             builder: (context) => const UpgradeDialog(),
                      //           );
                      //         }
                      //       },
                      //       child: Container(
                      //         width: 90,
                      //         height: 90,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(
                      //               50), // Apply circular border to the outer container
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(4.0),
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(50),
                      //               color: Colors.white,
                      //             ),
                      //             child: Icon(
                      //               Icons.qr_code,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    captureAndShareWidgetScreenshot(context);
                    // Share.share(
                    //     'https://admin.kssiathrissur.com/user/${widget.user.id}');
                  },
                  child: SvgPicture.asset('assets/icons/shareButton.svg'),
                  // child: Container(
                  //   width: 90,
                  //   height: 90,
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFFE30613),
                  //     borderRadius: BorderRadius.circular(
                  //         50), // Apply circular border to the outer container
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(4.0),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(50),
                  //         color: Color(0xFFE30613),
                  //       ),
                  //       child: Icon(
                  //         Icons.share,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileCard(
                            user: widget.user,
                          ), // Navigate to CardPage
                        ),
                      );
                    },
                    child: SvgPicture.asset('assets/icons/qrButton.svg')
                    // Container(
                    //   width: 90,
                    //   height: 90,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(
                    //         50), // Apply circular border to the outer container
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(4.0),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(50),
                    //         color: Colors.white,
                    //       ),
                    //       child: Icon(
                    //         Icons.qr_code,
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    ),
                const SizedBox(width: 20),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePreview(), // Navigate to CardPage
                        ),
                      );
                    },
                    child: SvgPicture.asset('assets/icons/eyeButton.svg'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
