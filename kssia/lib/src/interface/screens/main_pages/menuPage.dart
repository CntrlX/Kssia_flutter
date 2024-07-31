import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../menu/requestNFC.dart';
import '../menu/myrequirementsPage.dart';
import '../menu/terms_and_conditions.dart';
import '../menu/privacy.dart';
import '../menu/about.dart';

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
            Divider(),
            SizedBox(height: 10), // Add space here
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
            SizedBox(height: 10), // Add space here
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
            _buildListTile(context, Icons.subscriptions, 'My subscriptions'),
            _buildListTile(context, Icons.shopping_bag, 'My Products'),
            _buildListTile(context, Icons.reviews, 'My Reviews'),
            _buildListTile(context, Icons.event, 'My Events'),
            _buildListTile(context, Icons.monetization_on, 'My transactions'),
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
            SizedBox(height: 10), // Add space here
            _buildListTile(
              context,
              Icons.logout,
              'Logout',
              textColor: Colors.black,
              onTap: () => showLogoutDialog(context),
            ),
            SizedBox(height: 10), // Add space here
            _buildListTile(
              context,
              Icons.delete,
              'Delete account',
              textColor: Colors.red,
              onTap: () => showDeleteAccountDialog(context),
            ),
            SizedBox(height: 20),
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
      {Color textColor = Colors.black, Function()? onTap}) {
    return ListTile(
      leading: Icon(icon),
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

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy policy'),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/polygon.svg',
            height: 16,
            width: 16,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/polygon.svg',
            height: 16,
            width: 16,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://placehold.co/600x400/png'),
            SizedBox(height: 16),
            Text(
              'ABOUT THE COMPANY',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 10),
                Text('9425726433', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                Text('kssia@gmail.com', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Image.network('https://placehold.co/600x400/png'),
          ],
        ),
      ),
    );
  }
}
