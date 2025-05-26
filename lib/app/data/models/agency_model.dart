class AgencyModel {
  String? uuid;
  String? name;
  String? nameEn;
  String? nameKh;
  String? religion;
  String? gender;
  bool? active;
  int? staffId;
  String? staffName;
  int? membersCount;
  int? monthlyTarget;
  String? profilePictureUrl;
  String? jointDate;
  String? dateOfBirth;
  String? placeOfBirth;
  String? address;
  int? provinceId;
  int? districtId;
  int? communeId;
  int? villageId;
  String? kpiPercentage;
  String? identityNumber;
  String? phone;
  String? email;
  bool? hasAgencies;

  AgencyModel({
    this.uuid,
    this.name,
    this.nameEn,
    this.nameKh,
    this.religion,
    this.gender,
    this.active,
    this.staffId,
    this.staffName,
    this.membersCount,
    this.monthlyTarget,
    this.profilePictureUrl,
    this.jointDate,
    this.dateOfBirth,
    this.placeOfBirth,
    this.address,
    this.provinceId,
    this.districtId,
    this.communeId,
    this.villageId,
    this.kpiPercentage,
    this.identityNumber,
    this.phone,
    this.email,
    this.hasAgencies,
  });

  AgencyModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    nameEn = json['name_en'];
    nameKh = json['name_kh'];
    religion = json['religion'];
    gender = json['gender'];
    active = json['active'];
    staffId = json['staff_id'] != null
        ? int.parse(json['staff_id'].toString())
        : null;
    staffName = json['staff_name'];
    membersCount = json['members_count'];
    monthlyTarget = int.parse(json['monthly_target'].toString());
    profilePictureUrl = json['profile_picture_url'];
    jointDate = json['joint_date'];
    dateOfBirth = json['date_of_birth'];
    placeOfBirth = json['place_of_birth'];
    address = json['address'];
    provinceId = json['province_id'] != null
        ? int.parse(json['province_id'].toString())
        : null;
    districtId = json['district_id'] != null
        ? int.parse(json['district_id'].toString())
        : null;
    communeId = json['commune_id'] != null
        ? int.parse(json['commune_id'].toString())
        : null;
    villageId = json['village_id'] != null
        ? int.parse(json['village_id'].toString())
        : null;
    kpiPercentage = json['kpi_percentage'];
    identityNumber = json['identity_number'];
    phone = json['phone'];
    email = json['email'];
    hasAgencies = json['has_agencies'];
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
    data['staff_id'] = staffId;
    data['staff_name'] = staffName;
    data['members_count'] = membersCount;
    data['monthly_target'] = monthlyTarget;
    data['profile_picture_url'] = profilePictureUrl;
    data['joint_date'] = jointDate;
    data['date_of_birth'] = dateOfBirth;
    data['place_of_birth'] = placeOfBirth;
    data['address'] = address;
    data['province_id'] = provinceId;
    data['district_id'] = districtId;
    data['commune_id'] = communeId;
    data['village_id'] = villageId;
    data['kpi_percentage'] = kpiPercentage;
    data['identity_number'] = identityNumber;
    data['phone'] = phone;
    data['email'] = email;
    data['has_agencies'] = hasAgencies;

    return data;
  }
}
