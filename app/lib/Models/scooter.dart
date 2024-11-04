// To parse this JSON data, do
//
//     final scooterModel = scooterModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ScooterModel> scooterModelFromJson(String str) => List<ScooterModel>.from(
    json.decode(str).map((x) => ScooterModel.fromJson(x)));

String scooterModelToJson(List<ScooterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScooterModel {
  final int id;
  final int scooterId;
  final String longitude;
  final String latitude;
  final String scooter;
  final String status;

  ScooterModel({
    required this.id,
    required this.scooterId,
    required this.longitude,
    required this.latitude,
    required this.scooter,
    required this.status
  });

  factory ScooterModel.fromJson(Map<String, dynamic> json) => ScooterModel(
        id: json["id"],
        scooterId: json["scooter_id"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        scooter: json["scooter"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scooter_id": scooterId,
        "longitude": longitude,
        "latitude": latitude,
        "scooter": scooter,
      };
}
