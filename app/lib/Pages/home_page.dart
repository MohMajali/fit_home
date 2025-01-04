import 'dart:convert';
import 'dart:developer';
import 'package:app/Models/category_meal_model.dart';
import 'package:app/Models/center_model.dart';
import 'package:app/Models/level_model.dart';
import 'package:app/Models/meal_model.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/Pages/center_component.dart';
import 'package:app/Pages/level_component.dart';
import 'package:app/Pages/category_meal_component.dart';
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
  List<CategoryMealModel> categories = [];

  UserModel userModel = UserModel(
      error: false,
      message: "",
      user: User(id: 0, name: "", email: "", phone: "", userName: ""));

  Future getUser() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/Get_User_Data.php?user_id=${prefs?.getInt('userId')}'),
      );

      var userResponse = json.decode(response.body);
      if (!userResponse['error']) {
        UserModel.fromJson(userResponse);
      } else {
        log("message");
      }
      return userResponse;
    } catch (err) {
      log('getUser FUNCTION ===> $err');
    }
  }

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

  Future<List<CategoryMealModel>> getCategoriesMeals() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/Get_Meals_Categories.php'),
      );

      // var scootersResponse = json.decode(response.body);
      List<CategoryMealModel> categories = [];

      categories = categoryMealModelFromJson(response.body);

      return categories;
    } catch (err) {
      log('getLevels FUNCTION ===> $err');
      return [];
    }
  }

  @override
  void initState() {
    getUser().then((value) => {
          setState(() {
            userModel = UserModel(
                error: false,
                message: "",
                user: User(
                    id: value['user']['id'],
                    name: value['user']['name'],
                    email: value['user']['email'],
                    phone: value['user']['phone'],
                    userName: value['user']['user_name']));
          })
        });

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

    getCategoriesMeals().then((value) => {
          setState(() {
            categories = value;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffADE1F7),
        appBar: AppBar(
            backgroundColor: const Color(0xffADE1F7),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Hi ${userModel.user.userName}"),
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
              CenterComponent(
                centers: centers,
                userName: userModel.user.userName,
                userEmail: userModel.user.email,
              ),
              const SizedBox(height: 25),
              Text("Levels", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 15),
              LevelComponent(
                levels: levels,
                userName: userModel.user.userName,
              ),
              const SizedBox(height: 15),
              Text("Meals Categories",
                  style: Theme.of(context).textTheme.titleLarge),
              CategoryMealComponent(
                categories: categories,
                userName: userModel.user.userName,
              )
            ]));
  }
}
