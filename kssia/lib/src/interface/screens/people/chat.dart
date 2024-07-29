import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final List<ChatItem> chatItems = [
    ChatItem(
        avatar: 'https://via.placeholder.com/150',
        name: 'Alice',
        designation: 'Manager',
        unreadMessages: 2),
    ChatItem(
        avatar: 'https://via.placeholder.com/150',
        name: 'Bob',
        designation: 'Developer',
        unreadMessages: 5),
    ChatItem(
        avatar: 'https://via.placeholder.com/150',
        name: 'Charlie',
        designation: 'Designer',
        unreadMessages: 0),
    ChatItem(
        avatar: 'https://via.placeholder.com/150',
        name: 'David',
        designation: 'Tester',
        unreadMessages: 3),
    // Add more items here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chatItems[index].avatar),
            ),
            title: Text(chatItems[index].name),
            subtitle: Text(chatItems[index].designation),
            trailing: chatItems[index].unreadMessages > 0
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '${chatItems[index].unreadMessages}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class ChatItem {
  final String avatar;
  final String name;
  final String designation;
  final int unreadMessages;

  ChatItem({
    required this.avatar,
    required this.name,
    required this.designation,
    required this.unreadMessages,
  });
}
