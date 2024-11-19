import 'package:app/Models/center_model.dart';
import 'package:app/Pages/center_screen.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CenterComponent extends StatelessWidget {
  List<CenterModel> centers;
  CenterComponent({super.key, required this.centers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            growable: true,
            centers.length,
            (index) => Column(
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
                                    description: centers[index].description)));
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
                        child: Image.network(
                          centers[index].image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(centers[index].name)
                  ],
                )),
      ),
    );
  }
}
