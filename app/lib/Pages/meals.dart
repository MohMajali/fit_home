import 'dart:developer';

import 'package:app/Models/meal_model.dart';
import 'package:app/Pages/meal_details.dart';
import 'package:app/constants.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class MealsPage extends StatefulWidget {
  String categoryName, userName;
  MealsPage({super.key, required this.categoryName, required this.userName});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  List<MealModel> meals = [];

  Future<List<MealModel>> getMeals() async {
    try {
      var response = await http.get(
        Uri.parse(
            '$URL/Get_User_Meals.php?user_id=${prefs?.getInt('userId')}&category_name=${widget.categoryName}'),
      );

      // var scootersResponse = json.decode(response.body);
      List<MealModel> mealsList = [];

      mealsList = mealModelFromJson(response.body);

      return mealsList;
    } catch (err) {
      log('getMeals FUNCTION ===> $err');
      return [];
    }
  }

  @override
  void initState() {
    getMeals().then((value) => setState(() {
          meals = value;
        }));
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
            Text("Hi ${widget.userName}"),
          ]),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Ionicons.notifications_outline)),
            IconButton(
                onPressed: () {}, icon: const Icon(Ionicons.search_outline))
          ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: List.generate(
              meals.length,
              (index) => InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealDetailsPage(
                                name: meals[index].name,
                                image: meals[index].image,
                                description: meals[index].description),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(meals[index].image),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(meals[index].name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(meals[index].categoryName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(meals[index].centerName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
