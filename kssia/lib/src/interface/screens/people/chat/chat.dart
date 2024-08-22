import 'package:flutter/material.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';

class ChatPage extends StatelessWidget {
  ChatModel sourcChat = ChatModel(
      name: '',
      icon: 'https://via.placeholder.com/150',
      time: '6:11',
      currentMessage: 'awawbarwb',
      id: '66c43d09e6647052a892263e',
      unreadMessages: 4);

  final List<ChatModel> chats = [
    ChatModel(
        name: 'Sreeram',
        icon: 'https://via.placeholder.com/150',
        time: '6:15',
        currentMessage: 'Hey whats goin on',
        id: '66c38e4db9aa147c230339bf',
        unreadMessages: 2),
    ChatModel(
        name: 'Nihal',
        icon: 'https://via.placeholder.com/150',
        time: '6:15',
        currentMessage: 'Hey whats goin on',
        id: '66c43d09e6647052a892263e',
        unreadMessages: 2),
  ];

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chats[index].icon),
            ),
            title: Text(chats[index].name),
            subtitle: Text(chats[index].currentMessage),
            trailing: chats[index].unreadMessages > 0
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
                          '${chats[index].unreadMessages}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IndividualPage(
                        chatModel: chats[index],
                        sourchat: sourcChat,
                      )));
            },
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
