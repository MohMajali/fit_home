import 'dart:developer';

import 'package:app/Models/appointement.dart';
import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class AppointementsScreen extends StatefulWidget {
  const AppointementsScreen({super.key});

  @override
  State<AppointementsScreen> createState() => _AppointementsScreenState();
}

class _AppointementsScreenState extends State<AppointementsScreen> {
  List<AppointmentModel> appointements = [];

  Future<List<AppointmentModel>> getAppointements() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/Get_Appointements.php?user_id=1'),
      );

      // var scootersResponse = json.decode(response.body);
      List<AppointmentModel> appointementsList = [];

      appointementsList = appointmentModelFromJson(response.body);

      return appointementsList;
    } catch (err) {
      log('getAppointemnts FUNCTION ===> $err');
      return [];
    }
  }

  @override
  void initState() {
    getAppointements().then((value) => setState(() {
          appointements = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi "),
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
              appointements.length,
              (index) => InkWell(
                    onTap: () {},
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
                                        appointements[index].image),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appointements[index].centerName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(appointements[index].status,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(
                                  appointements[index]
                                      .appointmentDate
                                      .toString(),
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
