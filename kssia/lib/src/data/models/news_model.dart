class News {
  final String? id;
  final String? category;
  final String? title;
  final String? image;
  final String? content;
  final String? pdf;
  final bool? published;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  News({
    this.id,
    this.category,
    this.title,
    this.image,
    this.content,
    this.pdf,    
    this.published,
    this.createdAt,
    this.updatedAt,
  });

  // fromJson method
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String?,
      image: json['image'] as String?,
      content: json['content'] as String?,
      pdf: json['pdf'] as String?,   
      published: json['published'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'title': title,
      'image': image,
      'content': content,
      'pdf': pdf,    
      'published': published,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}