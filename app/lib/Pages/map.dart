import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:electric_scooters/Models/charging_point.dart';
import 'package:electric_scooters/Models/scooter.dart';
import 'package:electric_scooters/Pages/make_reservation.dart';
import 'package:electric_scooters/constants.dart';
import 'package:electric_scooters/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  int type;
  String name;
  MapScreen({super.key, required this.type, required this.name});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<ScooterModel> scooters = [];

  List<ChargingPointModel> chargingPoints = [];

  double longtitude = 0.0, latitude = 0.0;
  int scooterId = 0, reservationId = 0;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<List<ScooterModel>> getScooters() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/get_scooters_locations.php'),
      );

      // var scootersResponse = json.decode(response.body);
      List<ScooterModel> scootersList = [];

      scootersList = scooterModelFromJson(response.body);

      return scootersList;
    } catch (err) {
      log('getScooters FUNCTION ===> $err');
      return [];
    }
  }

  Future<List<ChargingPointModel>> getPoints() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/get_charging_points.php'),
      );

      // var scootersResponse = json.decode(response.body);
      List<ChargingPointModel> pointsList = [];

      pointsList = chargingPointModelFromJson(response.body);

      return pointsList;
    } catch (err) {
      log('getScooters FUNCTION ===> $err');
      return [];
    }
  }

  Future getReservations() async {
    try {
      var response = await http.get(
        Uri.parse(
            '$URL/get_specific_reservation.php?user_id=${prefs?.getInt('userId')}'),
      );

      var resResponse = json.decode(response.body);

      if (resResponse.length == 1) {
        scooterId = resResponse[0]['scooter_id'];
        reservationId = resResponse[0]['id'];
      }

      return resResponse;
    } catch (err) {
      log('getReservations FUNCTION ===> $err');
      return [];
    }
  }

  Future chargeScooter(int chargingPointId, int scooterIdParam, int resId,
      BuildContext context) async {
    try {
      var response =
          await http.post(Uri.parse('$URL/charge_scooter.php'), body: {
        "scooter_id": "$scooterIdParam",
        "charging_point_id": "$chargingPointId",
        "reservationId": "$resId"
      });

      var chargingResponse = json.decode(response.body);

      if (!chargingResponse['error']) {
        SuccessAlertBox(
            title: "Charing Scooter",
            context: context,
            messageText: "Scooter Charged Success",
            buttonColor: darkBlue,
            icon: Icons.check_circle,
            titleTextColor: darkBlue);
      } else {
        DangerAlertBox(
            title: "Stop",
            context: context,
            messageText: "Scooter Already Charging",
            buttonColor: darkBlue,
            icon: Icons.cancel,
            titleTextColor: darkBlue);
      }
    } catch (err) {
      log('chargeScooter FUNCTION ===> $err');
      return [];
    }
  }

  Future<void> lauchMap(double lat, double long) async {
    try {
      var uri = Uri.parse("google.navigation:q=$lat,$long&mode=d");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch ${uri.toString()}';
      }
    } catch (ex) {
      log("lauchMap $ex");
    }
  }

  @override
  void initState() {
    if (widget.type == 0) {
      getPoints().then((value) {
        setState(() {
          chargingPoints = value;
        });
      });
      getReservations();
    } else {
      getScooters().then((value) {
        setState(() {
          scooters = value;
        });
      });
    }

    _determinePosition().then((value) {
      setState(() {
        latitude = value.latitude;
        longtitude = value.longitude;
      });
    });

    super.initState();
  }

  LatLng sourceLocation = LatLng(37.42309057382422, -122.08290563806655);

  GoogleMapController? _googleMapController;
  var myMarkers = HashSet<Marker>();
  double distance = 0.0;

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: sourceLocation, zoom: 14.5),
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
          setState(() {
            _setMarkers();
          });
        },
        markers: myMarkers,
      ),
    );
  }

  _setMarkers() {
    myMarkers.clear();

    if (widget.type == 0) {
      for (final point in chargingPoints) {
        // distance = Geolocator.distanceBetween(latitude, longtitude,
        //     double.parse(point.latitude), double.parse(point.longitude));
        // int indistance = distance.round().toInt();
        // double distanceInKilo = indistance / 1000;

        // if (distanceInKilo <= 3) {
        myMarkers.add(Marker(
            markerId: MarkerId("${point.id}"),
            position: LatLng(
                double.parse(point.latitude), double.parse(point.longitude)),
            infoWindow: InfoWindow(
                title: point.name,
                onTap: () async {
                  if (scooterId > 0) {
                    await chargeScooter(
                        point.id, scooterId, reservationId, context);

                    await lauchMap(double.parse(point.latitude),
                        double.parse(point.longitude));
                  } else {
                    DangerAlertBox(
                        title: "Stop",
                        context: context,
                        messageText: "You Did Not Equipped a Scooter",
                        buttonColor: darkBlue,
                        icon: Icons.cancel,
                        titleTextColor: darkBlue);
                  }
                })));
        // }
      }
    } else {
      for (final scooter in scooters) {
        // distance = Geolocator.distanceBetween(latitude, longtitude,
        //     double.parse(point.latitude), double.parse(point.longitude));
        // int indistance = distance.round().toInt();
        // double distanceInKilo = indistance / 1000;

        // if (distanceInKilo <= 3) {
        myMarkers.add(Marker(
            markerId: MarkerId("${scooter.id}"),
            position: LatLng(double.parse(scooter.latitude),
                double.parse(scooter.longitude)),
            infoWindow: InfoWindow(
                title: scooter.scooter,
                onTap: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return Container(
                            height: 200,
                            color: Colors.blue,
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                  const Text('Choose Options',
                                      style: TextStyle(fontSize: 20)),
                                  const SizedBox(height: 10),
                                  Center(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                        ElevatedButton(
                                          child: const Text('Google Maps'),
                                          onPressed: () async {
                                            await lauchMap(
                                                double.parse(scooter.latitude),
                                                double.parse(
                                                    scooter.longitude));
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                            child:
                                                const Text('Make Reservation'),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MakeReservationScreen(
                                                              name: widget.name,
                                                              scooterId:
                                                                  scooter.scooterId)));
                                            })
                                      ]))
                                ])));
                      });
                })));
        // }
      }
    }
  }
}
