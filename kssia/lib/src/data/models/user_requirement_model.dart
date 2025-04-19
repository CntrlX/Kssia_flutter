class UserRequirementModel {
  final String? id;
  final String? author;
  final String? image;
  final String? content;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? reason;

  const UserRequirementModel({
    this.id,
    this.author,
    this.image,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.reason,
  });

  UserRequirementModel copyWith({
    String? id,
    String? author,
    String? image,
    String? content,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reason,
  }) {
    return UserRequirementModel(
      id: id ?? this.id,
      author: author ?? this.author,
      image: image ?? this.image,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reason: reason ?? this.reason,
    );
  }
factory UserRequirementModel.fromJson(Map<String, dynamic> json) {
  return UserRequirementModel(
    id: json["_id"] as String?, // allow null
    author: json["author"] as String?,
    image: json["image"] as String?, // this can be null or missing
    content: json["content"] as String?,
    status: json["status"] as String?,
    createdAt: json["createdAt"] != null
        ? DateTime.tryParse(json["createdAt"])
        : null,
    updatedAt: json["updatedAt"] != null
        ? DateTime.tryParse(json["updatedAt"])
        : null,
    reason: json["reason"] as String?,
  );
}

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "author": author,
      "image": image,
      "content": content,
      "status": status,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "reason": reason,
    };
  }
}
