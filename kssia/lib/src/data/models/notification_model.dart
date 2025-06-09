class NotificationModel {
  String? id;
  List<String>? to;
  String? subject;
  String? content;
  String? fileUrl;
  String? linkUrl;
  String? pageName;
  String? type;
  String? itemId;
  List<String>? readBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  NotificationModel({
    this.id,
    this.to,
    this.subject,
    this.content,
    this.fileUrl,
    this.linkUrl,
    this.pageName,
    this.type,
    this.itemId,
    this.readBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String?,
      to: (json['to'] as List<dynamic>?)?.map((e) => e as String).toList(),
      subject: json['subject'] as String?,
      content: json['content'] as String?,
      fileUrl: json['file_url'] as String?,
      linkUrl: json['link_url'] as String?,
      pageName: json['pageName'] as String?,
      type: json['type'] as String?,
      itemId: json['itemId'] as String?,
      readBy: (json['readBy'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'to': to,
      'subject': subject,
      'content': content,
      'file_url': fileUrl,
      'link_url': linkUrl,
      'pageName': pageName,
      'type': type,
      'itemId': itemId,
      'readBy': readBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}