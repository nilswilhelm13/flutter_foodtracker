import 'food.dart';

class Ingredient {
  Food food;
  double amount;

  Ingredient(this.food, this.amount);

  Ingredient.fromJson(Map<String, dynamic> json){
    food = Food.fromJson(json['food']);
    amount = json['amount'] is int ? (json['amount'] as int).toDouble() : json['amount'];
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'amount': amount,
    };
  }
}