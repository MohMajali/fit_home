import 'dart:convert';
import 'dart:developer';

import 'package:app/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();

  TextEditingController emailCont = TextEditingController();

  TextEditingController passCont = TextEditingController();

  TextEditingController phoneCont = TextEditingController();

  TextEditingController userNameCont = TextEditingController();

  TextEditingController passConfirmCont = TextEditingController();

  TextEditingController tallHeightCont = TextEditingController();

  TextEditingController weightCont = TextEditingController();

  final TextEditingController subCont = TextEditingController();

  final TextEditingController dateCont = TextEditingController();

  String selectedSub = '';

  bool visiblePass = true;

  List subscriptions = [
    {"id": "1", "label": "3 Months Open Contract (First Time Only) (For Free)"},
    {"id": "2", "label": "6 Months Contract (300 JOD)"},
    {"id": "3", "label": "12 Months COntract (600 JOD)"}
  ];

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateCont.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future signup(
      BuildContext context,
      String name,
      String email,
      String phone,
      String userName,
      String password,
      String tall,
      String weight,
      String subscriptionType,
      String startDate) async {
    try {
      var response = await http.post(Uri.parse('$URL/Signup.php'), body: {
        'name': name,
        'email': email,
        'phone': phone,
        'user_name': userName,
        'password': password,
        'tall': tall,
        'weight': weight,
        'subscription_type': subscriptionType,
        'start_date': startDate,
      });

      var userResponse = json.decode(response.body);
      if (!userResponse['error']) {
        Navigator.pop(context);
      } else {
        DangerAlertBox(
            title: "Stop",
            context: context,
            messageText: "User With This Email Already Registered",
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
            emailInput(),
            phoneInput(phoneCont),
            userNameInput(userNameCont),
            tallInput(),
            weightInput(),
            subscriptionTypeInput(),
            dateInput(),
            passwordInput(passCont, false),
            confirmPasswordInput(passConfirmCont),
            button(
                text: "Sign Up",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    await signup(
                        context,
                        nameCont.text,
                        emailCont.text,
                        phoneCont.text,
                        userNameCont.text,
                        passCont.text,
                        tallHeightCont.text,
                        weightCont.text,
                        selectedSub,
                        dateCont.text);
                  }
                })
          ]))
    ]));
  }

  Padding subscriptionTypeInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: DropdownMenu(
        width: MediaQuery.of(context).size.width * 0.92,
        initialSelection: selectedSub,
        controller: subCont,
        requestFocusOnTap: true,
        label: const Text("Subscription Type",
            style: TextStyle(color: Colors.blue, fontSize: 20)),
        enableFilter: false,
        enableSearch: false,
        textStyle: const TextStyle(color: Colors.blue, fontSize: 20),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(fontSize: 20, color: Colors.blue),
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
        dropdownMenuEntries: subscriptions
            .map<DropdownMenuEntry>((e) => DropdownMenuEntry(
                  value: e['id'],
                  label: e['label'],
                ))
            .toList(),
        onSelected: (value) {
          setState(() {
            selectedSub = value;
          });
        },
      ),
    );
  }

  Padding dateInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.datetime,
            controller: dateCont,
            onTap: () => _selectDate(context),
            validator: (date) {
              if (date!.isEmpty) {
                return 'Start Date field required';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Start Date',
                hintText: 'Start Date',
                icon: const Icon(Icons.phone, color: Colors.blue))));
  }

  Padding tallInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            controller: tallHeightCont,
            validator: (tall) {
              if (tall!.isEmpty) {
                return 'Tall field required';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Tall height',
                hintText: 'Tall height',
                icon: const Icon(Icons.phone, color: Colors.blue))));
  }

  Padding weightInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            controller: weightCont,
            validator: (tall) {
              if (tall!.isEmpty) {
                return 'Weight field required';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Weight',
                hintText: 'Weight',
                icon: const Icon(Icons.phone, color: Colors.blue))));
  }



  Padding emailInput() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailCont,
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            // ],
            validator: (email) {
              if (email!.isEmpty) {
                return "Email field required";
              }

              if (!email.contains('@')) {
                return 'Please write correct email';
              }
              return null;
            },
            decoration: decoration(
                labelText: 'Email',
                hintText: 'Email',
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
                labelText: 'Confirm Password',
                hintText: 'Confirm Password',
                icon: const Icon(Icons.lock, color: Colors.blue))));
  }
}
