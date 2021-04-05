import 'package:flutter_foodtracker/models/ingredient.dart';

import 'nutrition.dart';

class Food {
  String id;
  String ean;
  String name;
  String userId;
  Nutrition nutrition;
  bool isMeal;
  List<Ingredient> ingredients;


  Food({this.id, this.ean, this.name, this.userId, this.nutrition, this.isMeal,
      this.ingredients});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ean = json['ean'];
    name = json['name'];
    userId = json['userId'] != null ? json['userId']: '';
    nutrition = Nutrition.fromJson(json['nutrition']);
    isMeal = json['isMeal'] != null ? json['isMeal'] : false;
    ingredients = isMeal
        ? (json['ingredients'] as List<dynamic>).map((ingredientJSON) =>
            Ingredient.fromJson(ingredientJSON as Map<String, dynamic>)).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ean': ean,
      'name': name,
      'userId': userId,
      'nutrition': nutrition.toJson(),
      'isMeal': isMeal,
      'ingredients': ingredients != null ? ingredients.map((ingredient) => ingredient.toJson()).toList() : [],
    };
  }
}
