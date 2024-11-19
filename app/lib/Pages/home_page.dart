import 'dart:developer';
import 'package:app/Models/center_model.dart';
import 'package:app/Models/level_model.dart';
import 'package:app/Pages/center_component.dart';
import 'package:app/Pages/level_component.dart';
import 'package:app/constants.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CenterModel> centers = [];
  List<LevelModel> levels = [];

  Future<List<CenterModel>> getCenters() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/Get_Centers.php'),
      );

      // var scootersResponse = json.decode(response.body);
      List<CenterModel> centersList = [];

      centersList = centerModelFromJson(response.body);

      return centersList;
    } catch (err) {
      log('getCenter FUNCTION ===> $err');
      return [];
    }
  }

  Future<List<LevelModel>> getLevels() async {
    try {
      var response = await http.get(
        Uri.parse(
            '$URL/Get_User_Levels.php?user_id=${prefs?.getInt('userId')}'),
      );

      // var scootersResponse = json.decode(response.body);
      List<LevelModel> levelsList = [];

      levelsList = levelModelFromJson(response.body);

      return levelsList;
    } catch (err) {
      log('getLevels FUNCTION ===> $err');
      return [];
    }
  }

  @override
  void initState() {
    getCenters().then((value) => {
          setState(() {
            centers = value;
          })
        });

    getLevels().then((value) => {
          setState(() {
            levels = value;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hi "),
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
                "Centers",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              CenterComponent(centers: centers),
              const SizedBox(height: 25),
              Text("Levels", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 15),
              LevelComponent(levels: levels)
            ]));
  }
}
