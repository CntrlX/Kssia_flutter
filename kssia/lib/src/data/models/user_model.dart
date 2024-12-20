import 'package:flutter/foundation.dart';
import 'package:kssia/src/data/models/product_model.dart';

// class Name {
//   final String? firstName;
//   final String? middleName;
//   final String? lastName;

//   Name({
//     this.firstName,
//     this.middleName,
//     this.lastName,
//   });

//   factory Name.fromJson(Map<String, dynamic> json) {
//     return Name(
//       firstName: json['first_name'] as String?,
//       middleName: json['middle_name'] as String?,
//       lastName: json['last_name'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'first_name': firstName,
//       'middle_name': middleName,
//       'last_name': lastName,
//     };
//   }

//   Name copyWith({
//     String? firstName,
//     String? middleName,
//     String? lastName,
//   }) {
//     return Name(
//       firstName: firstName ?? this.firstName,
//       middleName: middleName ?? this.middleName,
//       lastName: lastName ?? this.lastName,
//     );
//   }
// }

class PhoneNumbers {
  final String? personal;
  final String? landline;
  final String? companyPhoneNumber;
  final String? whatsappNumber;
  final String? whatsappBusinessNumber;

  PhoneNumbers({
    this.personal,
    this.landline,
    this.companyPhoneNumber,
    this.whatsappNumber,
    this.whatsappBusinessNumber,
  });

  factory PhoneNumbers.fromJson(Map<String, dynamic> json) {
    return PhoneNumbers(
      personal: json['personal'] as String?,
      landline: json['landline'] as String?,
      companyPhoneNumber: json['company_phone_number'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      whatsappBusinessNumber: json['whatsapp_business_number'] as String?,
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

  PhoneNumbers copyWith({
    String? personal,
    String? landline,
    String? companyPhoneNumber,
    String? whatsappNumber,
    String? whatsappBusinessNumber,
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
}

class Website {
  final String? name;
  final String? url;

  Website({
    this.name,
    this.url,
  });

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  Website copyWith({
    String? name,
    String? url,
  }) {
    return Website(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }
}

class SocialMedia {
  final String? platform;
  final String? url;
  final String? id;

  SocialMedia({
    this.platform,
    this.url,
    this.id,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      platform: json['platform'] as String?,
      url: json['url'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
      '_id': id,
    };
  }

  SocialMedia copyWith({
    String? platform,
    String? url,
    String? id,
  }) {
    return SocialMedia(
      platform: platform ?? this.platform,
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }
}

class Video {
  final String? name;
  final String? url;

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
  final String? name;
  final String? url;
  final String? authorityName;

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
  final String? name;
  final String? url;

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
  final String? name;
  final String? url;

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

class UserModel {
  final String? id;
  final String? abbreviation;
  final String? membershipId;
  final String? name;
  final PhoneNumbers? phoneNumbers;
  final String? bloodGroup;
  final String? email;
  final String? designation;
  final String? companyName;
  final String? companyEmail;
  final String? businessCategory;
  final String? subCategory;
  final String? bio;
  final String? address;
  final List<Website>? websites;
  final String? status;
  final bool? isActive;
  final bool? isDeleted;
  final String? selectedTheme;
  final List<SocialMedia>? socialMedia;
  final List<Video>? video;
  final List<Award>? awards;
  final List<Certificate>? certificates;
  final List<Brochure>? brochure;
  final List<Review>? reviews; // Added reviews field

  final String? companyAddress;
  final String? companyLogo;
  final String? profilePicture;
  final List<Product>? products;
  final List<BlockedUser>? blockedUsers;

  UserModel(
      {this.id,
      this.abbreviation,
      this.membershipId,
      this.name,
      this.phoneNumbers,
      this.bloodGroup,
      this.email,
      this.designation,
      this.companyName,
      this.companyEmail,
      this.businessCategory,
      this.subCategory,
      this.bio,
      this.address,
      this.websites,
      this.status,
      this.isActive,
      this.isDeleted,
      this.selectedTheme,
      this.socialMedia,
      this.video,
      this.awards,
      this.certificates,
      this.brochure,
      this.reviews, // Initialize reviews
      this.companyAddress,
      this.companyLogo,
      this.profilePicture,
      this.products,
      this.blockedUsers});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      membershipId: json['membership_id'] as String?,
      abbreviation: json['abbreviation'] as String?,
      name: json['name'] as String?,
      phoneNumbers: json['phone_numbers'] != null
          ? PhoneNumbers.fromJson(json['phone_numbers'])
          : null,
      bloodGroup: json['blood_group'] as String?,
      email: json['email'] as String?,
      designation: json['designation'] as String?,
      companyName: json['company_name'] as String?,
      companyEmail: json['company_email'] as String?,
      businessCategory: json['business_category'] as String?,
      subCategory: json['sub_category'] as String?,
      bio: json['bio'] as String?,
      address: json['address'] as String?,
      websites: (json['websites'] as List<dynamic>?)
          ?.map((e) => Website.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      isActive: json['is_active'] as bool?,
      isDeleted: json['is_deleted'] as bool?,
      selectedTheme: json['selectedTheme'] as String?,
      socialMedia: (json['social_media'] as List<dynamic>?)
          ?.map((e) => SocialMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      video: (json['video'] as List<dynamic>?)
          ?.map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
      awards: (json['awards'] as List<dynamic>?)
          ?.map((e) => Award.fromJson(e as Map<String, dynamic>))
          .toList(),
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((e) => Certificate.fromJson(e as Map<String, dynamic>))
          .toList(),
      brochure: (json['brochure'] as List<dynamic>?)
          ?.map((e) => Brochure.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(), // Parse reviews

      companyAddress: json['company_address'] as String?,
      companyLogo: json['company_logo'] as String?,
      profilePicture: json['profile_picture'] as String?,
      products: json['products'] == 'Seller has no products'
          ? []
          : (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList(),
      blockedUsers: (json['blocked_users'] as List<dynamic>?)
          ?.map((e) => BlockedUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'membership_id': membershipId,
      'abbreviation': abbreviation,
      'name': name,
      'phone_numbers': phoneNumbers?.toJson(),
      'blood_group': bloodGroup,
      'email': email,
      'designation': designation,
      'company_name': companyName,
      'company_email': companyEmail,
      'business_category': businessCategory,
      'sub_category': subCategory,
      'bio': bio,
      'address': address,
      'websites': websites?.map((e) => e.toJson()).toList(),
      'status': status,
      'is_active': isActive,
      'is_deleted': isDeleted,
      'selectedTheme': selectedTheme,
      'social_media': socialMedia?.map((e) => e.toJson()).toList(),
      'video': video?.map((e) => e.toJson()).toList(),
      'awards': awards?.map((e) => e.toJson()).toList(),
      'certificates': certificates?.map((e) => e.toJson()).toList(),
      'brochure': brochure?.map((e) => e.toJson()).toList(),
      'reviews': reviews?.map((e) => e.toJson()).toList(), // Serialize reviews

      'company_address': companyAddress,
      'company_logo': companyLogo,
      'profile_picture': profilePicture,
      'products': products?.map((e) => e.toJson()).toList(),
      'blocked_users': blockedUsers
    };
  }

  UserModel copyWith({
    String? id,
    String? membershipId,
    String? abbreviation,
    String? name,
    PhoneNumbers? phoneNumbers,
    String? bloodGroup,
    String? email,
    String? designation,
    String? companyName,
    String? companyEmail,
    String? businessCategory,
    String? subCategory,
    String? bio,
    String? address,
    List<Website>? websites,
    String? status,
    bool? isActive,
    bool? isDeleted,
    String? selectedTheme,
    List<SocialMedia>? socialMedia,
    List<Video>? video,
    List<Award>? awards,
    List<Certificate>? certificates,
    List<Brochure>? brochure,
    List<Review>? reviews,
    String? createdAt,
    String? updatedAt,
    String? companyAddress,
    String? companyLogo,
    String? profilePicture,
    List<Product>? products,
    List<BlockedUser>? blockedUsers,
  }) {
    return UserModel(
        id: id ?? this.id,
        membershipId: membershipId ?? this.membershipId,
        abbreviation: abbreviation ?? this.abbreviation,
        name: name ?? this.name,
        phoneNumbers: phoneNumbers ?? this.phoneNumbers,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        email: email ?? this.email,
        designation: designation ?? this.designation,
        companyName: companyName ?? this.companyName,
        companyEmail: companyEmail ?? this.companyEmail,
        businessCategory: businessCategory ?? this.businessCategory,
        subCategory: subCategory ?? this.subCategory,
        bio: bio ?? this.bio,
        address: address ?? this.address,
        websites: websites ?? this.websites,
        status: status ?? this.status,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        selectedTheme: selectedTheme ?? this.selectedTheme,
        socialMedia: socialMedia ?? this.socialMedia,
        video: video ?? this.video,
        awards: awards ?? this.awards,
        certificates: certificates ?? this.certificates,
        brochure: brochure ?? this.brochure,
        reviews: reviews ?? this.reviews, // Assign reviews

        companyAddress: companyAddress ?? this.companyAddress,
        companyLogo: companyLogo ?? this.companyLogo,
        profilePicture: profilePicture ?? this.profilePicture,
        products: products ?? this.products,
        blockedUsers: blockedUsers ?? this.blockedUsers);
  }
}

class Review {
  final String? id;
  final Reviewer? reviewer;
  final String? content;
  final int? rating;

  Review({
    this.id,
    this.reviewer,
    this.content,
    this.rating,
  });
//arawvr
//arawvr
//arawvr
//arawvr
  // Factory method to create a Review instance from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] as String?,
      reviewer: json['reviewer'] != null
          ? Reviewer.fromJson(json['reviewer'] as Map<String, dynamic>)
          : null,
      content: json['content'] as String?,
      rating: json['rating'] as int?,
    );
  }

  // Method to convert a Review instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reviewer': reviewer?.toJson(),
      'content': content,
      'rating': rating
    };
  }
}

class Reviewer {
  final String? id;
  final String? name;
  final String? profilePicture;

  Reviewer({
    this.id,
    this.name,
    this.profilePicture,
  });

  // Factory method to create a Reviewer instance from JSON
  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      profilePicture: json['profile_picture'] as String?,
    );
  }

  // Method to convert a Reviewer instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profile_picture': profilePicture,
    };
  }
}

class BlockedUser {
  final String userId;
  final String reason;
  final String id;

  BlockedUser({
    required this.userId,
    required this.reason,
    required this.id,
  });

  // Factory constructor to create a BlockedUser instance from a JSON object
  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      userId: json['userId'] as String,
      reason: json['reason'] as String,
      id: json['_id'] as String,
    );
  }

  // Method to convert a BlockedUser instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'reason': reason,
      '_id': id,
    };
  }
}
