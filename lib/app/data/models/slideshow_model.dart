// To parse this JSON data, do
//
//     final slideShowModel = slideShowModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

SlideShowModel slideShowModelFromJson(String str) =>
    SlideShowModel.fromJson(json.decode(str));

String slideShowModelToJson(SlideShowModel data) => json.encode(data.toJson());

class SlideShowModel {
  SlideShowModel({
    @required this.uuid,
    @required this.name,
    @required this.description,
    @required this.excerpt,
    @required this.imageUrl,
    @required this.callbackUrl,
    @required this.active,
  });

  final String? uuid;
  final String? name;
  final String? description;
  final String? excerpt;
  final String? imageUrl;
  final String? callbackUrl;
  final bool? active;

  factory SlideShowModel.fromJson(Map<String, dynamic> json) => SlideShowModel(
        uuid: json["uuid"],
        name: json["name"],
        description: json["description"],
        excerpt: json["excerpt"],
        imageUrl: json["image_url"],
        callbackUrl: json["callback_url"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "description": description,
        "excerpt": excerpt,
        "image_url": imageUrl,
        "callback_url": callbackUrl,
        "active": active,
      };
}
