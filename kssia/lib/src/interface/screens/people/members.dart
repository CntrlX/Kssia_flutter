import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/notifiers/people_notifier.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';
import 'package:kssia/src/interface/screens/profile/profilePreview.dart';

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({super.key});

  @override
  ConsumerState<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  final ScrollController _scrollController = ScrollController();

  late final webSocketClient;
  @override
  void initState() {
    super.initState();
    webSocketClient = ref.read(socketIoClientProvider);
    webSocketClient.connect(id, ref);
    _scrollController.addListener(_onScroll);

    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(peopleNotifierProvider.notifier).fetchMoreUsers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(peopleNotifierProvider.notifier).fetchMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(peopleNotifierProvider);
    final isLoading = ref.read(peopleNotifierProvider.notifier).isLoading;
    final asyncChats = ref.watch(fetchChatThreadProvider(token));
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.invalidate(fetchChatThreadProvider);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: users.isEmpty
              ? Center(child: LoadingAnimation()) // Show loader when no data
              : asyncChats.when(
                  data: (chats) {
                    log('im inside chat');
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          users.length, // Add 1 for the loading indicator
                      itemBuilder: (context, index) {
                        var chatForUser = chats.firstWhere(
                          (chat) =>
                              chat.participants?.any((participant) =>
                                  participant.id == users[index].id) ??
                              false,
                          orElse: () => ChatModel(
                            participants: [
                              Participant(
                                id: users[index].id,
                                firstName: users[index].name?.firstName ?? '',
                                middleName: users[index].name?.middleName ?? '',
                                lastName: users[index].name?.lastName ?? '',
                                profilePicture: users[index].profilePicture,
                              ),
                              Participant(
                                  id: id), // You can replace this with a default sender (current user)
                            ],
                          ),
                        );

                        // Get the receiver and sender for the chat
                        var receiver = chatForUser.participants?.firstWhere(
                          (participant) => participant.id != id,
                          orElse: () => Participant(
                            id: users[index].id,
                            firstName: users[index].name?.firstName ?? '',
                            middleName: users[index].name?.firstName ?? '',
                            lastName: users[index].name?.firstName ?? '',
                            profilePicture: users[index].profilePicture,
                          ),
                        );

                        var sender = chatForUser.participants?.firstWhere(
                          (participant) => participant.id == id,
                          orElse: () => Participant(),
                        );
                        if (index == users.length) {
                          return isLoading
                              ? Center(
                                  child:
                                      LoadingAnimation()) // Show loading when fetching more users
                              : SizedBox.shrink(); // Hide when done
                        }

                        final user = users[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfilePreview(
                                  user: user,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: SizedBox(
                              height: 40,
                              width: 40,
                              child: ClipOval(
                                child: Image.network(
                                  user.profilePicture ??
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
                            title: Text(
                                '${user.name?.firstName ?? ''} ${user.name?.middleName ?? ''} ${user.name?.lastName ?? ''}'),
                            subtitle: user.designation != null
                                ? Text(user.designation!)
                                : null,
                            trailing: IconButton(
                              icon: Icon(Icons.chat),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => IndividualPage(
                                          receiver: receiver!,
                                          sender: sender!,
                                        )));
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: LoadingAnimation()),
                  error: (error, stackTrace) {
                    return Center(
                      child: Text('Error loading promotions: $error'),
                    );
                  },
                )),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    webSocketClient.disconnect();
  }
}
