import 'package:flutter/cupertino.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/error_handling/food_not_found_exception.dart';
import 'package:flutter_foodtracker/models/food.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodProvider with ChangeNotifier {
  Future<Food> getFoodByEan(String ean) {
    var url = Uri.https(HttpConfig.baseUrl, 'food/$ean', {'ean': 'true'});
    return http.get(
      url,
      headers: {
        'Authorization': HttpConfig.token,
        'userId': HttpConfig.userId,
      },
    ).then((response) {
      if (response.statusCode == 404) {
        throw FoodNotFoundException(ean);
      }
      var foodJson = json.decode(response.body) as Map<String, dynamic>;
      return Food.fromJson(foodJson);
    }).catchError((error) {
      if (error is FoodNotFoundException) {
        throw error;
      } else {
        print(error);
      }
    });
  }
}
