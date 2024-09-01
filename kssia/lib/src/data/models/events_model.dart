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
  final String? platform;
  final String? meetingLink;
  final String? organiserName;
  final String? organiserCompanyName;
  final String? guestImage;
  final String? organiserRole;
  final List<Speaker>? speakers;
  final String? status;
  final List<String>? rsvp;
  final bool? activate;

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
    this.platform,
    this.meetingLink,
    this.organiserName,
    this.organiserCompanyName,
    this.guestImage,
    this.organiserRole,
    this.speakers,
    this.status,
    this.rsvp,
    this.activate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      type: json['type'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      platform: json['platform'],
      meetingLink: json['meeting_link'],
      organiserName: json['organiser_name'],
      organiserCompanyName: json['organiser_company_name'],
      guestImage: json['guest_image'],
      organiserRole: json['organiser_role'],
      speakers: json['speakers'] != null
          ? (json['speakers'] as List).map((i) => Speaker.fromJson(i)).toList()
          : null,
      status: json['status'],
      rsvp: json['rsvp'] != null ? List<String>.from(json['rsvp']) : null,
      activate: json['activate'],
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
      'platform': platform,
      'meeting_link': meetingLink,
      'organiser_name': organiserName,
      'organiser_company_name': organiserCompanyName,
      'guest_image': guestImage,
      'organiser_role': organiserRole,
      'speakers': speakers?.map((i) => i.toJson()).toList(),
      'status': status,
      'rsvp': rsvp,
      'activate': activate,
    };
  }

  Event copyWith({
    String? id,
    String? type,
    String? name,
    String? image,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startTime,
    DateTime? endTime,
    String? platform,
    String? meetingLink,
    String? organiserName,
    String? organiserCompanyName,
    String? guestImage,
    String? organiserRole,
    List<Speaker>? speakers,
    String? status,
    List<String>? rsvp,
    bool? activate,
  }) {
    return Event(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      platform: platform ?? this.platform,
      meetingLink: meetingLink ?? this.meetingLink,
      organiserName: organiserName ?? this.organiserName,
      organiserCompanyName: organiserCompanyName ?? this.organiserCompanyName,
      guestImage: guestImage ?? this.guestImage,
      organiserRole: organiserRole ?? this.organiserRole,
      speakers: speakers ?? this.speakers,
      status: status ?? this.status,
      rsvp: rsvp ?? this.rsvp,
      activate: activate ?? this.activate,
    );
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
      speakerName: json['speaker_name'],
      speakerDesignation: json['speaker_designation'],
      speakerImage: json['speaker_image'],
      speakerRole: json['speaker_role'],
      id: json['_id'],
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

  Speaker copyWith({
    String? speakerName,
    String? speakerDesignation,
    String? speakerImage,
    String? speakerRole,
    String? id,
  }) {
    return Speaker(
      speakerName: speakerName ?? this.speakerName,
      speakerDesignation: speakerDesignation ?? this.speakerDesignation,
      speakerImage: speakerImage ?? this.speakerImage,
      speakerRole: speakerRole ?? this.speakerRole,
      id: id ?? this.id,
    );
  }
}
