class ChatModel {
  String name;
  String icon;
  String time;
  String currentMessage;
  bool select = false;
  int id;
  int unreadMessages;
  ChatModel({
    required this.name,
    required this.icon,
    required this.time,
    required this.currentMessage,
    this.select = false,
    required this.id,
    required this.unreadMessages,
  });
}
