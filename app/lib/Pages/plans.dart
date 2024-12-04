import 'dart:developer';

import 'package:app/Models/level_model.dart';
import 'package:app/Pages/plan_details.dart';
import 'package:app/constants.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class PlansScreen extends StatefulWidget {
  int levelId;
  String userName;
  PlansScreen({super.key, required this.levelId, required this.userName});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  List<LevelModel> levels = [];

  Future<List<LevelModel>> getLevels() async {
    try {
      var response = await http.get(
        Uri.parse(
            '$URL/Get_User_Levels.php?user_id=${prefs?.getInt('userId')}'),
      );

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
            children: levels
                .where((element) => element.id == widget.levelId)
                .map((e) => List.generate(
                    e.plans.length,
                    (index) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlanDetailsScreen(
                                      planId: e.plans[index].id,
                                      userPlanId: e.plans[index].userPlanId,
                                      name: e.plans[index].name,
                                      image: e.plans[index].image,
                                      description: e.plans[index].description,
                                      isDone: e.plans[index].isDone),
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
                                          image: NetworkImage(
                                              e.plans[index].image),
                                          fit: BoxFit.cover)),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.plans[index].name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(
                                        e.plans[index].isDone
                                            ? "Done"
                                            : "Not Done",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )))
                .expand((element) => element)
                .toList(),
          ),
        ));
  }
}
