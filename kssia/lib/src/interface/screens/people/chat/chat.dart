import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/msg_model.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/common/upgrade_dialog.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';
import 'package:shimmer/shimmer.dart';

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
              return Stack(
                children: [
                  if (chats.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Center(child: Image.asset('assets/nochat.png')),
                        ),
                        const Text('No chat yet!')
                      ],
                    ),
                  if (chats.isNotEmpty)
                    ListView.builder(
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

                        return Column(
                          children: [
                            ListTile(
                              leading: ClipOval(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: Image.network(
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
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
                                    receiver?.profilePicture ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return SvgPicture.asset(
                                          'assets/icons/dummy_person_small.svg');
                                    },
                                  ),
                                ),
                              ),
                              title: Text(
                                '${receiver?.name ?? ''}',
                              ),
                              subtitle: Text(
                                chats[index].lastMessage?[0].content != null
                                    ? (chats[index]
                                                .lastMessage![0]
                                                .content!
                                                .length >
                                            10
                                        ? chats[index]
                                                .lastMessage![0]
                                                .content!
                                                .substring(0, 10) +
                                            '...'
                                        : chats[index].lastMessage![0].content!)
                                    : '',
                              ),
                              trailing: chats[index].unreadCount?[sender?.id] !=
                                          0 &&
                                      chats[index].unreadCount?[sender!.id] !=
                                          null
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${chats[index].unreadCount?[sender!.id]}',
                                            style: const TextStyle(
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
                                    receiver: receiver!,
                                    sender: sender!,
                                  ),
                                ));
                              },
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color.fromARGB(255, 227, 221, 221),
                              height:
                                  1, // Ensures the line is flush without extra space
                            ),
                          ],
                        );
                      },
                    ),
                  // if (subscription != 'premium')
                  //   Positioned.fill(
                  //     child: BackdropFilter(
                  //       filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  //       child: Container(
                  //         color: Colors.black
                  //             .withOpacity(0.6), // Semi-transparent overlay
                  //         child: Center(
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               const Icon(
                  //                 Icons.lock_outline,
                  //                 size: 50,
                  //                 color: Colors.white,
                  //               ),
                  //               const SizedBox(height: 16),
                  //               const Text(
                  //                 'Unlock Premium Content',
                  //                 style: TextStyle(
                  //                   fontSize: 22,
                  //                   color: Colors.white,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 8),
                  //               const Text(
                  //                 'Buy Premium to access this page and more.',
                  //                 textAlign: TextAlign.center,
                  //                 style: TextStyle(
                  //                   fontSize: 14,
                  //                   color: Colors.white70,
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 24),
                  //               SizedBox(
                  //                   width: 230,
                  //                   child: customButton(
                  //                       label: 'Buy Premium',
                  //                       onPressed: () {
                  //                         showDialog(
                  //                           context: context,
                  //                           builder: (context) =>
                  //                               const UpgradeDialog(),
                  //                         );
                  //                       }))
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              );
            },
            loading: () => const Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              return Center(
                child: Text('NO CHATS'),
              );
            },
          ));
    });
  }
}
