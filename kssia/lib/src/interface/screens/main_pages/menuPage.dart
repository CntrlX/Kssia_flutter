import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/interface/screens/menu/my_product.dart';
import 'package:kssia/src/interface/screens/menu/my_reviews.dart';
import '../menu/requestNFC.dart';
import '../menu/myrequirementsPage.dart';
import '../menu/terms_and_conditions.dart';
import '../menu/privacy.dart';
import '../menu/about.dart';
import '../menu/my_subscription.dart';
import '../menu/my_events.dart';
import '../menu/my_transaction.dart';

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10.0),
        title: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
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
                      child: Text('No',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
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
                      child: Text('Yes, Delete',
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
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10.0),
        title: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
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
                      child: Text('No',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
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
                      child: Text('Yes, Logout',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                      onPressed: () {
                        // Add your logout logic here
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

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile and Edit Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage('https://placehold.co/100x100/png'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ramakrishna Panikar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('984575223'),
                    ],
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      // Edit profile action
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Add space below profile section

            // Account Section Label
            Divider(),
            SizedBox(height: 13), 
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'ACCOUNT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 13), // Add space here
            Divider(),

            // Menu List
            _buildListTile(
              context,
              Icons.credit_card,
              'Request NFC',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestNFCPage()),
                );
              },
            ),
            Divider(),
            _buildListTile(
              context,
              Icons.subscriptions,
              'My subscriptions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MySubscriptionPage()),
                );
              },
            ),
            Divider(),
            _buildListTile(context, Icons.shopping_bag, 'My Products',
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const MyProductPage()),
                );
              }, 
            ),
            Divider(),
            _buildListTile(context,Icons.subscriptions,'My Reviews',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyReviewsPage()),
                );
              },
            ),
            Divider(),
            _buildListTile(context,Icons.subscriptions,'My Events',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyEventsPage()),
                );
              },
            ),
            Divider(),
            _buildListTile(
              context,
              Icons.monetization_on,
              'My Transactions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyTransactionsPage()),
                );
              },
            ),
            Divider(),
            _buildListTile(
              context,
              Icons.notifications,
              'My Requirements',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyRequirementsPage()),
                );
              },
            ),
            Divider(),
            _buildListTile(
              context,
              Icons.info,
              'About us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            Divider(),
            _buildListTile(
              context,
              Icons.privacy_tip,
              'Privacy policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                );
              },
            ),
            Divider(),
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
            Divider(),

            // Spacing before Logout and Delete
            SizedBox(height: 0.5),

             Divider(),
            // Logout and Delete Account
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: _buildListTile(
                context,
                Icons.logout,
                'Logout',
                textColor: Colors.black,
                onTap: () => showLogoutDialog(context),
              ),
            ),
            Divider(),

             SizedBox(height: 0.5),
              Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: _buildListTile(
                context,
                Icons.delete,
                'Delete account',
                textColor: Colors.red,
                onTap: () => showDeleteAccountDialog(context),
              ),
            ),
            Divider(),
            SizedBox(height: 20),

            // Version and Playstore Rating
            Center(
              child: Text(
                'Version 1.32\nRate us on Playstore',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, IconData icon, String title,
      {Color textColor = const Color.fromARGB(255, 0, 0, 0), Function()? onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: textColor),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: SvgPicture.asset(
        'assets/icons/polygon.svg',
        height: 16,
        width: 16,
        color: textColor,
      ),
      onTap: onTap ??
          () {
            // Handle list item tap
          },
    );
  }
}



