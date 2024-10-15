import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';
import 'package:kssia/src/interface/screens/profile/card.dart';
import 'package:kssia/src/interface/screens/profile/profilePreview.dart';
import 'package:open_share_plus/open.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(40.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 237, 231, 231)),
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 182, 181, 181)
                                  .withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(.5, .5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF2F2F2),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                ProfilePreview(
                                              user: user,
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    user.profilePicture != null &&
                                            user.profilePicture != ''
                                        ? CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              user.profilePicture ?? '',
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/icons/dummy_person.png'),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${user.name!.firstName!} ${user.name?.middleName ?? ''} ${user.name!.lastName!}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                child: user.companyLogo !=
                                                            null &&
                                                        user.companyLogo != ''
                                                    ? Image.network(
                                                        user.companyLogo!,
                                                        height: 33,
                                                        width: 40,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const SizedBox())
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (user.designation != null)
                                              Text(
                                                user.designation ?? '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 42, 41, 41),
                                                ),
                                              ),
                                            if (user.companyName != null)
                                              Text(
                                                user.companyName ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 35, right: 30, top: 25, bottom: 35),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 237, 231, 231)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(.5, .5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Color(0xFF004797)),
                                const SizedBox(width: 10),
                                Text(user.phoneNumbers?.personal.toString() ??
                                    ''),
                              ],
                            ),
                            const SizedBox(height: 10),
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
                                  if (user.address != null)
                                    Flexible(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                              child: Text(user.address ?? '')),
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
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 237, 231, 231)),
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
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
                              'Member ID: ${user.membershipId}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Share.share(
                                  'https://admin.kssiathrissur.com/user/${user.id}');
                            },
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Color(0xFF004797),
                                borderRadius: BorderRadius.circular(
                                    50), // Apply circular border to the outer container
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xFF004797),
                                  ),
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileCard(
                                    user: user,
                                  ), // Navigate to CardPage
                                ),
                              );
                            },
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    50), // Apply circular border to the outer container
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.qr_code,
                                    color: Colors.grey,
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
