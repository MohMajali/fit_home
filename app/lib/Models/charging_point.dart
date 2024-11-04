// To parse this JSON data, do
//
//     final chargingPointModel = chargingPointModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ChargingPointModel> chargingPointModelFromJson(String str) =>
    List<ChargingPointModel>.from(
        json.decode(str).map((x) => ChargingPointModel.fromJson(x)));

String chargingPointModelToJson(List<ChargingPointModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChargingPointModel {
  final int id;
  final String name;
  final String longitude;
  final String latitude;
  final int active;
  final DateTime createdAt;

  ChargingPointModel({
    required this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.active,
    required this.createdAt,
  });

  factory ChargingPointModel.fromJson(Map<String, dynamic> json) =>
      ChargingPointModel(
        id: json["id"],
        name: json["name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "longitude": longitude,
        "latitude": latitude,
        "active": active,
        "created_at": createdAt.toIso8601String(),
      };
}
