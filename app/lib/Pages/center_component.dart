import 'package:app/Models/center_model.dart';
import 'package:app/Pages/center_screen.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CenterComponent extends StatelessWidget {
  List<CenterModel> centers;
  String userName, userEmail;
  CenterComponent(
      {super.key,
      required this.centers,
      required this.userName,
      required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          centers.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10), // Adds spacing between items
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CenterScreen(
                          centerId: centers[index].id,
                          userId: prefs!.getInt("userId") ?? 0,
                          name: centers[index].name,
                          email: centers[index].email,
                          phone: centers[index].phone,
                          image: centers[index].image,
                          description: centers[index].description,
                          userName: userName,
                          userEmail: userEmail,
                        ),
                      ),
                    );
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
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      centers[index].image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 6), // Space between circle and text
                Text(centers[index].name),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
