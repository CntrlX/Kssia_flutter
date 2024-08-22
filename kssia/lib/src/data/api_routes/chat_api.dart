import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:kssia/src/data/models/msg_model.dart';

// Define a WebSocket client provider
final webSocketClientProvider = Provider<WebSocketClient>((ref) {
  return WebSocketClient();
});

// Define a message stream provider
final messageStreamProvider = StreamProvider.autoDispose<MessageModel>((ref) {
  final webSocketClient = ref.read(webSocketClientProvider);
  return webSocketClient.messageStream;
});

class WebSocketClient {
  late WebSocket _webSocket;
  final _controller = StreamController<MessageModel>();

  WebSocketClient();

  Stream<MessageModel> get messageStream => _controller.stream;

  Future<void> connect(String receiverId) async {
    final uri = Uri.parse('ws://43.205.89.79/api/v1/chats/send/$receiverId');
    _webSocket = WebSocket(uri);

    // Listen to messages from the server
    _webSocket.messages.listen(
      (message) {
        final decodedMessage = jsonDecode(message);
        print('Received message: $decodedMessage');
        final messageModel = MessageModel.fromJson(decodedMessage);
        _controller.add(messageModel);
      },
      onDone: () {
        _controller.close();
      },
      onError: (error) {
        _controller.addError(error);
      },
    );

    // Wait until the connection is established
    await _webSocket.connection.firstWhere((state) => state is Connected);
  }

  void sendMessage(String senderId, String message) {
    final msg = jsonEncode({
      'sender_id': senderId,
      'message': message,
    });
    _webSocket.send(msg);
  }

  Future<void> disconnect() async {
    _webSocket.close(1000, 'CLOSE_NORMAL');
  }
}

Future<void> fetchChatThread(String userId, String token) async {
  final url = Uri.parse('http://43.205.89.79/api/v1/chats/threads/$userId');
  print('Requesting URL: $url');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Response data: $data');
  } else {
    print('Error: ${json.decode(response.body)['message']}');
    throw Exception(json.decode(response.body)['message']);
  }
}
