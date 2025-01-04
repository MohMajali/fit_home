import 'package:app/Models/level_model.dart';
import 'package:app/Pages/plans.dart';
import 'package:flutter/material.dart';

class LevelComponent extends StatelessWidget {
  List<LevelModel> levels;
  String userName;
  LevelComponent({super.key, required this.levels, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        levels.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10), // Adds horizontal spacing
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlansScreen(
                    levelId: levels[index].id,
                    userName: userName,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xffADE1F7),
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("assets/image/levels.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 6), // Space between the image and text
                Text(levels[index].levelName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
