class SubscriptionModel {
  String? uuid;
  String? code;
  int? memberId;
  int? planId;
  String? startDate;
  String? endDate;
  int? age;
  String? price;
  String? description;
  String? memberName;
  String? memberUuid;
  String? formattedPrice;
  String? planName;
  String? formattedStartDate;
  String? formattedEndDate;
  String? status;
  String? memberStatus;
  bool? isExpired;
  String? staffName;
  String? agencyName;
  List<String>? attachments;
  bool? active;

  SubscriptionModel({
    this.uuid,
    this.code,
    this.memberId,
    this.planId,
    this.startDate,
    this.endDate,
    this.age,
    this.price,
    this.description,
    this.memberName,
    this.memberUuid,
    this.formattedPrice,
    this.planName,
    this.formattedStartDate,
    this.formattedEndDate,
    this.status,
    this.memberStatus,
    this.isExpired,
    this.staffName,
    this.agencyName,
    this.attachments,
    this.active,
  });

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    code = json['code'];
    memberId = json['member_id'] != null ? int.parse(json['member_id'].toString()) : null;
    planId = json['plan_id'] != null ? int.parse(json['plan_id'].toString()) : null;
    startDate = json['start_date'];
    endDate = json['end_date'];
    age = json['age'] != null ? int.parse(json['age'].toString()) : null;
    price = json['price'];
    description = json['description'];
    memberName = json['member_name'];
    memberUuid = json['member_uuid'];
    formattedPrice = json['formatted_price'];
    planName = json['plan_name'];
    formattedStartDate = json['formatted_start_date'];
    formattedEndDate = json['formatted_end_date'];
    status = json['status'];
    memberStatus = json['member_status'];
    isExpired = json['is_expired'];
    staffName = json['staff_name'];
    agencyName = json['agency_name'];
    attachments = json['attachments']?.cast<String>();
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['code'] = code;
    data['member_id'] = memberId;
    data['plan_id'] = planId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['age'] = age;
    data['price'] = price;
    data['description'] = description;
    data['member_name'] = memberName;
    data['member_uuid'] = memberUuid;
    data['formatted_price'] = formattedPrice;
    data['plan_name'] = planName;
    data['formatted_start_date'] = formattedStartDate;
    data['formatted_end_date'] = formattedEndDate;
    data['status'] = status;
    data['member_status'] = memberStatus;
    data['is_expired'] = isExpired;
    data['staff_name'] = staffName;
    data['agency_name'] = agencyName;
    data['attachments'] = attachments;
    data['active'] = active;

    return data;
  }
}
