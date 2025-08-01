import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/providers/chat_providers.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/interface/common/OwnMessageCard.dart';
import 'package:kssia/src/interface/common/ReplyCard.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/msg_model.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/interface/common/customdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndividualPage extends ConsumerStatefulWidget {
  IndividualPage({required this.receiver, required this.sender, super.key});
  final Participant receiver;
  final Participant sender;
  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends ConsumerState<IndividualPage> {
  bool isBlocked = false;
  bool show = false;
  FocusNode focusNode = FocusNode();
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getMessageHistory();
    loadUnsendChat();
  }

  void loadUnsendChat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _controller.text = preferences.getString('chat') ?? '';
  }

  void getMessageHistory() async {
    final messagesette = await getMessages(
        senderId: widget.sender.id!, recieverId: widget.receiver.id!);
    if (mounted) {
      setState(() {
        messages.addAll(messagesette);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBlockStatus(); // Now safe to call
  }

  Future<void> _loadBlockStatus() async {
    final asyncUser = ref.watch(userProvider);
    asyncUser.whenData(
      (user) {
        setState(() {
          if (user.blockedUsers != null) {
            isBlocked = user.blockedUsers!
                .any((blockedUser) => blockedUser.userId == widget.receiver.id);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    focusNode.unfocus();
    _controller.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (_controller.text.isEmpty || !mounted) return;

    final messageContent = _controller.text;
    final tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();

    // Clear input immediately
    _controller.clear();

    // Add message locally first with pending status
    setMessage(tempMessageId, "pending", messageContent, widget.sender.id!);

    try {
      // Make API call in background
      final String serverMessageId = await sendChatMessage(
        userId: widget.receiver.id!,
        content: messageContent,
      );

      // Update message status and ID after successful send
      if (mounted) {
        setState(() {
          final msgIndex = messages.indexWhere((m) => m.id == tempMessageId);
          if (msgIndex != -1) {
            messages[msgIndex] = MessageModel(
              id: serverMessageId,
              from: widget.sender.id!,
              status: "sent",
              content: messageContent,
              timestamp: messages[msgIndex].timestamp,
            );
          }
        });
      }
    } catch (e) {
      // Handle failed send
      if (mounted) {
        setState(() {
          final msgIndex = messages.indexWhere((m) => m.id == tempMessageId);
          if (msgIndex != -1) {
            messages[msgIndex] = MessageModel(
              id: tempMessageId,
              from: widget.sender.id!,
              status: "failed",
              content: messageContent,
              timestamp: messages[msgIndex].timestamp,
            );
          }
        });

        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message. Tap to retry.'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                // Remove failed message and retry sending
                setState(() {
                  messages.removeWhere((m) => m.id == tempMessageId);
                });
                _controller.text = messageContent;
                sendMessage();
              },
            ),
          ),
        );
      }
    }
  }

  void setMessage(
      String messageId, String type, String message, String fromId) {
    final messageModel = MessageModel(
      id: messageId,
      from: fromId,
      status: type,
      content: message,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageStream = ref.watch(messageStreamProvider);

    messageStream.whenData((newMessage) {
      bool messageExists = messages.any((message) =>
          message.timestamp == newMessage.timestamp &&
          message.content == newMessage.content);

      if (!messageExists) {
        setState(() {
          messages.add(newMessage);
        });
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('chat', _controller.text);
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFFCFCFC),
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: AppBar(
                    elevation: 1,
                    shadowColor: Colors.white,
                    backgroundColor: Colors.white,
                    leadingWidth: 90,
                    titleSpacing: 0,
                    leading: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                          ),
                        ),
                        ClipOval(
                          child: Container(
                            width: 30,
                            height: 30,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Image.network(
                              widget.receiver.profilePicture ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return SvgPicture.asset(
                                    'assets/icons/dummy_person_small.svg');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          ' ${widget.receiver.name ?? ''}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    actions: [
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert), // The three-dot icon
                        onSelected: (value) {
                          if (value == 'report') {
                            showReportDialog(
                              context: context,
                              onReportStatusChanged: () {},
                              reportType: 'user',
                              reportedItemId: widget.receiver.id ?? '',
                            );
                          } else if (value == 'block') {
                            showBlockPersonDialog(
                              context: context,
                              userId: widget.receiver.id ?? '',
                              onBlockStatusChanged: () {
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    isBlocked = !isBlocked;
                                  });
                                });
                                ref.invalidate(fetchChatThreadProvider);
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'report',
                            child: Row(
                              children: [
                                Icon(Icons.report, color: Color(0xFF004797)),
                                SizedBox(width: 8),
                                Text('Report'),
                              ],
                            ),
                          ),
                          // Divider for visual separation
                          const PopupMenuDivider(height: 1),
                          PopupMenuItem(
                            value: 'block',
                            child: Row(
                              children: [
                                Icon(Icons.block),
                                SizedBox(width: 8),
                                isBlocked ? Text('Unblock') : Text('Block'),
                              ],
                            ),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Border radius for the menu
                        ),
                        color: Colors
                            .white, // Optional: set background color for the menu
                        offset: const Offset(
                            0, 40), // Optional: adjust the position of the menu
                      )
                    ],
                  )),
              body: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: PopScope(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              controller: _scrollController,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[messages.length -
                                    1 -
                                    index]; // Reverse the index to get the latest message first
                                if (message.from == widget.sender.id) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      showDeleteConfirmationDialog(
                                        messageId: message.id ?? '',
                                        context: context,
                                        onDelete: () {
                                          setState(() {
                                            messages.removeWhere(
                                                (singlemessage) =>
                                                    singlemessage.id ==
                                                    message.id);
                                          });
                                        },
                                      );
                                    },
                                    child: OwnMessageCard(
                                      requirement: message.requirement,
                                      status: message.status!,
                                      product: message.product,
                                      message: message.content ?? '',
                                      time: DateFormat('h:mm a').format(
                                        DateTime.parse(
                                                message.timestamp.toString())
                                            .toLocal(),
                                      ),
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onLongPress: () {
                                      showReportDialog(
                                          reportedItemId: message.id ?? '',
                                          context: context,
                                          onReportStatusChanged: () {
                                            // setState(() {
                                            //   if (isBlocked) {
                                            //     isBlocked = false;
                                            //   } else {
                                            //     isBlocked = true;
                                            //   }
                                            // }
                                            // );
                                          },
                                          reportType: 'chat');
                                    },
                                    child: ReplyCard(
                                      requirement: message.requirement,
                                      product: message.product,
                                      message: message.content ?? '',
                                      time: DateFormat('h:mm a').format(
                                        DateTime.parse(
                                                message.timestamp.toString())
                                            .toLocal(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          isBlocked
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF004797),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'This user is blocked',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        shadows: [
                                          // Shadow(
                                          //   color: Colors.black45,
                                          //   blurRadius: 5,
                                          //   offset: Offset(2, 2),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            elevation: 1,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 220, 215, 215),
                                                width: 0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 5.0),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxHeight:
                                                      150, // Limit the height
                                                ),
                                                child: Scrollbar(
                                                  thumbVisibility: true,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    reverse:
                                                        true, // Start from bottom
                                                    child: TextField(
                                                      controller: _controller,
                                                      focusNode: focusNode,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines:
                                                          null, // Allows for unlimited lines
                                                      minLines:
                                                          1, // Starts with a single line
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Type a message",
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 2,
                                            left: 2,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color(0xFF004797),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                sendMessage();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                      onPopInvoked: (didPop) {
                        if (didPop) {
                          if (show) {
                            setState(() {
                              show = false;
                            });
                          } else {
                            focusNode.unfocus();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            });
                          }
                          ref.invalidate(fetchChatThreadProvider);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
