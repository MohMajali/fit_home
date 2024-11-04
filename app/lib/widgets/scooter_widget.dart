import 'dart:developer';

import 'package:electric_scooters/Models/scooter.dart';
import 'package:electric_scooters/Pages/make_reservation.dart';
import 'package:electric_scooters/constants.dart';
import 'package:electric_scooters/widgets/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ScootersWidget extends StatelessWidget {
  List<ScooterModel> scooters;
  double lat, long;
  String name;
  ScootersWidget(
      {super.key,
      required this.name,
      required this.scooters,
      required this.lat,
      required this.long});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(scooters.length, (i) {
      double distance = Geolocator.distanceBetween(
          lat,
          long,
          double.parse(scooters[i].latitude),
          double.parse(scooters[i].longitude));
      int intDistance = distance.round().toInt();
      double distanceInKilo = intDistance / 1000;

      if (distanceInKilo <= 2) {
        return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MakeReservationScreen(
                          name: name, scooterId: scooters[i].scooterId)));
            },
            child: ItemWidget(
                image:
                    'https://cdn-eshop.jo.zain.com/images/thumbs/0049405_xiaomi-electric-scooter-4-lite_600.webp',
                title: scooters[i].scooter,
                duration: "",
                placeName: scooters[i].status,
                status: "",
                showOtherData: false));
      }

      return Container();
    }));
  }
}
