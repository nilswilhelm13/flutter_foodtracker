import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/models/dashboard_data.dart';
import 'package:http/http.dart' as http;

class DashboardProvider with ChangeNotifier {
  DashboardData _dashboardData;

  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2MTc3MjQyNTAsInVzZXIiOiJ0ZXN0QGV4YW1wbGUuY29tIn0.FebKTuCM1ZuDt6_iDFtceNh9aUQSL6S27V8yS7_7qzk';

  Future<void> fetchIntake() async {

    var url =
    Uri.https('backend.nilswilhelm.net', 'dashboard');
    try {
      final response = await http.get(url, headers: {
        'Authorization': token,
        'userId': 'test@example.com',
      });
      var dashboardJSON = json.decode(response.body) as Map<String, dynamic>;
      _dashboardData = DashboardData.fromJson(dashboardJSON);
    } catch (error) {
      print(error.toString());
    }
  }

  DashboardData get dashboardData {
    return _dashboardData;
  }
}