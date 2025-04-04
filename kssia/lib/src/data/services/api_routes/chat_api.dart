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


final socketIoClientProvider = Provider<SocketIoClient>((ref) {
  return SocketIoClient();
});


final messageStreamProvider = StreamProvider.autoDispose<MessageModel>((ref) {
  final socketIoClient = ref.read(socketIoClientProvider);
  return socketIoClient.messageStream;
});
class SocketIoClient {
  late IO.Socket _socket;
  StreamController<MessageModel>? _controller;

  SocketIoClient();

  Stream<MessageModel> get messageStream {
    _controller ??= StreamController<MessageModel>.broadcast();
    return _controller!.stream;
  }

  void connect(String senderId, WidgetRef ref) {
    final uri = 'wss://api.kssiathrissur.com/api/v1/chats?userId=$senderId';

    _socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(['websocket']) 
          .disableAutoConnect() 
          .build(),
    );

    log('Connecting to: $uri');

    _socket.onConnect((_) {
      log('Connected to: $uri');
      if (_controller == null || _controller!.isClosed) {
        _controller = StreamController<MessageModel>.broadcast();
      }
    });


    _socket.on('message', (data) {
      log(data.toString());
      print("I'm inside event listener");
      print('Received message: $data');
      log('Received message: ${data.toString()}');
      final messageModel = MessageModel.fromJson(data);

      ref.invalidate(fetchChatThreadProvider);

      if (_controller != null && !_controller!.isClosed) {
        _controller!.add(messageModel);
      }
    });

    _socket.on('connect_error', (error) {
      print('Connection Error: $error');
      if (_controller != null && !_controller!.isClosed) {
        _controller!.addError(error);
      }
    });

    _socket.onDisconnect((_) {
      print('Disconnected from server');
      _disposeController();
    });

    // Connect manually
    _socket.connect();
  }

  void disconnect() {
    log('I\'m inside disconnect');
    _socket.disconnect();
    _socket.dispose(); // To prevent memory leaks
    _disposeController();
  }

  void _disposeController() {
    if (_controller != null && !_controller!.isClosed) {
      _controller!.close();
    }
    _controller = null; 
  }
}

Future<void> deleteChat(String chatId) async {


  try {
    log('deleted message id:$chatId');
    final response = await http.delete(
      Uri.parse("$baseUrl/chats/delete/$chatId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      print('Chat deleted successfully.');
    } else {
      print('Failed to delete chat. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

Future<String> sendChatMessage(
    {required String userId,
    String? content,
    String? productId,
    String? requirementId}) async {
  final url = Uri.parse('$baseUrl/chats/send/$userId');
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
      final jsonResponse = json.decode(response.body);
      print('Message sent: ${response.body}');
      log('Message: ${jsonResponse['data']['_id']}');
      return jsonResponse['data']['_id'];
    } else {
      final jsonResponse = json.decode(response.body);

      print(jsonResponse['message']);
      print('Failed to send message: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    print('Error occurred: $e');
    return '';
  }
}

Future<List<MessageModel>> getMessages(
    {required String senderId, required String recieverId}) async {
  final String url =
      '$baseUrl/chats/messages/$senderId/$recieverId';
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

    log(messages.toString());

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
  final url = Uri.parse('$baseUrl/chats/threads');
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
