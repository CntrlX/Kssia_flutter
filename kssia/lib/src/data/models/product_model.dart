class Product {
  final String? id;
  final SellerId? sellerId;
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

  factory Product.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Product();

    return Product(
      id: json['_id'],
      sellerId: SellerId.fromJson(json['seller_id']),
      name: json['name'],
      image: json['image'],
      price: json['price'] as int,
      offerPrice: json['offer_price'] != null ? json['offer_price'] as int : 0,
      description: json['description'],
      moq: json['moq'],
      units: json['units'],
      status: json['status'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'seller_id': sellerId?.toJson(),
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

  Product copyWith({
    String? id,
    SellerId? sellerId,
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
