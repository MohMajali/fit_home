import 'package:electric_scooters/Pages/Login/body/body.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Login")],
      )),
      body: const Body(),
    );
  }
}
