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
import 'package:shimmer/shimmer.dart';

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({super.key});

  @override
  ConsumerState<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: users.isEmpty
            ? Center(child: Text('No Members')) // Show loader when no data
            : asyncChats.when(
                data: (chats) {
                  log('im inside chat');
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: users.length +
                        (isLoading
                            ? 1
                            : 0), // Add 1 to show the loading indicator
                    itemBuilder: (context, index) {
                      if (index == users.length) {
                        // This is the loading indicator at the end of the list
                        return Center(
                          child:
                              LoadingAnimation(), // Show loading indicator when fetching more users
                        );
                      }

                      // Regular user item
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
                                id: id), // Replace with current user if needed
                          ],
                        ),
                      );

                      var receiver = chatForUser.participants?.firstWhere(
                        (participant) => participant.id != id,
                        orElse: () => Participant(
                          id: users[index].id,
                          firstName: users[index].name?.firstName ?? '',
                          middleName: users[index].name?.middleName ?? '',
                          lastName: users[index].name?.lastName ?? '',
                          profilePicture: users[index].profilePicture,
                        ),
                      );

                      var sender = chatForUser.participants?.firstWhere(
                        (participant) => participant.id == id,
                        orElse: () => Participant(),
                      );

                      final user = users[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfilePreview(user: user),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child: Image.network(
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    // If the image is fully loaded, show the image
                                    return child;
                                  }
                                  // While the image is loading, show shimmer effect
                                  return Container(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                user.profilePicture ?? 'error',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      scale: .9,
                                      'assets/icons/dummy_person_small.png');
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
                            icon: Icon(Icons.chat_bubble_outline),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => IndividualPage(
                                  receiver: receiver!,
                                  sender: sender!,
                                ),
                              ));
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
                    child: Text('No Members'),
                  );
                },
              ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
