import 'package:app/Models/category_meal_model.dart';
import 'package:app/Pages/meals.dart';
import 'package:flutter/material.dart';

class CategoryMealComponent extends StatelessWidget {
  List<CategoryMealModel> categories;
  String userName;
  CategoryMealComponent(
      {super.key, required this.categories, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        categories.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealsPage(
                    categoryName: categories[index].categoryName,
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
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("assets/image/levels.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Space between image and text
                Text(categories[index].categoryName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
