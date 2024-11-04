import 'dart:convert';
import 'dart:developer';
import 'package:electric_scooters/Models/place.dart';
import 'package:electric_scooters/constants.dart';
import 'package:electric_scooters/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class MakeReservationScreen extends StatefulWidget {
  String name;
  int scooterId;
  MakeReservationScreen(
      {super.key, required this.name, required this.scooterId});

  @override
  State<MakeReservationScreen> createState() => _MakeReservationScreenState();
}

class _MakeReservationScreenState extends State<MakeReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController placeIdCont = TextEditingController();
  TextEditingController startTimeCont = TextEditingController();
  TextEditingController endTimeCont = TextEditingController();
  String placeId = '';
  List<PlaceModel> places = [];
  double longtitude = 0.0, latitude = 0.0;

  Future<List<PlaceModel>> getPlaces() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/get_places.php'),
      );

      // var scootersResponse = json.decode(response.body);
      List<PlaceModel> placesList = [];

      placesList = placeModelFromJson(response.body);

      return placesList;
    } catch (err) {
      log('getPlaces FUNCTION ===> $err');
      return [];
    }
  }

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

  Future makeReservation(String placeIdParam, String startDate, String endDate,
      BuildContext context) async {
    var lat = places
        .where((element) => element.id == int.parse(placeIdParam))
        .first
        .latitude;
    var long = places
        .where((element) => element.id == int.parse(placeIdParam))
        .first
        .longitude;

    double distance = Geolocator.distanceBetween(
        latitude, longtitude, double.parse(lat), double.parse(long));
    int intDistance = distance.round().toInt();
    double distanceInKilo = intDistance / 1000;
    double price = 0.0;

    if (distanceInKilo < 1) {
      price = 1.5;
    } else if (distanceInKilo > 1 && distanceInKilo < 2) {
      price = 2.5;
    } else {
      price = 5;
    }


    try {
      var response =
          await http.post(Uri.parse('$URL/make_reservation.php'), body: {
        "student_id": "${prefs!.getInt('userId')}",
        "place_id": placeIdParam,
        "scooter_id": "${widget.scooterId}",
        "duration": "$startDate - $endDate",
        "price": "$price"
      });

      var reservationResponse = json.decode(response.body);

      if (!reservationResponse['error']) {
        SuccessAlertBox(
            title: "Scooter Reservation",
            context: context,
            messageText: "Reservation Booked Successfully",
            buttonColor: darkBlue,
            icon: Icons.check_circle,
            titleTextColor: darkBlue);
      } else {
        DangerAlertBox(
            title: "Stop",
            context: context,
            messageText: "You Already Equipped a Scooter",
            buttonColor: darkBlue,
            icon: Icons.cancel,
            titleTextColor: darkBlue);
      }

      return "Done";
    } catch (err) {
      log('makeReservation FUNCTION ===> $err');
      return "Error";
    }
  }

  @override
  void initState() {
    getPlaces().then((value) {
      setState(() {
        places = value;
      });
    });

    _determinePosition().then((value) {
      setState(() {
        latitude = value.latitude;
        longtitude = value.longitude;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Hi ${widget.name}"),
              Text("Hello", style: Theme.of(context).textTheme.bodySmall)
            ]),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Ionicons.notifications_outline)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Ionicons.search_outline))
            ]),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          const SizedBox(height: 25),
          const Text("Book The Scooter",
              style: TextStyle(color: Colors.blue, fontSize: 20)),
          Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    DropdownMenu<String>(
                        controller: placeIdCont,
                        width: MediaQuery.of(context).size.width * 0.9,
                        initialSelection: "Choose Place",
                        hintText: "Choose Place",
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.blue),
                        inputDecorationTheme: InputDecorationTheme(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            )),
                        onSelected: (value) {
                          setState(() {
                            placeId = value!;
                          });
                        },
                        dropdownMenuEntries: places.map((PlaceModel place) {
                          return DropdownMenuEntry<String>(
                              value: '${place.id}', label: place.placeName);
                        }).toList()),
                    const SizedBox(height: 10),
                    startTimeInput(),
                    const SizedBox(height: 10),
                    endTimeInput(),
                    const SizedBox(height: 10),
                    button(
                        text: "Make Reservation",
                        press: () async {
                          if (_formKey.currentState!.validate()) {
                            await makeReservation(placeId, startTimeCont.text,
                                endTimeCont.text, context);
                          }
                        })
                  ]))
        ]))));
  }

  Padding startTimeInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            readOnly: true,
            keyboardType: TextInputType.datetime,
            controller: startTimeCont,
            onTap: () async {
              final time = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());

              setState(() {
                startTimeCont.text = time!.format(context);
              });
            },
            validator: (startTime) {
              if (startTime!.isEmpty) {
                return 'Please fill';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Start Time',
                hintText: 'Start Time',
                icon: const Icon(Icons.timelapse, color: Colors.blue))));
  }

  Padding endTimeInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.datetime,
            controller: endTimeCont,
            readOnly: true,
            onTap: () async {
              final time = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());

              setState(() {
                endTimeCont.text = time!.format(context);
              });
            },
            validator: (endTime) {
              if (endTime!.isEmpty) {
                return 'Please fill';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'End Time',
                hintText: 'End Time',
                icon: const Icon(Icons.timelapse, color: Colors.blue))));
  }
}
