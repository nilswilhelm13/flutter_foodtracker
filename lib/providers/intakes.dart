import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/models/intake.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Intakes with ChangeNotifier {
  Intake _intake;


  Future<void> fetchIntake() async {
    final prefs = await SharedPreferences.getInstance();
    var url =
    Uri.https(HttpConfig.baseUrl, 'dahsboard');
    try {
      final response = await http.get(url, headers: {
        'Authorization': prefs.getString('token'),
        'userId': prefs.getString('userId'),
      });
      var intakeJSON = json.decode(response.body) as Map<String, dynamic>;
      _intake = Intake.fromJson(intakeJSON);
    } catch (error) {
      print(error.toString());
    }
  }

  Intake get intake {
    return _intake;
  }
}