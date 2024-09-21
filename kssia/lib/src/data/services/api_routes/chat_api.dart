import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:kssia/src/data/models/msg_model.dart';

part 'chat_api.g.dart';

// Define a Socket.IO client providerr
final socketIoClientProvider = Provider<SocketIoClient>((ref) {
  return SocketIoClient();
});

// Define a message stream provider
final messageStreamProvider = StreamProvider.autoDispose<MessageModel>((ref) {
  final socketIoClient = ref.read(socketIoClientProvider);
  return socketIoClient.messageStream;
});

class SocketIoClient {
  late IO.Socket _socket;
  final _controller = StreamController<MessageModel>.broadcast();

  SocketIoClient();

  Stream<MessageModel> get messageStream => _controller.stream;

  void connect(String senderId, WidgetRef ref) {
    final uri = 'http://43.205.89.79/api/v1/chats?userId=$senderId';

    // Initialize socket.io client
    _socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket transport
          .disableAutoConnect() // Disable auto-connect
          .build(),
    );

    log('Connecting to: $uri');

    // Listen for connection events
    _socket.onConnect((_) {
      log('Connected to: $uri');
    });

    // Listen to messages from the server
    _socket.on('message', (data) {
      log(data.toString());
      print("im inside event listener");
      print('Received message: $data');
      log(' Received message${data.toString()}');
      final messageModel = MessageModel.fromJson(data);

      // Invalidate the fetchChatThreadProvider when a new message is received
      ref.invalidate(fetchChatThreadProvider);

      if (!_controller.isClosed) {
        _controller.add(messageModel);
      }
    });

    // Handle connection errors
    _socket.on('connect_error', (error) {
      print('Connection Error: $error');
      if (!_controller.isClosed) {
        _controller.addError(error);
      }
    });

    // Handle disconnection
    _socket.onDisconnect((_) {
      print('Disconnected from server');
      if (!_controller.isClosed) {
        _controller.close();
      }
    });

    // Connect manually
    _socket.connect();
  }

  void disconnect() {
    log('im inside disconnect');
    _socket.disconnect();
    _socket.dispose(); // To prevent memory leaks
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}

Future<void> sendChatMessage(
    {required String userId,
    String? content,
    String? productId,
    String? requirementId}) async {
  final url = Uri.parse('http://43.205.89.79/api/v1/chats/send/$userId');
  final headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({
    if (content != null) 'content': content,
    if (productId != null) 'product': productId,
    if (requirementId != null) 'requirement': requirementId
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Successfully sent the message
      print('Message sent: ${response.body}');
    } else {
      final jsonResponse = json.decode(response.body);

      print(jsonResponse['message']);
      print('Failed to send message: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<List<MessageModel>> getMessages(
    {required String senderId, required String recieverId}) async {
  final String url =
      'http://43.205.89.79/api/v1/chats/messages/$senderId/$recieverId';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Parse the JSON data
    final messages = json.decode(response.body)['data'];
    // Handle the messages data as per your needs

    print(messages);

    return messages
        .map<MessageModel>((item) => MessageModel.fromJson(item))
        .toList();
  } else {
    // Handle the error
    print('Failed to load messages. Status code: ${response.body}');
    throw Exception('Failed to load messages');
  }
}

@riverpod
Future<List<ChatModel>> fetchChatThread(
    FetchChatThreadRef ref, String token) async {
  final url = Uri.parse('http://43.205.89.79/api/v1/chats/threads');
  print('Requesting URL: $url');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body)['data'];
    log('Response data: $data');
    final List<ChatModel> chats =
        await data.map<ChatModel>((item) => ChatModel.fromJson(item)).toList();

    return chats;
  } else {
    print('Error: ${json.decode(response.body)['message']}');
    throw Exception(json.decode(response.body)['message']);
  }
}
