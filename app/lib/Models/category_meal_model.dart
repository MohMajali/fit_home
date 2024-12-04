// To parse this JSON data, do
//
//     final categoryMealModel = categoryMealModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CategoryMealModel> categoryMealModelFromJson(String str) => List<CategoryMealModel>.from(json.decode(str).map((x) => CategoryMealModel.fromJson(x)));

String categoryMealModelToJson(List<CategoryMealModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryMealModel {
    final String categoryName;

    CategoryMealModel({
        required this.categoryName,
    });

    CategoryMealModel copyWith({
        String? categoryName,
    }) => 
        CategoryMealModel(
            categoryName: categoryName ?? this.categoryName,
        );

    factory CategoryMealModel.fromJson(Map<String, dynamic> json) => CategoryMealModel(
        categoryName: json["category_name"],
    );

    Map<String, dynamic> toJson() => {
        "category_name": categoryName,
    };
}
