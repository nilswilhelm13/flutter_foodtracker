import 'package:flutter_foodtracker/models/nutrition.dart';

import 'food.dart';

class Transaction {
  String id;
  String foodId;
  Food food;
  String foodName;
  double amount;
  Nutrition nutrition;
  bool isMeal;
  DateTime date;
  String userId;


  Transaction({this.id, this.foodId, this.food, this.foodName, this.amount,
      this.nutrition, this.isMeal, this.date, this.userId});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodId = json['foodId'];
    food = Food.fromJson(json['food']);
    foodName = json['foodName'];
    amount = json['amount'] is int ? (json['amount'] as int).toDouble() : json['amount'];
    nutrition = Nutrition.fromJson(json['nutrition']);
    isMeal = false;
    date = DateTime.parse(json['date']);
    userId = json['userId'];
  }
}
