import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/launch_url.dart';
import 'package:kssia/src/data/services/webview.dart';
import 'package:kssia/src/interface/common/Shimmer/menu_page_shimmer.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/main_pages/loginPage.dart';
import 'package:kssia/src/interface/screens/menu/my_product.dart';
import 'package:kssia/src/interface/screens/menu/my_reviews.dart';
import 'package:kssia/src/interface/screens/profile/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../menu/requestNFC.dart';
import '../menu/myrequirementsPage.dart';
import '../menu/terms_and_conditions.dart';
import '../menu/privacy.dart';
import '../menu/about.dart';
import '../menu/my_subscription.dart';
import '../menu/my_events.dart';
import '../menu/my_transaction.dart';
import 'package:animate_do/animate_do.dart';
import '../menu/blocked_users.dart';

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        title: Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            children: [
              Icon(
                Icons.help,
                color: Colors.blue,
                size: 60,
              ),
              SizedBox(height: 10),
              Text(
                'Delete Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('No',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Yes, Delete',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                      onPressed: () {
                        // Add your delete account logic here
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        title: Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            children: [
              Icon(
                Icons.help,
                color: Colors.blue,
                size: 60,
              ),
              SizedBox(height: 10),
              Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('No',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text('Yes',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red)),
                          onPressed: () async {
                            LoggedIn = false;
                            final SharedPreferences preferences =
                                await SharedPreferences.getInstance();

                            preferences.remove('token');
                            preferences.remove('id');
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login_screen',
                              (Route<dynamic> route) => false,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: asyncUser.when(
              loading: () => const MenuPageShimmer(),
              error: (error, stackTrace) {
                // Handle error state
                return const Center(
                  child: LoadingAnimation(),
                );
              },
              data: (user) {
                print(user);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile and Edit Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.network(
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      scale: .7,
                                      'assets/icons/dummy_person_small.png');
                                },
                                user.profilePicture ?? '',
                                height: 70,
                                width: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.abbreviation ?? ''} ${user.name ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    user.phoneNumbers!.personal.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(userProvider.notifier).refreshUser();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings:
                                          const RouteSettings(name: 'menu'),
                                      builder: (context) =>
                                          DetailsPage()), // Navigate to MenuPage
                                );
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Account Section Label

                      const SizedBox(height: 13),
                      Container(
                        height: 50,
                        width: double.infinity,
                        color: const Color(0xFFF2F2F2),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Text(
                                'ACCOUNT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Menu List

                      // _buildListTile(
                      //   context,
                      //   Icons.credit_card,
                      //   'Request NFC',
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => RequestNFCPage()),
                      //     );
                      //   },
                      // ),

                      if (user.phoneNumbers?.personal != '+919645398555' &&
                          paymentEnabled)
                        _buildListTile(
                          context,
                          Icons.subscriptions,
                          'My subscriptions',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MySubscriptionPage()),
                            );
                          },
                        ),
                      if (user.phoneNumbers?.personal != '+919645398555' &&
                          paymentEnabled)
                        const Divider(),
                      _buildListTile(
                        context,
                        Icons.shopping_bag,
                        'My Products',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProductPage()),
                          );
                        },
                      ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.star,
                        'My Reviews',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyReviewsPage()),
                          );
                        },
                      ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.calendar_view_month_rounded,
                        'My Events',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyEventsPage()),
                          );
                        },
                      ),
                      if (user.phoneNumbers?.personal != '+919645398555')
                        const Divider(),
                      if (user.phoneNumbers?.personal != '+919645398555')
                        _buildListTile(
                          context,
                          Icons.monetization_on,
                          'My Transactions',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyTransactionsPage()),
                            );
                          },
                        ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.notifications,
                        'My Requirements',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyRequirementsPage()),
                          );
                        },
                      ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.info,
                        'About us',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()),
                          );
                        },
                      ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.privacy_tip,
                        'Privacy policy',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicyPage()),
                          );
                        },
                      ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.rule,
                        'Terms & condition',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditionsPage()),
                          );
                        },
                      ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.block,
                        'Blocked Users',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BlockedUsersPage()),
                          );
                        },
                      ),

                      // Spacing before Logout and Delete
                      Container(color: const Color(0xFFF2F2F2), height: 15),

                      // Logout and Delete Account
                      _buildListTile(
                        context,
                        Icons.logout,
                        'Logout',
                        textColor: Colors.black,
                        onTap: () => showLogoutDialog(context),
                      ),
                      Container(color: const Color(0xFFF2F2F2), height: 15),

                      // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(),
                      //       child: _buildListTile(
                      //         context,
                      //         Icons.delete,
                      //         'Delete account',
                      //         textColor: Colors.red,
                      //         onTap: () => showDeleteAccountDialog(context),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // Container(color: Color(0xFFF2F2F2), height: 20),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WebViewScreen(
                                        color: Colors.blue,
                                        url: 'https://www.skybertech.com/',
                                        title: 'Skybertech',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                      color: const Color.fromARGB(
                                          255, 246, 246, 246)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 22, right: 22),
                                        child: Text(
                                          'Powered by',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Image.asset(
                                        scale: 15,
                                        'assets/skybertechlogo.png',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WebViewScreen(
                                        color: Colors.deepPurpleAccent,
                                        url: 'https://www.acutendeavors.com/',
                                        title: 'ACUTE ENDEAVORS',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                      color: const Color.fromARGB(
                                          255, 246, 246, 246)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, bottom: 3),
                                          child: Text(
                                            'Developed by',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 7),
                                          child: Image.asset(
                                            scale: 25,
                                            'assets/acutelogo.png',
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
                      ),
                      Container(color: const Color(0xFFF2F2F2), height: 20),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }

  ListTile _buildListTile(BuildContext context, IconData icon, String title,
      {Color textColor = const Color.fromARGB(255, 0, 0, 0),
      Function()? onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: const Color.fromARGB(255, 121, 116, 116)),
      ),
      title: Text(title, style: TextStyle(color: textColor, fontSize: 16)),
      trailing: SvgPicture.asset(
        'assets/icons/polygon.svg',
        height: 16,
        width: 16,
        color: const Color(0xFFC4C4C4),
      ),
      onTap: onTap ??
          () {
            // Handle list item tap
          },
    );
  }
}
