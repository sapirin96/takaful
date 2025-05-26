class SubmemberModel {
  int? id;
  String? uuid;
  String? code;
  String? nameEn;
  String? nameKh;
  int? totalMember;
  int? membersCount;
  String? religion;
  bool? active;
  String? staffName;
  String? agencyName;
  String? planName;
  String? profilePictureUrl;
  String? frontDocumentUrl;
  String? backDocumentUrl;
  String? gender;
  dynamic age;
  String? formattedPlanPrice;
  bool? isParent;
  int? approvedClaimsCount;
  String? formattedClaimedAmount;
  String? totalSubscriptionsPrice;
  int? subscriptionsCount;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  String? subscriptionStatus;
  bool? claimable;
  bool? renewable;
  String? status;
  String? totalPremium;
  String? identityNumber;
  String? dateOfBirth;
  String? placeOfBirth;
  String? phone;
  String? email;
  String? address;
  String? jointDate;
  String? formattedDateOfBirth;
  String? formattedJointDate;

  SubmemberModel({
    this.id,
    this.uuid,
    this.code,
    this.nameEn,
    this.nameKh,
    this.totalMember,
    this.membersCount,
    this.religion,
    this.active,
    this.staffName,
    this.agencyName,
    this.planName,
    this.profilePictureUrl,
    this.frontDocumentUrl,
    this.backDocumentUrl,
    this.gender,
    this.age,
    this.formattedPlanPrice,
    this.isParent,
    this.approvedClaimsCount,
    this.formattedClaimedAmount,
    this.totalSubscriptionsPrice,
    this.subscriptionsCount,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.subscriptionStatus,
    this.claimable,
    this.renewable,
    this.status,
    this.totalPremium,
    this.identityNumber,
    this.dateOfBirth,
    this.placeOfBirth,
    this.phone,
    this.email,
    this.address,
    this.jointDate,
    this.formattedDateOfBirth,
    this.formattedJointDate,
  });

  SubmemberModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    nameEn = json['name_en'];
    nameKh = json['name_kh'];
    totalMember = json['total_member'];
    membersCount = json['members_count'];
    religion = json['religion'];
    active = json['active'];
    staffName = json['staff_name'];
    agencyName = json['agency_name'];
    planName = json['plan_name'];
    profilePictureUrl = json['profile_picture_url'];
    frontDocumentUrl = json['front_document_url'];
    backDocumentUrl = json['back_document_url'];
    gender = json['gender'];
    age = json['age'];
    formattedPlanPrice = json['formatted_plan_price'];
    isParent = json['is_parent'];
    approvedClaimsCount = json['approved_claims_count'];
    formattedClaimedAmount = json['formatted_claimed_amount'];
    totalSubscriptionsPrice = json['total_subscriptions_price'];
    subscriptionsCount = json['subscriptions_count'];
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    subscriptionStatus = json['subscription_status'];
    claimable = json['claimable'];
    renewable = json['renewable'];
    status = json['status'];
    totalPremium = json['total_premium'];
    identityNumber = json['identity_number'];
    dateOfBirth = json['date_of_birth'];
    placeOfBirth = json['place_of_birth'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    jointDate = json['joint_date'];
    formattedDateOfBirth = json['formatted_date_of_birth'];
    formattedJointDate = json['formatted_joint_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['code'] = code;
    data['name_en'] = nameEn;
    data['name_kh'] = nameKh;
    data['total_member'] = totalMember;
    data['members_count'] = membersCount;
    data['religion'] = religion;
    data['active'] = active;
    data['staff_name'] = staffName;
    data['agency_name'] = agencyName;
    data['plan_name'] = planName;
    data['profile_picture_url'] = profilePictureUrl;
    data['front_document_url'] = frontDocumentUrl;
    data['back_document_url'] = backDocumentUrl;
    data['gender'] = gender;
    data['age'] = age;
    data['formatted_plan_price'] = formattedPlanPrice;
    data['is_parent'] = isParent;
    data['approved_claims_count'] = approvedClaimsCount;
    data['formatted_claimed_amount'] = formattedClaimedAmount;
    data['total_subscriptions_price'] = totalSubscriptionsPrice;
    data['subscriptions_count'] = subscriptionsCount;
    data['subscription_start_date'] = subscriptionStartDate;
    data['subscription_end_date'] = subscriptionEndDate;
    data['subscription_status'] = subscriptionStatus;
    data['claimable'] = claimable;
    data['renewable'] = renewable;
    data['status'] = status;
    data['total_premium'] = totalPremium;
    data['identity_number'] = identityNumber;
    data['date_of_birth'] = dateOfBirth;
    data['place_of_birth'] = placeOfBirth;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['joint_date'] = jointDate;
    data['formatted_date_of_birth'] = formattedDateOfBirth;
    data['formatted_joint_date'] = formattedJointDate;
    return data;
  }
}
