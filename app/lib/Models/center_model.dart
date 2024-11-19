// To parse this JSON data, do
//
//     final centerModel = centerModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CenterModel> centerModelFromJson(String str) => List<CenterModel>.from(json.decode(str).map((x) => CenterModel.fromJson(x)));

String centerModelToJson(List<CenterModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CenterModel {
    final int id;
    final String name;
    final String email;
    final String phone;
    final String description;
    final String image;

    CenterModel({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.description,
        required this.image,
    });

    CenterModel copyWith({
        int? id,
        String? name,
        String? email,
        String? phone,
        String? description,
        String? image,
    }) => 
        CenterModel(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            description: description ?? this.description,
            image: image ?? this.image,
        );

    factory CenterModel.fromJson(Map<String, dynamic> json) => CenterModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "description": description,
    };
}
