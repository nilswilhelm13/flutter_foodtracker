import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodtracker/models/food.dart';
import 'package:flutter_foodtracker/models/ingredient.dart';
import 'package:flutter_foodtracker/models/nutrition.dart';
import 'package:flutter_foodtracker/search/custom_search_delegate.dart';
import 'package:flutter_foodtracker/widgets/meal_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateMeal extends StatefulWidget {
  static const routeName = '/create-meal';

  @override
  _CreateMealState createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  List<Ingredient> _ingredients = [];

  double energy = 0;
  double fat = 0;
  double carbohydrate = 0;
  double protein = 0;
  double amount = 0;

  void recalcValues() {
    energy = 0;
    fat = 0;
    carbohydrate = 0;
    protein = 0;
    _ingredients.forEach((ingredient) {
      energy += ingredient.food.nutrition.energy * ingredient.amount / 100;
      fat += ingredient.food.nutrition.fat * ingredient.amount / 100;
      carbohydrate +=
          ingredient.food.nutrition.carbohydrate * ingredient.amount / 100;
      protein += ingredient.food.nutrition.protein * ingredient.amount / 100;
    });
    energy /= amount;
    fat /= amount;
    carbohydrate /= amount;
    protein /= amount;
  }

  List<Widget> ingredientItems() {
    _ingredients.map(
      (ingredient) => ListTile(
        title: Text(
          ingredient.food.name,
        ),
        trailing: TextField(
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Meal'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate())
                    .then((value) {
                  setState(() {
                    _ingredients.add(value as Ingredient);
                  });
                });
              }),
          IconButton(icon: Icon(Icons.post_add), onPressed: postMeal),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: _ingredients
                        .map((e) => ListTile(
                              title: Text(e.food.name),
                              trailing: Container(
                                  width: 40,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        e.amount = double.parse(value);
                                        recalcValues();
                                      });
                                    },
                                  )),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: MealInfo(
              energy: energy,
              fat: fat,
              carbohydrate: carbohydrate,
              protein: protein,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postMeal() {
    const String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2MTc3MjQyNTAsInVzZXIiOiJ0ZXN0QGV4YW1wbGUuY29tIn0.FebKTuCM1ZuDt6_iDFtceNh9aUQSL6S27V8yS7_7qzk';
    var url = Uri.https('backend.nilswilhelm.net', 'foodlist/1');
    http
        .post(url,
            headers: {
              'Authorization': token,
              'userId': 'test@example.com',
            },
            body: json.encode(Food(
                    name: 'Flutter Meal Test',
                    userId: 'test@example.com',
                    nutrition: Nutrition(
                      energy: energy,
                      fat: fat,
                      carbohydrate: carbohydrate,
                      protein: protein,
                    ),
                    isMeal: true,
                    ingredients: _ingredients)
                .toJson()))
        .then((value) {
      print(value.body);
      print('success');
    });
  }
}
