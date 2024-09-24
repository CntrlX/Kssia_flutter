import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/msg_model.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';

class ChatPage extends ConsumerStatefulWidget {
  ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final asyncChats = ref.watch(fetchChatThreadProvider(token));

      return Scaffold(
          backgroundColor: Colors.white,
          body: asyncChats.when(
            data: (chats) {
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  var receiver = chats[index].participants?.firstWhere(
                        (participant) => participant.id != id,
                        orElse: () => Participant(id: ''),
                      );
                  var sender = chats[index].participants?.firstWhere(
                        (participant) => participant.id == id,
                        orElse: () => Participant(),
                      );
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(receiver?.profilePicture ?? ''),
                    ),
                    title: Text(
                        '${receiver?.firstName ?? ''}${receiver?.middleName ?? ''}${receiver?.lastName ?? ''}'),
                    subtitle:
                        Text(chats[index].lastMessage?[0].content ?? ''),
                    trailing: chats[index].unreadCount?[sender?.id] != 0 &&
                            chats[index].unreadCount?[sender!.id] != null
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
                                child:
                                    chats[index].unreadCount?[sender!.id] !=
                                            null
                                        ? Text(
                                            '${chats[index].unreadCount?[sender!.id]}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        : null,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IndividualPage(
                                receiver: receiver!,
                                sender: sender!,
                              )));
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              return Center(
                child: LoadingAnimation(),
              );
            },
          ));
    });
  }
}
