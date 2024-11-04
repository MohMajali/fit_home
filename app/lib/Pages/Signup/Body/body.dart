import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:electric_scooters/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController nationalIdCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController universityIdCont = TextEditingController();
  TextEditingController passConfirmCont = TextEditingController();

  bool visiblePass = true;

  Future signup(String nationalId, String password, String name,
      String universityId, String phone, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse('$URL/signup.php'), body: {
        'national_id': nationalId,
        'password': password,
        'name': name,
        'phone': phone,
        'university_id': universityId
      });

      var userResponse = json.decode(response.body);

      if (!userResponse['error']) {
        Navigator.pop(context);
      } else {
        DangerAlertBox(
            title: "Stop",
            context: context,
            messageText: "User With This National ID Already Registered",
            buttonColor: darkBlue,
            icon: Icons.cancel,
            titleTextColor: darkBlue);
      }
      return userResponse;
    } catch (err) {
      log('Sign up FUNCTION ===> $err');
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
            nameInput(nameCont),
            nationalIdInput(),
            universityIdInput(),
            phoneInput(phoneCont),
            passwordInput(passCont),
            confirmPasswordInput(passConfirmCont),
            button(
                text: "Sign Up",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    await signup(
                        nationalIdCont.text,
                        passCont.text,
                        nameCont.text,
                        universityIdCont.text,
                        phoneCont.text,
                        context);
                  }
                })
          ]))
    ]));
  }

  Padding universityIdInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.number,
            controller: universityIdCont,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            validator: (universityId) {
              if (universityId!.isEmpty) {
                return 'Please fill';
              } else if (universityId.length > 10 || universityId.length < 10) {
                return "University ID Must Be 10 Digits Only";
              }
              return null;
            },
            decoration: decoration(
                labelText: 'University ID',
                hintText: 'University ID',
                icon: const Icon(Icons.book, color: Colors.blue))));
  }

  Padding nationalIdInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.number,
            controller: nationalIdCont,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            validator: (national) {
              if (national!.isNotEmpty) {
                if (national.length > 10 || national.length < 10) {
                  return "National ID Must Be 10 Digits Only";
                }
              }
              return null;
            },
            decoration: decoration(
                labelText: 'National ID',
                hintText: 'National ID',
                icon: const Icon(Icons.numbers, color: Colors.blue))));
  }

  Padding confirmPasswordInput(TextEditingController confirmPassCont) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: confirmPassCont,
            validator: (confirmPass) {
              if (confirmPass!.isEmpty) {
                return 'Please fill';
              } else if (passCont.text != confirmPassCont.text) {
                return 'Passwords Do Not Match';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Password',
                hintText: 'Password',
                icon: const Icon(Icons.lock, color: Colors.blue))));
  }
}
