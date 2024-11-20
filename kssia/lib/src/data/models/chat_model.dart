class Participant {
  final String? id;
  final String? name;
  final String? profilePicture;

  Participant({
    this.id,
    this.name,
    this.profilePicture,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id ?? '',
      'name': name ?? '',
      'profile_picture': profilePicture ?? '',
    };
  }
}

class Message {
  final String? id;
  final String? from;
  final String? to;
  final String? content;
  final List<dynamic>? attachments;
  final String? status;
  final DateTime? timestamp;

  Message({
    this.id,
    this.from,
    this.to,
    this.content,
    this.attachments,
    this.status,
    this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      content: json['content'] ?? '',
      attachments: json['attachments'] ?? [],
      status: json['status'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id ?? '',
      'from': from ?? '',
      'to': to ?? '',
      'content': content ?? '',
      'attachments': attachments ?? [],
      'status': status ?? '',
      'timestamp':
          timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
}

class ChatModel {
  final String? id;
  final List<Participant>? participants;
  final List<Message>? lastMessage;
  final Map<String, int>? unreadCount;
  final DateTime? createdAt;
  final int? version;

  ChatModel({
    this.id,
    this.participants,
    this.lastMessage,
    this.unreadCount,
    this.createdAt,
    this.version,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      participants: (json['participants'] as List?)
              ?.map((participant) => Participant.fromJson(participant))
              .toList() ??
          [],
      lastMessage: (json['lastMessage'] as List?)
              ?.map((message) => Message.fromJson(message))
              .toList() ??
          [],
      unreadCount: Map<String, int>.from(json['unreadCount'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id ?? '',
      'participants': participants?.map((p) => p.toJson()).toList() ?? [],
      'lastMessage': lastMessage?.map((m) => m.toJson()).toList() ?? [],
      'unreadCount': unreadCount ?? {},
      'createdAt':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      '__v': version ?? 0,
    };
  }
}
