import 'package:device_preview/device_preview.dart';
import 'package:electric_scooters/Pages/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:electric_scooters/Pages/Login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        title: 'Electric Scooters',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xff5a73d8),
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
        ),
        home: prefs?.getInt("userId") == null
            ? const LoginScreen()
            : const MainScreen());
  }
}
