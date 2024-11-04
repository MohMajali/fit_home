import 'dart:convert';
import 'dart:developer';

import 'package:electric_scooters/Models/scooter.dart';
import 'package:electric_scooters/Models/user.dart';
import 'package:electric_scooters/constants.dart';
import 'package:electric_scooters/main.dart';
import 'package:electric_scooters/widgets/usage.dart';
import 'package:electric_scooters/widgets/scooter_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ScooterModel> scooters = [];
  double longtitude = 0.0, latitude = 0.0;
  UserModel userModel = UserModel(
      error: false,
      user: User(
          id: 0,
          userType: "",
          name: '',
          nationalId: '',
          password: '',
          phone: '',
          universityId: '',
          active: 0,
          createdAt: DateTime.now()));

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

  Future getUser() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/get_user.php?id=${prefs?.getInt('userId')}'),
      );

      var userResponse = json.decode(response.body);
      if (!userResponse['error']) {
        UserModel.fromJson(userResponse);
      } else {
        log("message");
      }
      return userResponse;
    } catch (err) {
      log('LOGIN FUNCTION ===> $err');
    }
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

  @override
  void initState() {
    getUser().then((value) {
      setState(() {
        userModel = UserModel(
            error: false,
            user: User(
                id: value['user']['id'],
                userType: value['user']['user_type'],
                name: value['user']['name'],
                nationalId: value['user']['national_id'],
                password: value['user']['password'],
                phone: value['user']['phone'],
                universityId: value['user']['university_id'],
                active: value['user']['active'],
                createdAt: DateTime.now()));
      });
    });

    getScooters().then((scootersList) {
      setState(() {
        scooters = scootersList;
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
              Text("Hi ${userModel.user.name}"),
              Text("Hello", style: Theme.of(context).textTheme.bodySmall)
            ]),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Ionicons.notifications_outline)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Ionicons.search_outline))
            ]),
        body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(14),
            children: [
              // const UpcomingCard(),
              // const SizedBox(height: 20),
              Text(
                "Use",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              UsageComponent(name: userModel.user.name),
              const SizedBox(height: 25),
              Text("Scooters", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 15),
              ScootersWidget(
                  scooters: scooters,
                  lat: latitude,
                  long: longtitude,
                  name: userModel.user.name)
            ]));
  }
}
