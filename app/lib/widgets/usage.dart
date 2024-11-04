// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

// import 'package:ecommerce/pages/Info/Info.dart';
import 'package:electric_scooters/Pages/map.dart';
import 'package:flutter/material.dart';

class UsageComponent extends StatelessWidget {
  String name;
  UsageComponent({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CustomIcon> customIcons = [
      CustomIcon(name: "Charging Points", icon: 'assets/charging_points.jpg'),
      CustomIcon(name: "Scooters", icon: 'assets/scooter.jpeg'),
    ];

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(customIcons.length, (i) {
          return Column(children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(type: i, name: name),
                      ));
                },
                borderRadius: BorderRadius.circular(90),
                child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.4),
                        shape: BoxShape.circle),
                    child: Image.asset(customIcons[i].icon, fit: BoxFit.fill))),
            const SizedBox(height: 6),
            Text(customIcons[i].name)
          ]);
        }));
  }
}

class CustomIcon {
  final String name;
  final String icon;

  CustomIcon({required this.name, required this.icon});
}
