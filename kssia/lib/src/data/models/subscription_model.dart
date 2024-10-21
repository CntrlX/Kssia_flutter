class Subscription {
  final Membership? membership;
  final App? app;

  Subscription({
    this.membership,
    this.app,
  });

  // fromJson factory method
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      membership: json['Membership'] != null
          ? Membership.fromJson(json['Membership'])
          : null,
      app: json['App'] != null ? App.fromJson(json['App']) : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'Membership': membership?.toJson(),
      'App': app?.toJson(),
    };
  }
}

class Membership {
  final DateTime? lastRenewed;
  final DateTime? nextRenewal;
  final String? status;

  Membership({
    this.lastRenewed,
    this.nextRenewal,
    this.status,
  });

  // fromJson factory method
  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      lastRenewed: json['lastRenewed'] != null
          ? DateTime.parse(json['lastRenewed'])
          : null,
      nextRenewal: json['nextRenewal'] != null
          ? DateTime.parse(json['nextRenewal'])
          : null,
      status: json['status'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'lastRenewed': lastRenewed?.toIso8601String(),
      'nextRenewal': nextRenewal?.toIso8601String(),
      'status': status,
    };
  }
}

class App {
  final String? status;

  App({this.status});

  // fromJson factory method
  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      status: json['status'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}