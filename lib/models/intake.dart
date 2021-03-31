import 'package:flutter_foodtracker/models/nutrition.dart';

class Intake {
  DateTime date;
  Nutrition nutrition;
  String userId;

  Intake.fromJson(Map <String, dynamic> json) {
    date = DateTime.parse(json['date']);
    nutrition = Nutrition.fromJson(json['nutrition']);
    userId = json['userId'];
  }

}