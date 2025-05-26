class UserModel {
  int? id;
  String? uuid;
  String? name;
  String? email;
  String? role;
  int? roleId;
  bool? active;

  UserModel({
    this.id,
    this.uuid,
    this.name,
    this.email,
    this.role,
    this.roleId,
    this.active,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    roleId = json['role_id'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['uuid'] = uuid;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['role_id'] = roleId;
    data['active'] = active;

    return data;
  }
}
