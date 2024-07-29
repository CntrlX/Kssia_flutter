import 'package:flutter/material.dart';

class MembersPage extends StatelessWidget {
  final List<Member> members = [
    Member('Alice', 'Software Engineer', 'https://example.com/avatar1.png'),
    Member('Bob', 'Product Manager', 'https://example.com/avatar2.png'),
    Member('Charlie', 'Designer', 'https://example.com/avatar3.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(members[index].avatarUrl),
            ),
            title: Text(members[index].name),
            subtitle: Text(members[index].designation),
            trailing: IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                // Handle chat button press
              },
            ),
          );
        },
      ),
    );
  }
}

class Member {
  final String name;
  final String designation;
  final String avatarUrl;

  Member(this.name, this.designation, this.avatarUrl);
}
