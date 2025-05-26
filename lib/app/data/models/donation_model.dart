class DonationModel {
  int? id;
  String? uuid;
  double? amount;
  String? formattedAmount;
  String? via;
  String? formattedCreatedAt;
  String? formattedUpdatedAt;
  String? statusLabel;
  String? statusColor;
  String? status;
  String? name;
  String? email;
  bool? active;

  DonationModel({
    this.id,
    this.uuid,
    this.amount,
    this.formattedAmount,
    this.via,
    this.formattedCreatedAt,
    this.formattedUpdatedAt,
    this.statusLabel,
    this.statusColor,
    this.status,
    this.name,
    this.email,
    this.active,
  });

  DonationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    amount = double.parse(json['amount'].toString());
    formattedAmount = json['formatted_amount'];
    via = json['via'];
    formattedCreatedAt = json['formatted_created_at'];
    formattedUpdatedAt = json['formatted_updated_at'];
    statusLabel = json['status_label'];
    statusColor = json['status_color'];
    status = json['status'];
    name = json['name'];
    email = json['email'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['uuid'] = uuid;
    data['amount'] = amount;
    data['formatted_amount'] = formattedAmount;
    data['via'] = via;
    data['formatted_created_at'] = formattedCreatedAt;
    data['formatted_updated_at'] = formattedUpdatedAt;
    data['status_label'] = statusLabel;
    data['status_color'] = statusColor;
    data['status'] = status;
    data['name'] = name;
    data['email'] = email;
    data['active'] = active;

    return data;
  }
}
