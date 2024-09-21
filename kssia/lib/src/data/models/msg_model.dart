class MessageModel {
  String status;
  String message;
  DateTime? time;
  String fromId;
  final ChatProduct? product;
  MessageModel(
      {required this.message,
      required this.status,
      required this.fromId,
      required this.time,
          this.product,});
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(      product: json['product'] != null ? ChatProduct.fromJson(json['product']) : null,
      message: json['content'],
      status: json['status'],
      time:  json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      fromId: json['from'],
    );
  }
}


class ChatProduct {
  final String? id;
  final String? media;

  ChatProduct({
    this.id,
    this.media,
  });

  // fromJson method
  factory ChatProduct.fromJson(Map<String, dynamic> json) {
    return ChatProduct(
      id: json['_id'] as String?,
      media: json['media'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'media': media,
    };
  }
}
