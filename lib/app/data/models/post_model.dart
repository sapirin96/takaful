// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    @required this.uuid,
    @required this.title,
    @required this.content,
    @required this.status,
    @required this.publishedAt,
    @required this.featuredImageUrl,
  });

  final String? uuid;
  final String? title;
  final String? content;
  final String? status;
  final String? publishedAt;
  final String? featuredImageUrl;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        uuid: json["uuid"],
        title: json["title"],
        content: json["content"],
        status: json["status"],
        publishedAt: json["published_at"],
        featuredImageUrl: json["featured_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "content": content,
        "status": status,
        "published_at": publishedAt,
        "featured_image_url": featuredImageUrl,
      };
}
