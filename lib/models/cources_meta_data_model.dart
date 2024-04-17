// To parse this JSON data, do
//
//     final courcesMetaDataModel = courcesMetaDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CourcesMetaDataModel> courcesMetaDataModelFromJson(String str) =>
    List<CourcesMetaDataModel>.from(
        json.decode(str).map((x) => CourcesMetaDataModel.fromJson(x)));

String courcesMetaDataModelToJson(List<CourcesMetaDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourcesMetaDataModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  CourcesMetaDataModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory CourcesMetaDataModel.fromJson(Map<String, dynamic> json) =>
      CourcesMetaDataModel(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        category: json["category"],
        image: json["image"],
        rating: Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
        "rating": rating.toJson(),
      };
}

class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "count": count,
      };
}
