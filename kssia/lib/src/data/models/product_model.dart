class Product {
  final String? id;
  final SellerId? sellerId;
  final String? name;
  final String? image;
  final double? price;
  final double? offerPrice;
  final String? description;
  final int? moq;
  final String? units;
  final String? status;
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

  double? _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return null;
  }

  return Product(
    id: json['_id'],
    sellerId: SellerId.fromJson(json['seller_id']),
    name: json['name'],
    image: json['image'],
    price: _toDouble(json['price']),
    offerPrice: _toDouble(json['offer_price']),
    description: json['description'],
    moq: json['moq'],
    units: json['units'],
    status: json['status'],
    tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
    double? price,
    double? offerPrice,
    String? description,
    int? moq,
    String? units,
    String? status,
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

class SellerId {
  final String? id;
  final String? name;
  final String? membershipId;

  SellerId({this.id, this.name, this.membershipId});

  factory SellerId.fromJson(dynamic json) {
    if (json == null) return SellerId();

    if (json is String) {
      return SellerId(id: json);
    } else if (json is Map<String, dynamic>) {
      return SellerId(
        id: json['_id'],
        name: json['name'] ?? '',
        membershipId: json['membership_id'],
      );
    }
    throw Exception("Invalid type for seller_id");
  }

  dynamic toJson() {
    if (name != null) {
      return {
        '_id': id,
        'name': name,
        'membership_id': membershipId,
      };
    } else {
      return id;
    }
  }

  SellerId copyWith({
    String? id,
    String? name,
    String? membershipId,
  }) {
    return SellerId(
      id: id ?? this.id,
      name: name ?? this.name,
      membershipId: membershipId ?? this.membershipId,
    );
  }
}

// class SellerName {
//   final String? firstName;
//   final String? middleName;
//   final String? lastName;

//   SellerName({
//     this.firstName,
//     this.middleName,
//     this.lastName,
//   });

//   factory SellerName.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return SellerName();

//     return SellerName(
//       firstName: json['first_name'],
//       middleName: json['middle_name'],
//       lastName: json['last_name'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'first_name': firstName,
//       'middle_name': middleName,
//       'last_name': lastName,
//     };
//   }

//   SellerName copyWith({
//     String? firstName,
//     String? middleName,
//     String? lastName,
//   }) {
//     return SellerName(
//       firstName: firstName ?? this.firstName,
//       middleName: middleName ?? this.middleName,
//       lastName: lastName ?? this.lastName,
//     );
//   }
// }
