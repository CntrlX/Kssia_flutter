import 'dart:convert';

class Event {
  final String? id;
  final String? type;
  final String? name;
  final String? image;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? venue;
  final String? organiserName;
  final String? organiserCompanyName;
  final String? organiserRole;
  final List<Speaker>? speakers;
  final String? status;
  final List<RSVP>? rsvp;
  final bool? activate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;
  final String? meetingLink;

  Event({
    this.id,
    this.type,
    this.name,
    this.image,
    this.description,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.venue,
    this.organiserName,
    this.organiserCompanyName,
    this.organiserRole,
    this.speakers,
    this.status,
    this.rsvp,
    this.activate,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.meetingLink,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      endTime:
          json['endTime'] != null ? DateTime.tryParse(json['endTime']) : null,
      venue: json['venue'] as String?,
      organiserName: json['organiser_name'] as String?,
      organiserCompanyName: json['organiser_company_name'] as String?,
      organiserRole: json['organiser_role'] as String?,
      speakers:
          (json['speakers'] as List?)?.map((e) => Speaker.fromJson(e)).toList(),
      status: json['status'] as String?,
      rsvp: (json['rsvp'] as List?)?.map((e) => RSVP.fromJson(e)).toList(),
      activate: json['activate'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      version: json['__v'] as int?,
      meetingLink: json['meetingLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'name': name,
      'image': image,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'venue': venue,
      'organiser_name': organiserName,
      'organiser_company_name': organiserCompanyName,
      'organiser_role': organiserRole,
      'speakers': speakers?.map((e) => e.toJson()).toList(),
      'status': status,
      'rsvp': rsvp?.map((e) => e.toJson()).toList(),
      'activate': activate,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
      'meetingLink': meetingLink,
    };
  }
}

class Speaker {
  final String? speakerName;
  final String? speakerDesignation;
  final String? speakerImage;
  final String? speakerRole;
  final String? id;

  Speaker({
    this.speakerName,
    this.speakerDesignation,
    this.speakerImage,
    this.speakerRole,
    this.id,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      speakerName: json['speaker_name'] as String?,
      speakerDesignation: json['speaker_designation'] as String?,
      speakerImage: json['speaker_image'] as String?,
      speakerRole: json['speaker_role'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speaker_name': speakerName,
      'speaker_designation': speakerDesignation,
      'speaker_image': speakerImage,
      'speaker_role': speakerRole,
      '_id': id,
    };
  }
}

class RSVP {
  final String? id;
  final String? name;
  final PhoneNumbers? phoneNumbers;
  final String? companyName;

  RSVP({
    this.id,
    this.name,
    this.phoneNumbers,
    this.companyName,
  });

  factory RSVP.fromJson(Map<String, dynamic> json) {
    return RSVP(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      phoneNumbers: json['phone_numbers'] != null
          ? PhoneNumbers.fromJson(json['phone_numbers'])
          : null,
      companyName: json['company_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone_numbers': phoneNumbers?.toJson(),
      'company_name': companyName,
    };
  }
}

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
}
