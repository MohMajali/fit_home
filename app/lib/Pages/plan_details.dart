import 'dart:convert';
import 'dart:developer';

import 'package:app/Models/level_model.dart';
import 'package:app/constants.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class PlanDetailsScreen extends StatefulWidget {
  int planId, userPlanId;
  String image, name, description;
  bool isDone;

  PlanDetailsScreen(
      {super.key,
      required this.planId,
      required this.userPlanId,
      required this.name,
      required this.image,
      required this.description,
      required this.isDone});

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  Future updatePlan(userPlanId, BuildContext context) async {
    try {
      var response =
          await http.post(Uri.parse("$URL/Update_Plan_Done.php"), body: {
        "user_plan_id": "$userPlanId",
      });

      var appResponse = json.decode(response.body);

      if (!appResponse['error']) {
        Navigator.pop(context);
      } else {
        DangerAlertBox(
            title: "Appointement Error",
            messageText: "${appResponse['message']}",
            buttonColor: errorColors,
            icon: Icons.cancel,
            titleTextColor: errorColors,
            context: context);
      }
    } catch (e) {
      log("${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: const Color(0xffADE1F7),
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(height: 50),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.black, size: 25)),
                      InkWell(
                          onTap: () {},
                          child: const Icon(Icons.more_vert,
                              color: Colors.black, size: 25))
                    ]),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                              radius: 200,
                              backgroundImage: NetworkImage(widget.image)),
                          const SizedBox(height: 15),
                          Text(widget.name,
                              style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          const SizedBox(height: 5),
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [])
                        ]))
              ])),
          const SizedBox(height: 20),
          Container(
              // height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, right: 15),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Center(
                            child: Text(
                              widget.description,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // dateTimeInput(),
                        const SizedBox(height: 10),
                        Center(
                            child: TextButton(
                                onPressed: () async {
                                  await updatePlan(widget.userPlanId, context);
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: Colors.black)))),
                                child: const Text("Done",
                                    style: TextStyle(color: Colors.black))))
                      ])))
        ])));
  }
}
