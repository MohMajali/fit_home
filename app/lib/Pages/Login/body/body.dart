import 'dart:convert';
import 'dart:developer';
import 'package:app/Models/user_model.dart';
import 'package:app/Pages/Signup/sign_up.dart';
import 'package:app/Pages/main_screen.dart';
import 'package:app/constants.dart';
import 'package:app/main.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passCont = TextEditingController();

  Future login(String email, String password, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse('$URL/Login.php'),
          body: {'email': email, 'password': password});

      var userResponse = json.decode(response.body);

      if (!userResponse['error']) {
        prefs?.setInt('userId', userResponse['user']['id']);

        UserModel.fromJson(userResponse);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        DangerAlertBox(
            title: "Login Error",
            context: context,
            messageText: "Email Or Password Is Incorrect",
            buttonColor: errorColors,
            icon: Icons.cancel,
            titleTextColor: errorColors);
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
            Image.asset("assets/Logo.png", height: 200),
            emailInput(),
            passwordInput(),
            const SizedBox(height: 10),
            button(
                text: "Login",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    await login(emailController.text, passCont.text, context);
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

  Padding emailInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            validator: (email) {
              if (email!.isEmpty) {
                return 'Please fill';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Email',
                hintText: 'Email',
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
