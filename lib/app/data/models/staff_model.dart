class StaffModel {
  String? uuid;
  String? name;
  String? nameEn;
  String? nameKh;
  String? religion;
  String? gender;
  bool? active;
  int? membersCount;
  int? monthlyTarget;
  String? profilePictureUrl;
  String? jointDate;
  String? dateOfBirth;
  String? placeOfBirth;
  String? address;
  String? kpiPercentage;
  String? identityNumber;
  String? phone;
  String? email;

  StaffModel(
      {this.uuid,
      this.name,
      this.nameEn,
      this.nameKh,
      this.religion,
      this.gender,
      this.active,
      this.membersCount,
      this.monthlyTarget,
      this.profilePictureUrl,
      this.jointDate,
      this.dateOfBirth,
      this.placeOfBirth,
      this.address,
      this.kpiPercentage,
      this.identityNumber,
      this.phone,
      this.email});

  StaffModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    nameEn = json['name_en'];
    nameKh = json['name_kh'];
    religion = json['religion'];
    gender = json['gender'];
    active = json['active'];
    membersCount = json['members_count'];
    monthlyTarget = int.parse(json['monthly_target'].toString());
    profilePictureUrl = json['profile_picture_url'];
    jointDate = json['joint_date'];
    dateOfBirth = json['date_of_birth'];
    placeOfBirth = json['place_of_birth'];
    address = json['address'];
    kpiPercentage = json['kpi_percentage'];
    identityNumber = json['identity_number'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['name'] = name;
    data['name_en'] = nameEn;
    data['name_kh'] = nameKh;
    data['religion'] = religion;
    data['gender'] = gender;
    data['active'] = active;
    data['members_count'] = membersCount;
    data['monthly_target'] = monthlyTarget;
    data['profile_picture_url'] = profilePictureUrl;
    data['joint_date'] = jointDate;
    data['date_of_birth'] = dateOfBirth;
    data['place_of_birth'] = placeOfBirth;
    data['address'] = address;
    data['kpi_percentage'] = kpiPercentage;
    data['identity_number'] = identityNumber;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}
