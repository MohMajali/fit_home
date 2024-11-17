import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                "Use",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              // UsageComponent(name: userModel.user.name),
              const SizedBox(height: 25),
              Text("Scooters", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 15),
              // ScootersWidget(
              //     scooters: scooters,
              //     lat: latitude,
              //     long: longtitude,
              //     name: userModel.user.name)
            ]));
  }
}
