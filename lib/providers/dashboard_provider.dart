import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/models/dashboard_data.dart';
import 'package:http/http.dart' as http;

class DashboardProvider with ChangeNotifier {
  DashboardData _dashboardData;

  Future<void> fetchIntake() async {
    var url = Uri.https(HttpConfig.baseUrl, 'dashboard');
    try {
      final response = await http.get(url, headers: {
        'Authorization': HttpConfig.token,
        'userId': HttpConfig.userId,
      });
      if (response.statusCode / 100 != 2) {
        throw Exception('fetching failed. status code: ${response.statusCode}');
      }
      var dashboardJSON = json.decode(response.body) as Map<String, dynamic>;
      _dashboardData = DashboardData.fromJson(dashboardJSON);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  DashboardData get dashboardData {
    return _dashboardData;
  }
}
