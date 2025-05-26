class BankAccountModel {
  int? id;
  String? name;
  String? code;
  String? accountName;
  String? accountNumber;
  String? instructions;
  String? description;
  String? imageUrl;
  bool? active;

  BankAccountModel({
    this.id,
    this.name,
    this.code,
    this.accountName,
    this.accountNumber,
    this.instructions,
    this.description,
    this.imageUrl,
    this.active,
  });

  BankAccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    instructions = json['instructions'];
    description = json['description'];
    imageUrl = json['image_url'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    data['instructions'] = instructions;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['active'] = active;

    return data;
  }
}
