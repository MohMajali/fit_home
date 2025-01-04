import 'package:app/Pages/Login/body/body.dart';
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
            backgroundColor: const Color(0xffADE1F7),
      appBar: AppBar(
      backgroundColor: const Color(0xffADE1F7),
        
          title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Login")],
      )),
      body: const Body(),
    );
  }
}
