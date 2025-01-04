import 'package:flutter/material.dart';

class MealDetailsPage extends StatefulWidget {
  String name, image, description;
  MealDetailsPage(
      {super.key,
      required this.name,
      required this.image,
      required this.description});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: const Color(0xffADE1F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        ])))
          ],
        ),
      ),
    );
  }
}
