// To parse this JSON data, do
//
//     final appointmentModel = appointmentModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<AppointmentModel> appointmentModelFromJson(String str) =>
    List<AppointmentModel>.from(
        json.decode(str).map((x) => AppointmentModel.fromJson(x)));

String appointmentModelToJson(List<AppointmentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppointmentModel {
  final int id;
  final int centerId;
  final String centerName;
  final DateTime appointmentDate;
  final String status;
  final String image;

  AppointmentModel({
    required this.id,
    required this.centerId,
    required this.centerName,
    required this.appointmentDate,
    required this.status,
    required this.image,
  });

  AppointmentModel copyWith({
    int? id,
    int? centerId,
    String? centerName,
    DateTime? appointmentDate,
    String? status,
    String? image,
  }) =>
      AppointmentModel(
        id: id ?? this.id,
        centerId: centerId ?? this.centerId,
        centerName: centerName ?? this.centerName,
        appointmentDate: appointmentDate ?? this.appointmentDate,
        status: status ?? this.status,
        image: image ?? this.image,
      );

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json["id"],
        centerId: json["center_id"],
        centerName: json["center_name"],
        appointmentDate: DateTime.parse(json["appointment_date"]),
        status: json["status"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "center_id": centerId,
        "center_name": centerName,
        "appointment_date": appointmentDate.toIso8601String(),
        "status": status,
        "image": image,
      };
}
