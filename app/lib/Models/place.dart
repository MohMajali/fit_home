// To parse this JSON data, do
//
//     final placeModel = placeModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<PlaceModel> placeModelFromJson(String str) =>
    List<PlaceModel>.from(json.decode(str).map((x) => PlaceModel.fromJson(x)));

String placeModelToJson(List<PlaceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaceModel {
  final int id;
  final String placeName;
  final String longitude;
  final String latitude;
  final int active;
  final DateTime createdAt;

  PlaceModel({
    required this.id,
    required this.placeName,
    required this.longitude,
    required this.latitude,
    required this.active,
    required this.createdAt,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        id: json["id"],
        placeName: json["place_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "place_name": placeName,
        "longitude": longitude,
        "latitude": latitude,
        "active": active,
        "created_at": createdAt.toIso8601String(),
      };
}
