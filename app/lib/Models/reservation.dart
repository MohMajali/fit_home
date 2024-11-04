// To parse this JSON data, do
//
//     final reservationModel = reservationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ReservationModel> reservationModelFromJson(String str) =>
    List<ReservationModel>.from(
        json.decode(str).map((x) => ReservationModel.fromJson(x)));

String reservationModelToJson(List<ReservationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReservationModel {
  final int id;
  final int studentId;
  final int placeId;
  final int scooterId;
  final String duration;
  final String status;
  double? price;
  final String name;
  final String placeName;
  final String scooter;

  ReservationModel({
    required this.id,
    required this.studentId,
    required this.placeId,
    required this.scooterId,
    required this.duration,
    required this.status,
    this.price,
    required this.name,
    required this.placeName,
    required this.scooter,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      ReservationModel(
        id: json["id"],
        studentId: json["student_id"],
        placeId: json["place_id"],
        scooterId: json["scooter_id"],
        duration: json["duration"],
        status: json["status"],
        price: json["price"]?.toDouble(),
        name: json["name"],
        placeName: json["place_name"],
        scooter: json["scooter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "place_id": placeId,
        "scooter_id": scooterId,
        "duration": duration,
        "status": status,
        "price": price,
        "name": name,
        "place_name": placeName,
        "scooter": scooter,
      };
}
