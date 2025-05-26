class UserModel {
  int? id;
  String? uuid;
  String? name;
  String? phone;
  String? email;
  String? imageUrl;
  String? tokenableType;
  String? roleName;
  int? tenantId;
  String? tenantName;

  UserModel({
    this.id,
    this.uuid,
    this.name,
    this.phone,
    this.email,
    this.imageUrl,
    this.tokenableType,
    this.roleName,
    this.tenantId,
    this.tenantName,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    imageUrl = json['image_url'];
    tokenableType = json['tokenable_type'];
    roleName = json['role_name'];
    tenantId = json['tenant_id'];
    tenantName = json['tenant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['image_url'] = imageUrl;
    data['tokenable_type'] = tokenableType;
    data['role_name'] = roleName;
    data['tenant_id'] = tenantId;
    data['tenant_name'] = tenantName;
    return data;
  }
}
