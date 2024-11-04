import 'dart:convert';
import 'dart:developer';
import 'package:electric_scooters/Pages/Login/login_page.dart';
import 'package:electric_scooters/constants.dart';
import 'package:electric_scooters/main.dart';
import 'package:http/http.dart' as http;
import 'package:electric_scooters/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:ionicons/ionicons.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();

  UserModel userModel = UserModel(
      error: false,
      user: User(
          id: 0,
          userType: "",
          name: '',
          nationalId: '',
          password: '',
          phone: '',
          universityId: '',
          active: 0,
          createdAt: DateTime.now()));

  Future getUser() async {
    try {
      var response = await http.get(
        Uri.parse('$URL/get_user.php?id=${prefs?.getInt('userId')}'),
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

  Future updateAccount(
      String name, String phone, String password, BuildContext context) async {
    try {
      var response =
          await http.post(Uri.parse('$URL/update_account.php'), body: {
        "name": name,
        "password": password,
        "phone": phone,
        "id": "${prefs?.getInt("userId")}"
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
    getUser().then((value) {
      setState(() {
        userModel = UserModel(
            error: false,
            user: User(
                id: value['user']['id'],
                userType: value['user']['user_type'],
                name: value['user']['name'],
                nationalId: value['user']['national_id'],
                password: value['user']['password'],
                phone: value['user']['phone'],
                universityId: value['user']['university_id'],
                active: value['user']['active'],
                createdAt: DateTime.now()));

        nameCont.text = value['user']['name'];
        passCont.text = value['user']['password'];
        phoneCont.text = value['user']['phone'];
      });
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
            child: Column(children: [
          const SizedBox(height: 20),
          Form(
              key: _formKey,
              child: Column(children: [
                nameInput(nameCont),
                phoneInput(phoneCont),
                passwordInput(passCont),
                button(
                    text: "Update Account",
                    press: () async {
                      if (_formKey.currentState!.validate()) {
                        await updateAccount(nameCont.text, phoneCont.text,
                            passCont.text, context);
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
              ]))
        ])));
  }
}
