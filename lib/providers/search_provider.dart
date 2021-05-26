import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/models/food.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {

  Future<List<Food>> searchFood(String query) async {
    var url =
    Uri.https(HttpConfig.baseUrl, 'search');
    try {
      final response = await http.get(url, headers: {
        'Authorization': HttpConfig.token,
        'userId': HttpConfig.userId,
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
