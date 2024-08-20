class User {
  final Name name;
  final String bloodGroup;
  final String email;
  final String profilePicture;
  final PhoneNumbers phoneNumbers;
  final String designation;
  final String companyName;
  final String companyEmail;
  final String bio;
  final Address address;
  final List<SocialMedia> socialMedia;
  final List<Website> websites;
  final List<Video> video;
  final List<Award> awards;
  final List<Product> products;
  final List<Certificate> certificates;
  final List<Brochure> brochure;

  User({
    required this.name,
    required this.bloodGroup,
    required this.email,
    required this.profilePicture,
    required this.phoneNumbers,
    required this.designation,
    required this.companyName,
    required this.companyEmail,
    required this.bio,
    required this.address,
    required this.socialMedia,
    required this.websites,
    required this.video,
    required this.awards,
    required this.products,
    required this.certificates,
    required this.brochure,
  });

  User copyWith({
    Name? name,
    String? bloodGroup,
    String? email,
    String? profilePicture,
    PhoneNumbers? phoneNumbers,
    String? designation,
    String? companyName,
    String? companyEmail,
    String? bio,
    Address? address,
    List<SocialMedia>? socialMedia,
    List<Website>? websites,
    List<Video>? video,
    List<Award>? awards,
    List<Product>? products,
    List<Certificate>? certificates,
    List<Brochure>? brochure,
  }) {
    return User(
      name: name ?? this.name,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      designation: designation ?? this.designation,
      companyName: companyName ?? this.companyName,
      companyEmail: companyEmail ?? this.companyEmail,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      socialMedia: socialMedia ?? this.socialMedia,
      websites: websites ?? this.websites,
      video: video ?? this.video,
      awards: awards ?? this.awards,
      products: products ?? this.products,
      certificates: certificates ?? this.certificates,
      brochure: brochure ?? this.brochure,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: Name.fromJson(json['name']),
      bloodGroup: json['blood_group'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      phoneNumbers: PhoneNumbers.fromJson(json['phone_numbers']),
      designation: json['designation'],
      companyName: json['company_name'],
      companyEmail: json['company_email'],
      bio: json['bio'],
      address: Address.fromJson(json['address']),
      socialMedia: (json['social_media'] as List)
          .map((i) => SocialMedia.fromJson(i))
          .toList(),
      websites:
          (json['websites'] as List).map((i) => Website.fromJson(i)).toList(),
      video: (json['video'] as List).map((i) => Video.fromJson(i)).toList(),
      awards: (json['awards'] as List).map((i) => Award.fromJson(i)).toList(),
      products:
          (json['products'] as List).map((i) => Product.fromJson(i)).toList(),
      certificates: (json['certificates'] as List)
          .map((i) => Certificate.fromJson(i))
          .toList(),
      brochure:
          (json['brochure'] as List).map((i) => Brochure.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'blood_group': bloodGroup,
      'email': email,
      'profile_picture': profilePicture,
      'phone_numbers': phoneNumbers.toJson(),
      'designation': designation,
      'company_name': companyName,
      'company_email': companyEmail,
      'bio': bio,
      'address': address.toJson(),
      'social_media': socialMedia.map((i) => i.toJson()).toList(),
      'websites': websites.map((i) => i.toJson()).toList(),
      'video': video.map((i) => i.toJson()).toList(),
      'awards': awards.map((i) => i.toJson()).toList(),
      'products': products.map((i)=> i.toJson()).toList(),
      'certificates': certificates.map((i) => i.toJson()).toList(),
      'brochure': brochure.map((i) => i.toJson()).toList(),
    };
  }
}

class Name {
  final String firstName;
  final String middleName;
  final String lastName;

  Name({
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  Name copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
  }) {
    return Name(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
    );
  }

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
    };
  }
}

class PhoneNumbers {
  final int personal;
  final int landline;
  final int companyPhoneNumber;
  final int whatsappNumber;
  final int whatsappBusinessNumber;

  PhoneNumbers({
    required this.personal,
    required this.landline,
    required this.companyPhoneNumber,
    required this.whatsappNumber,
    required this.whatsappBusinessNumber,
  });

  PhoneNumbers copyWith({
    int? personal,
    int? landline,
    int? companyPhoneNumber,
    int? whatsappNumber,
    int? whatsappBusinessNumber,
  }) {
    return PhoneNumbers(
      personal: personal ?? this.personal,
      landline: landline ?? this.landline,
      companyPhoneNumber: companyPhoneNumber ?? this.companyPhoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      whatsappBusinessNumber:
          whatsappBusinessNumber ?? this.whatsappBusinessNumber,
    );
  }

  factory PhoneNumbers.fromJson(Map<String, dynamic> json) {
    return PhoneNumbers(
      personal: json['personal'],
      landline: json['landline'],
      companyPhoneNumber: json['company_phone_number'],
      whatsappNumber: json['whatsapp_number'],
      whatsappBusinessNumber: json['whatsapp_business_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personal': personal,
      'landline': landline,
      'company_phone_number': companyPhoneNumber,
      'whatsapp_number': whatsappNumber,
      'whatsapp_business_number': whatsappBusinessNumber,
    };
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zip;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
  });

  Address copyWith({
    String? street,
    String? city,
    String? state,
    String? zip,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }
}

class SocialMedia {
  final String platform;
  final String url;

  SocialMedia({
    required this.platform,
    required this.url,
  });

  SocialMedia copyWith({
    String? platform,
    String? url,
  }) {
    return SocialMedia(
      platform: platform ?? this.platform,
      url: url ?? this.url,
    );
  }

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      platform: json['platform'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
    };
  }
}

class Website {
  final String name;
  final String url;

  Website({
    required this.name,
    required this.url,
  });

  Website copyWith({
    String? name,
    String? url,
  }) {
    return Website(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class Video {
  final String name;
  final String url;

  Video({
    required this.name,
    required this.url,
  });

  Video copyWith({
    String? name,
    String? url,
  }) {
    return Video(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class Award {
  final String name;
  final String url;
  final String authorityName;

  Award({required this.name, required this.url, required this.authorityName});

  Award copyWith({String? name, String? url, String? authorityName}) {
    return Award(
      name: name ?? this.name,
      url: url ?? this.url,
      authorityName: authorityName ?? this.authorityName,
    );
  }

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      name: json['name'],
      url: json['url'],
      authorityName: json['authority_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url, 'authority_name': authorityName};
  }
}

class Certificate {
  final String name;
  final String url;

  Certificate({
    required this.name,
    required this.url,
  });

  Certificate copyWith({
    String? name,
    String? url,
  }) {
    return Certificate(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class Brochure {
  final String name;
  final String url;

  Brochure({
    required this.name,
    required this.url,
  });

  Brochure copyWith({
    String? name,
    String? url,
  }) {
    return Brochure(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Brochure.fromJson(Map<String, dynamic> json) {
    return Brochure(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class Product {
  final String id;
  final String sellerId;
  final String name;
  final String image;
  final double price;
  final double offerPrice;
  final String description;
  final int moq;
  final String units;
  final String status;
  final List<String> tags;

  Product({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.image,
    required this.price,
    required this.offerPrice,
    required this.description,
    required this.moq,
    required this.units,
    required this.status,
    required this.tags,
  });

  Product copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? image,
    double? price,
    double? offerPrice,
    String? description,
    int? moq,
    String? units,
    String? status,
    List<String>? tags,
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
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String,
      sellerId: json['seller_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as double,
      offerPrice: json['offer_price'] as double,
      description: json['description'] as String,
      moq: json['moq'] as int,
      units: json['units'] as String,
      status: json['status'] as String,
      tags: List<String>.from(json['tags']),
    );
  }

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
    };
  }
}
