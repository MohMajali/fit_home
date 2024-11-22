// To parse this JSON data, do
//
//     final levelModel = levelModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<LevelModel> levelModelFromJson(String str) => List<LevelModel>.from(json.decode(str).map((x) => LevelModel.fromJson(x)));

String levelModelToJson(List<LevelModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LevelModel {
    final int id;
    final String levelName;
    final List<Plan> plans;

    LevelModel({
        required this.id,
        required this.levelName,
        required this.plans,
    });

    LevelModel copyWith({
        int? id,
        String? levelName,
        List<Plan>? plans,
    }) => 
        LevelModel(
            id: id ?? this.id,
            levelName: levelName ?? this.levelName,
            plans: plans ?? this.plans,
        );

    factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
        id: json["id"],
        levelName: json["level_name"],
        plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "level_name": levelName,
        "plans": List<dynamic>.from(plans.map((x) => x.toJson())),
    };
}

class Plan {
    final int id;
    final int userPlanId;
    final String name;
    final String image;
    final String description;
    final bool isDone;

    Plan({
        required this.id,
        required this.userPlanId,
        required this.name,
        required this.image,
        required this.description,
        required this.isDone,
    });

    Plan copyWith({
        int? id,
        int? userPlanId,
        String? name,
        String? image,
        String? description,
        bool? isDone,
    }) => 
        Plan(
            id: id ?? this.id,
            userPlanId: userPlanId ?? this.userPlanId,
            name: name ?? this.name,
            image: image ?? this.image,
            description: description ?? this.description,
            isDone: isDone ?? this.isDone,
        );

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        userPlanId: json['user_plan_id'],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        isDone: json["is_done"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "is_done": isDone,
    };
}
