import 'dart:convert';
import 'dart:developer';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CenterScreen extends StatefulWidget {
  final int centerId, userId;
  final String name, image, description, phone, email;
  const CenterScreen(
      {super.key,
      required this.centerId,
      required this.userId,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.description});

  @override
  State<CenterScreen> createState() => _CenterState();
}

class _CenterState extends State<CenterScreen> {
  final _formKey = GlobalKey<FormState>();

  Future makeAppointement(
      String date, centerId, userId, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse("$URL/Make_Appointement.php"),
          body: {
            "user_id": "$userId",
            "center_id": "$centerId",
            "appointment_date": date
          });

      var appResponse = json.decode(response.body);

      if (!appResponse['error']) {
        SuccessAlertBox(
            title: "Success",
            messageText: "${appResponse['message']}",
            titleTextColor: Colors.amber,
            context: context);
      } else {
        DangerAlertBox(
            title: "Appointement Error",
            messageText: "${appResponse['message']}",
            buttonColor: errorColors,
            icon: Icons.cancel,
            titleTextColor: errorColors,
            context: context);
      }
    } catch (e) {
      log("${e}");
    }
  }

  TextEditingController dateTimeCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      const SizedBox(height: 50),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                          radius: 150,
                          backgroundImage: NetworkImage(widget.image)),
                      const SizedBox(height: 15),
                      Text(widget.name,
                          style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      const SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: const Icon(Icons.call,
                                    color: Colors.black, size: 25)),
                            const SizedBox(width: 20),
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: InkWell(
                                  onTap: () async {},
                                  child: const Icon(Icons.chat,
                                      color: Colors.black, size: 25),
                                ))
                          ])
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
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
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
                    dateTimeInput(),
                    const SizedBox(height: 10),
                    Center(
                        child: TextButton(
                            onPressed: () async {
                              await makeAppointement(dateTimeCont.text,
                                  widget.centerId, widget.userId, context);
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: const BorderSide(
                                            color: Colors.black)))),
                            child: const Text("Make Appointement",
                                style: TextStyle(color: Colors.black))))
                  ])))
    ])));
  }

  Padding dateTimeInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            readOnly: true,
            keyboardType: TextInputType.datetime,
            controller: dateTimeCont,
            onTap: () async {
              DatePicker.showDateTimePicker(context,
                  locale: LocaleType.en,
                  showTitleActions: true,
                  minTime: DateTime(2024, 11, 15),
                  maxTime: DateTime(2025, 11, 15),
                  onChanged: (time) => dateTimeCont.text = "$time",
                  onConfirm: (time) => dateTimeCont.text = "$time",
                  onCancel: () => dateTimeCont.text = "${DateTime.now()}",
                  currentTime: DateTime.now());
            },
            validator: (startTime) {
              if (startTime!.isEmpty) {
                return 'Please fill';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Date Time',
                hintText: 'Date Time',
                icon: const Icon(Icons.timelapse, color: Colors.blue))));
  }
}
