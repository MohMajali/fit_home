// To parse this JSON data, do
//
//     final mealModel = mealModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<MealModel> mealModelFromJson(String str) =>
    List<MealModel>.from(json.decode(str).map((x) => MealModel.fromJson(x)));

String mealModelToJson(List<MealModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MealModel {
  final int id;
  final int nutritionCenterId;
  final String centerName;
  final String name;
  final String image;
  final String description;
  final String categoryName;

  MealModel({
    required this.id,
    required this.nutritionCenterId,
    required this.centerName,
    required this.name,
    required this.image,
    required this.description,
    required this.categoryName,
  });

  MealModel copyWith({
    int? id,
    int? nutritionCenterId,
    String? centerName,
    String? name,
    String? image,
    String? description,
    String? categoryName,
  }) =>
      MealModel(
        id: id ?? this.id,
        nutritionCenterId: nutritionCenterId ?? this.nutritionCenterId,
        centerName: centerName ?? this.centerName,
        name: name ?? this.name,
        image: image ?? this.image,
        description: description ?? this.description,
        categoryName: categoryName ?? this.categoryName,
      );

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json["id"],
        nutritionCenterId: json["nutrition_center_id"],
        centerName: json["center_name"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nutrition_center_id": nutritionCenterId,
        "center_name": centerName,
        "name": name,
        "image": image,
        "description": description,
        "category_name": categoryName,
      };
}
