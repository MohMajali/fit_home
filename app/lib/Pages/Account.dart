import 'dart:convert';
import 'dart:developer';

import 'package:app/Models/user_model.dart';
import 'package:app/Pages/Login/login_page.dart';
import 'package:app/constants.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  UserModel userModel = UserModel(
      error: false,
      message: "",
      user: User(id: 0, name: "", email: "", phone: "", userName: ""));

  Future getUser() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/Get_User_Data.php?user_id=${prefs?.getInt('userId')}'),
      );

      var userResponse = json.decode(response.body);
      if (!userResponse['error']) {
        UserModel.fromJson(userResponse);
      } else {
        log("message");
      }
      return userResponse;
    } catch (err) {
      log('getUser FUNCTION ===> $err');
    }
  }

  Future updateAccount(String name, String phone, String email, String userName,
      String password, BuildContext context) async {
    try {
      var response =
          await http.post(Uri.parse('$URL/Update_Account.php'), body: {
        "user_id": "${prefs?.getInt("userId")}",
        "name": name,
        "email": email,
        "phone": phone,
        "user_name": userName,
        "password": password,
      });

      var userResponse = json.decode(response.body);
      if (!userResponse['error']) {
        getUser();
        SuccessAlertBox(
            title: "Update Account",
            context: context,
            messageText: "Account Updated Successfully",
            buttonColor: darkBlue,
            icon: Icons.check_circle,
            titleTextColor: darkBlue);
      } else {
        log("message");
      }
      return userResponse;
    } catch (err) {
      log('getUser FUNCTION ===> $err');
    }
  }

  @override
  void initState() {
    getUser().then((value) => {
          setState(() {
            userModel = UserModel(
                error: false,
                message: "",
                user: User(
                    id: value['user']['id'],
                    name: value['user']['name'],
                    email: value['user']['email'],
                    phone: value['user']['phone'],
                    userName: value['user']['user_name']));

            nameCont.text = value['user']['name'];
            phoneCont.text = value['user']['phone'];
            emailCont.text = value['user']['email'];
            userNameCont.text = value['user']['user_name'];
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Profile Account")]),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Ionicons.notifications_outline)),
            IconButton(
                onPressed: () {}, icon: const Icon(Ionicons.search_outline))
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  nameInput(nameCont),
                  userNameInput(userNameCont),
                  emailInput(emailCont),
                  phoneInput(phoneCont),
                  passwordInput(passCont, true),
                  button(
                      text: "Update Account",
                      press: () async {
                        if (_formKey.currentState!.validate()) {
                          await updateAccount(
                              nameCont.text,
                              phoneCont.text,
                              emailCont.text,
                              userNameCont.text,
                              passCont.text,
                              context);
                        }
                      }),
                  button(
                      text: "Logout",
                      press: () async {
                        await prefs?.remove("userId");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false);
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
