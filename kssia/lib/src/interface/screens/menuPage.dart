import 'package:flutter/material.dart';

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
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 11,
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
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text('No', style: TextStyle(fontSize: 16, color: Colors.black)),
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
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text('Yes, Delete', style: TextStyle(fontSize: 16, color: Colors.red)),
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
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 11,
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
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text('No', style: TextStyle(fontSize: 16, color: Colors.black)),
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
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text('Yes, Logout', style: TextStyle(fontSize: 16, color: Colors.red)),
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
                    backgroundImage: NetworkImage('https://placehold.co/100x100/png'),
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
            _buildListTile(context, Icons.credit_card, 'Request NFC'),
            _buildListTile(context, Icons.subscriptions, 'My subscriptions'),
            _buildListTile(context, Icons.shopping_bag, 'My Products'),
            _buildListTile(context, Icons.reviews, 'My Reviews'),
            _buildListTile(context, Icons.event, 'My Events'),
            _buildListTile(context, Icons.monetization_on, 'My transactions'),
            _buildListTile(context, Icons.notifications, 'My Requirements'),
            _buildListTile(context, Icons.info, 'About us'),
            _buildListTile(context, Icons.privacy_tip, 'Privacy policy'),
            _buildListTile(context, Icons.rule, 'Terms & condition'),
            _buildListTile(
              context,
              Icons.logout,
              'Logout',
              textColor: Colors.black,
              onTap: () => showLogoutDialog(context),
            ),
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
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap ?? () {
        // Handle list item tap
      },
    );
  }
}
