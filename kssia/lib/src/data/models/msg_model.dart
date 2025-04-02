class MessageModel {
  String? id;
  String? from;
  String? to;
  String? content;
  List<String>? attachments;
  String? status;
  DateTime? timestamp;
  ChatRequirement? requirement;
  ChatProduct? product;
  int? version;

  MessageModel({
    this.id,
    this.from,
    this.to,
    this.content,
    this.attachments,
    this.status,
    this.timestamp,
    this.requirement,
    this.product,
    this.version,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      from: json['from'],
      to: json['to'],
      content: json['content'],
      attachments: json['attachments'] != null ? List<String>.from(json['attachments']) : null,
      status: json['status'],
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
      requirement: json['requirement'] != null ? ChatRequirement.fromJson(json['requirement']) : null,
      product: json['product'] != null ? ChatProduct.fromJson(json['product']) : null,
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'from': from,
      'to': to,
      'content': content,
      'attachments': attachments,
      'status': status,
      'timestamp': timestamp?.toIso8601String(),
      'requirement': requirement?.toJson(),
      'product': product?.toJson(),
      '__v': version,
    };
  }
}

class ChatRequirement {
  String? id;
  String? image;
  String? content;

  ChatRequirement({this.id, this.image, this.content});

  factory ChatRequirement.fromJson(Map<String, dynamic> json) {
    return ChatRequirement(
      id: json['_id'],
      image: json['image'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': image,
      'content': content,
    };
  }
}

class ChatProduct {
  String? id;
  String? name;
  String? image;
  double? price;

  ChatProduct({this.id, this.name, this.image, this.price});

  factory ChatProduct.fromJson(Map<String, dynamic> json) {
    return ChatProduct(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'price': price,
    };
  }
}
