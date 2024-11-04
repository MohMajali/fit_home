import 'dart:convert';
import 'dart:developer';

import 'package:electric_scooters/constants.dart';
import 'package:http/http.dart' as http;

class UserServices {
  Future login(String nationalId, String password) async {
    try {
      final body =
          jsonEncode({'national_id': nationalId, 'password': password});

      var response = await http.post(Uri.parse('$URL/login'),
          headers: {'Content-Type': 'application/json'}, body: body);

      var userResponse = json.decode(response.body);
      return userResponse;
    } catch (err) {
      log('LOGIN FUNCTION ===> $err');
    }
  }
}