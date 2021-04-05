import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/models/food.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {

  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2MTc3MjQyNTAsInVzZXIiOiJ0ZXN0QGV4YW1wbGUuY29tIn0.FebKTuCM1ZuDt6_iDFtceNh9aUQSL6S27V8yS7_7qzk';

  Future<List<Food>> searchFood(String query) async {
    var url =
    Uri.https('backend.nilswilhelm.net', 'search');
    try {
      final response = await http.get(url, headers: {
        'Authorization': token,
        'userId': 'test@example.com',
      });
      var foodsJSON = json.decode(response.body) as List<dynamic>;
      var result = foodsJSON
          .map((transaction) =>
          Food.fromJson(transaction as Map<String, dynamic>))
          .toList();
      print(result);
      return Future.value(result);
    } catch (error) {
      print(error.toString());
    }
  }
}
