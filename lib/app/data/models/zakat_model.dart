class ZakatModel {
  int? id;
  String? uuid;
  String? gold;
  String? silver;
  String? cashOnHand;
  String? cashInBank;
  String? investment;
  String? stock;
  String? receivable;
  String? payable;
  String? asset;
  String? nisab;
  String? zakat;
  String? formattedCreatedAt;
  String? formattedUpdatedAt;
  String? name;
  String? email;

  ZakatModel({
    this.id,
    this.uuid,
    this.gold,
    this.silver,
    this.cashOnHand,
    this.cashInBank,
    this.investment,
    this.stock,
    this.receivable,
    this.payable,
    this.asset,
    this.nisab,
    this.zakat,
    this.formattedCreatedAt,
    this.formattedUpdatedAt,
    this.name,
    this.email,
  });

  ZakatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    gold = json['gold'];
    silver = json['silver'];
    cashOnHand = json['cash_on_hand'];
    cashInBank = json['cash_in_bank'];
    investment = json['investment'];
    stock = json['stock'];
    receivable = json['receivable'];
    payable = json['payable'];
    asset = json['asset'];
    nisab = json['nisab'];
    zakat = json['zakat'];
    formattedCreatedAt = json['formatted_created_at'];
    formattedUpdatedAt = json['formatted_updated_at'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['uuid'] = uuid;
    data['gold'] = gold;
    data['silver'] = silver;
    data['cash_on_hand'] = cashOnHand;
    data['cash_in_bank'] = cashInBank;
    data['investment'] = investment;
    data['stock'] = stock;
    data['receivable'] = receivable;
    data['payable'] = payable;
    data['asset'] = asset;
    data['nisab'] = nisab;
    data['zakat'] = zakat;
    data['formatted_created_at'] = formattedCreatedAt;
    data['formatted_updated_at'] = formattedUpdatedAt;
    data['name'] = name;
    data['email'] = email;

    return data;
  }
}
