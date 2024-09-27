class Subscription {
  final String? id;
  final String? member;
  final String? category;
  final String? status;
  final int? days;
  final String? invoiceUrl;
  final String? remarks;
  final int? amount;
  final DateTime? date;
  final String? modeOfPayment;
  final DateTime? renewal;
  final DateTime? time;
  final int? v;

  Subscription({
    this.id,
    this.member,
    this.category,
    this.status,
    this.days,
    this.invoiceUrl,
    this.remarks,
    this.amount,
    this.date,
    this.modeOfPayment,
    this.renewal,
    this.time,
    this.v,
  });

  // fromJson method
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['_id'] as String?,
      member: json['member'] as String?,
      category: json['category'] as String?,
      status: json['status'] as String?,
      days: json['days'] as int?,
      invoiceUrl: json['invoice_url'] as String?,
      remarks: json['remarks'] as String?,
      amount: json['amount'] as int?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      modeOfPayment: json['mode_of_payment'] as String?,
      renewal: json['renewal'] != null ? DateTime.parse(json['renewal']) : null,
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      v: json['__v'] as int?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'member': member,
      'category': category,
      'status': status,
      'days': days,
      'invoice_url': invoiceUrl,
      'remarks': remarks,
      'amount': amount,
      'date': date?.toIso8601String(),
      'mode_of_payment': modeOfPayment,
      'renewal': renewal?.toIso8601String(),
      'time': time?.toIso8601String(),
      '__v': v,
    };
  }
}
