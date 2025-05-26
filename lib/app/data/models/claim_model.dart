class ClaimModel {
  String? uuid;
  int? memberId;
  String? memberName;
  String? memberCode;
  String? policyName;
  int? policyId;
  String? date;
  String? formattedDate;
  String? compensation;
  String? compensationKhr;
  String? formattedCompensation;
  String? formattedCompensationKhr;
  int? filesCount;
  String? statusLabel;
  String? statusColor;
  String? type;
  String? formattedType;
  String? reasonsOfDeath;
  String? waitingDuration;
  String? kindOfDeathOrAccident;
  String? dateOfDeath;
  String? placeOfDeathOrAccident;
  String? pleaseDescribeTheReasonOfDeath;
  String? bodyPartsThatAreDisabled;
  String? disablementReason;
  String? placeOfIssues;
  String? dateOfDisablement;
  String? hospitalName;
  String? hospitalAddress;
  String? doctorName;
  String? doctorPhone;
  String? doctorEmail;
  String? comment;

  ClaimModel({
    this.uuid,
    this.memberId,
    this.memberName,
    this.memberCode,
    this.policyName,
    this.policyId,
    this.date,
    this.formattedDate,
    this.compensation,
    this.compensationKhr,
    this.formattedCompensation,
    this.formattedCompensationKhr,
    this.filesCount,
    this.statusLabel,
    this.statusColor,
    this.type,
    this.formattedType,
    this.reasonsOfDeath,
    this.waitingDuration,
    this.kindOfDeathOrAccident,
    this.dateOfDeath,
    this.placeOfDeathOrAccident,
    this.pleaseDescribeTheReasonOfDeath,
    this.bodyPartsThatAreDisabled,
    this.disablementReason,
    this.placeOfIssues,
    this.dateOfDisablement,
    this.hospitalName,
    this.hospitalAddress,
    this.doctorName,
    this.doctorPhone,
    this.doctorEmail,
    this.comment,
  });

  ClaimModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    memberId = json['member_id'] != null
        ? int.parse(json['member_id'].toString())
        : null;
    memberName = json['member_name'];
    memberCode = json['member_code'];
    policyName = json['policy_name'];
    policyId = json['policy_id'] != null
        ? int.parse(json['policy_id'].toString())
        : null;
    date = json['date'];
    formattedDate = json['formatted_date'];
    compensation = json['compensation'];
    compensationKhr = json['compensation_khr'];
    formattedCompensation = json['formatted_compensation'];
    formattedCompensationKhr = json['formatted_compensation_khr'];
    filesCount = json['files_count'] != null
        ? int.parse(json['files_count'].toString())
        : null;
    statusLabel = json['status_label'];
    statusColor = json['status_color'];
    type = json['type'];
    formattedType = json['formatted_type'];
    reasonsOfDeath = json['reasons_of_death'];
    waitingDuration = json['waiting_duration'];
    kindOfDeathOrAccident = json['kind_of_death_or_accident'];
    dateOfDeath = json['date_of_death'];
    placeOfDeathOrAccident = json['place_of_death_or_accident'];
    pleaseDescribeTheReasonOfDeath =
        json['please_describe_the_reason_of_death'];
    bodyPartsThatAreDisabled = json['body_parts_that_are_disabled'];
    disablementReason = json['disablement_reason'];
    placeOfIssues = json['place_of_issues'];
    dateOfDisablement = json['date_of_disablement'];
    hospitalName = json['hospital_name'];
    hospitalAddress = json['hospital_address'];
    doctorName = json['doctor_name'];
    doctorPhone = json['doctor_phone'];
    doctorEmail = json['doctor_email'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['member_id'] = memberId;
    data['member_name'] = memberName;
    data['member_code'] = memberCode;
    data['policy_name'] = policyName;
    data['policy_id'] = policyId;
    data['date'] = date;
    data['formatted_date'] = formattedDate;
    data['compensation'] = compensation;
    data['compensation_khr'] = compensationKhr;
    data['formatted_compensation'] = formattedCompensation;
    data['formatted_compensation_khr'] = formattedCompensationKhr;
    data['files_count'] = filesCount;
    data['status_label'] = statusLabel;
    data['status_color'] = statusColor;
    data['type'] = type;
    data['formatted_type'] = formattedType;
    data['reasons_of_death'] = reasonsOfDeath;
    data['waiting_duration'] = waitingDuration;
    data['kind_of_death_or_accident'] = kindOfDeathOrAccident;
    data['date_of_death'] = dateOfDeath;
    data['place_of_death_or_accident'] = placeOfDeathOrAccident;
    data['please_describe_the_reason_of_death'] =
        pleaseDescribeTheReasonOfDeath;
    data['body_parts_that_are_disabled'] = bodyPartsThatAreDisabled;
    data['disablement_reason'] = disablementReason;
    data['place_of_issues'] = placeOfIssues;
    data['date_of_disablement'] = dateOfDisablement;
    data['hospital_name'] = hospitalName;
    data['hospital_address'] = hospitalAddress;
    data['doctor_name'] = doctorName;
    data['doctor_phone'] = doctorPhone;
    data['doctor_email'] = doctorEmail;
    data['comment'] = comment;
    return data;
  }
}
