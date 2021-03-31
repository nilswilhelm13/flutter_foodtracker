import 'package:flutter_foodtracker/models/nutrition.dart';

class DailyGoals {
  Nutrition nutrition;
  String userId;
  double water;

  DailyGoals.fromJson(Map<String, dynamic> json) {
    nutrition = Nutrition.fromJson(json['nutrition']);
    userId = json['userId'];
    water = json['water'] == null ? 0 : json['water'] is int ? (json['water'] as int).toDouble() : json['water'];
  }
}