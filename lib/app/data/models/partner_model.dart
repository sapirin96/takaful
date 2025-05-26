class PartnerModel {
  String? uuid;
  String? url;
  String? name;
  String? imageUrl;
  String? discountPercentage;
  String? categoryName;
  String? description;
  String? terms;
  bool? hasLabel;

  PartnerModel({
    this.uuid,
    this.url,
    this.name,
    this.imageUrl,
    this.discountPercentage,
    this.categoryName,
    this.description,
    this.terms,
    this.hasLabel,
  });

  PartnerModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    url = json['url'];
    name = json['name'];
    imageUrl = json['image_url'];
    discountPercentage = json['discount_percentage'];
    categoryName = json['category_name'];
    description = json['description'];
    terms = json['terms'];
    hasLabel = json['has_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image_url'] = imageUrl;
    data['discount_percentage'] = discountPercentage;
    data['category_name'] = categoryName;
    data['description'] = description;
    data['terms'] = terms;
    data['url'] = url;
    data['has_label'] = hasLabel;
    return data;
  }
}
