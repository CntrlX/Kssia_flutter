class Product {
  final String? id;
  final String? name;
  final double? price;
  final double? offerPrice;
  final String? description;
  final String? sellerId;
  final int? moq; // Minimum Order Quantity
  final String? category;
  final List<String>? subcategory;
  final String? status;
  final String? units;
  final String? image;

  Product({
    this.id,
    this.name,
    this.price,
    this.offerPrice,
    this.description,
    this.sellerId,
    this.moq,
    this.category,
    this.subcategory,
    this.status,
    this.units,
    this.image,
  });

  /// Factory method to create a Product instance from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : null,
      offerPrice: (json['offer_price'] != null) ? (json['offer_price'] as num).toDouble() : null,
      description: json['description'] as String?,
      sellerId: json['seller_id'] as String?,
      moq: json['moq'] as int?,
      category: json['category'] as String?,
      subcategory: (json['subcategory'] != null)
          ? List<String>.from(json['subcategory'])
          : null,
      status: json['status'] as String?,
      units: json['units'] as String?,
      image: json['image'] as String?,
    );
  }

  /// Method to convert a Product instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'offer_price': offerPrice,
      'description': description,
      'seller_id': sellerId,
      'moq': moq,
      'category': category,
      'subcategory': subcategory,
      'status': status,
      'units': units,
      'image': image,
    };
  }

  /// CopyWith method for creating a modified copy of the Product instance
  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? offerPrice,
    String? description,
    String? sellerId,
    int? moq,
    String? category,
    List<String>? subcategory,
    String? status,
    String? units,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      offerPrice: offerPrice ?? this.offerPrice,
      description: description ?? this.description,
      sellerId: sellerId ?? this.sellerId,
      moq: moq ?? this.moq,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      status: status ?? this.status,
      units: units ?? this.units,
      image: image ?? this.image,
    );
  }
}


class ProductCategoryModel {
  final int count;
  final String name;

  ProductCategoryModel({
    required this.count,
    required this.name,
  });

  /// Factory constructor to create an instance from JSON.
  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      count: json['count'] ?? 0, // Default to 0 if null
      name: json['name'] ?? '', // Default to an empty string if null
    );
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'name': name,
    };
  }

  /// Creates a copy of the instance with updated values.
  ProductCategoryModel copyWith({
    int? count,
    String? name,
  }) {
    return ProductCategoryModel(
      count: count ?? this.count,
      name: name ?? this.name,
    );
  }
}
