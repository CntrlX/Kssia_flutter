class Product {
  final String? id;
  final String? sellerId;
  final String? name;
  final String? image;
  final int? price;
  final int? offerPrice;
  final String? description;
  final int? moq;
  final int? units;
  final bool? status;
  final List<String>? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    this.sellerId,
    this.name,
    this.image,
    this.price,
    this.offerPrice,
    this.description,
    this.moq,
    this.units,
    this.status,
    this.tags,
    this.createdAt,
    this.updatedAt,
  });

  // fromJson method
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String?,
      sellerId: json['seller_id']['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: json['price'] as int?,
      offerPrice: json['offer_price'] as int?,
      description: json['description'] as String?,
      moq: json['moq'] as int?,
      units: json['units'] as int?,
      status: json['status'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
      'seller_id': sellerId,
      'name': name,
      'image': image,
      'price': price,
      'offer_price': offerPrice,
      'description': description,
      'moq': moq,
      'units': units,
      'status': status,
      'tags': tags,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // copyWith method
  Product copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? image,
    int? price,
    int? offerPrice,
    String? description,
    int? moq,
    int? units,
    bool? status,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      offerPrice: offerPrice ?? this.offerPrice,
      description: description ?? this.description,
      moq: moq ?? this.moq,
      units: units ?? this.units,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
