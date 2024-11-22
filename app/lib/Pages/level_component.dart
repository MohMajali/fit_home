import 'package:app/Models/level_model.dart';
import 'package:app/Pages/plans.dart';
import 'package:flutter/material.dart';

class LevelComponent extends StatelessWidget {
  List<LevelModel> levels;
  LevelComponent({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          levels.length,
          (index) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlansScreen(
                              levelId: levels[index].id)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage("assets/image/levels.png"),
                                fit: BoxFit.contain)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(levels[index].levelName)],
                      )
                    ],
                  ),
                ),
              )),
    );
  }
}
