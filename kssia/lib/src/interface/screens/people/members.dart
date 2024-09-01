import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';
import 'package:kssia/src/interface/screens/profile/profilePreview.dart';

class MembersPage extends StatelessWidget {
  final List<User> users;
  const MembersPage({super.key, required this.users});

  // final List<Member> members = [
  //   Member('Alice', 'Software Engineer', 'https://example.com/avatar1.png'),
  //   Member('Bob', 'Product Manager', 'https://example.com/avatar2.png'),
  //   Member('Charlie', 'Designer', 'https://example.com/avatar3.png'),
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final chats = ref
                .watch(fetchChatThreadProvider(token))
                .value
                ?.where((chat) => chat.id != id)
                .toList() ??
            [
              ChatModel(
                name: 'Loading...',
                icon: '',
                time: '',
                currentMessage: '',
                id: '',
                unreadMessages: 0,
              ),
            ];

        log(chats.toString());
        ChatModel sourcChat = ChatModel(
            name: '',
            icon: '',
            time: '',
            currentMessage: '',
            id: id,
            unreadMessages: 0);
        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePreview(
                            user: users[index],
                          )));
                },
                child: ListTile(
                    leading: SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipOval(
                        child: Image.network(
                          users[index].profilePicture ??
                              'https://placehold.co/600x400/png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://placehold.co/600x400/png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text('${users[index].name!.firstName}'),
                    subtitle: Text(users[index].designation!),
                    trailing: users[index].id != id
                        ? IconButton(
                            icon: const Icon(Icons.chat),
                            onPressed: () {
                              log(index.toString());
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => IndividualPage(
                                        chatModel: chats[index],
                                        sourchat: sourcChat,
                                      )));
                            },
                          )
                        : SizedBox()),
              );
            },
          ),
        );
      },
    );
  }
}
