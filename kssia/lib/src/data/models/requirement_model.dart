class Requirement {
  final String? id;
  final Author? author;
  final String? image;
  final String? content;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Requirement({
    this.id,
    this.author,
    this.image,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Requirement copyWith({
    String? id,
    Author? author,
    String? image,
    String? content,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Requirement(
      id: id ?? this.id,
      author: author ?? this.author,
      image: image ?? this.image,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      id: json['_id'] as String?,
      author: json['author'] != null
          ? Author.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      image: json['image'] as String?,
      content: json['content'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'author': author?.toJson(),
      'image': image,
      'content': content,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Author {
  final String? id;
  final String? name;
  final String? email;

  Author({
    this.id,
    this.name,
    this.email,
  });

  Author copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return Author(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}
