import 'dart:convert';
import 'dart:developer';
import 'package:electric_scooters/Models/user.dart';
import 'package:electric_scooters/Pages/Signup/sign_up.dart';
import 'package:electric_scooters/Pages/main_screen.dart';
import 'package:electric_scooters/main.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:http/http.dart' as http;
import 'package:electric_scooters/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController universityIdController= TextEditingController();
  TextEditingController passCont = TextEditingController();

  Future login(String universityId, String password, BuildContext context) async {
    log("$universityId $password");
    try {
      var response = await http.post(Uri.parse('$URL/login.php'),
          body: {'university_id': universityId, 'password': password});

      var userResponse = json.decode(response.body);

      if (!userResponse['error']) {
        prefs?.setInt('userId', userResponse['user']['id']);
        await getUser(userResponse['user']['id'], context);
      } else {
        DangerAlertBox(
            title: "Login Error",
            context: context,
            messageText: "University ID Or Password Is Incorrect",
            buttonColor: errorColors,
            icon: Icons.cancel,
            titleTextColor: errorColors);
      }
      return userResponse;
    } catch (err) {
      log('LOGIN FUNCTION ===> $err');
    }
  }

  Future getUser(int userId, BuildContext context) async {
    try {
      var response = await http.get(
        Uri.parse('$URL/get_user.php?id=$userId'),
      );

      var userResponse = json.decode(response.body);
      if (!userResponse['error']) {
        UserModel.fromJson(userResponse);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
      return userResponse;
    } catch (err) {
      log('LOGIN FUNCTION ===> $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      const SizedBox(height: 20),
      Form(
          key: _formKey,
          child: Column(children: [
            Image.asset("assets/logo.jpeg"),
            nationalIdInput(),
            passwordInput(),
            const SizedBox(height: 10),
            button(
                text: "Login",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    await login(universityIdController.text, passCont.text, context);
                  }
                }),
            const SizedBox(height: 20),
            divider(),
            const SizedBox(height: 10),
            button(
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()));
                },
                text: "Signup"),
          ]))
    ]));
  }

  Padding nationalIdInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.text,
            controller: universityIdController,
            validator: (universityId) {
              if (universityId!.isEmpty) {
                return 'Please fill';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'University ID',
                hintText: 'University ID',
                icon: const Icon(Icons.email, color: Colors.blue))));
  }

  Padding passwordInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: passCont,
            validator: (pass) {
              if (pass!.isEmpty) {
                return 'Please fill';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Password',
                hintText: 'Password',
                icon: const Icon(Icons.lock, color: Colors.blue))));
  }
}
