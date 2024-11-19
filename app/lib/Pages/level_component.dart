import 'package:app/Models/level_model.dart';
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
                            image: const DecorationImage(
                                image: NetworkImage(
                                    "https://www.searchenginejournal.com/wp-content/uploads/2021/01/category-pages-featured-image-5ffbf8cca689f-1280x720.png"),
                                fit: BoxFit.cover)),
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
