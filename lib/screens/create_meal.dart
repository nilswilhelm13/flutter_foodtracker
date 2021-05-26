import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/error_handling/food_not_found_exception.dart';
import 'package:flutter_foodtracker/models/food.dart';
import 'package:flutter_foodtracker/models/ingredient.dart';
import 'package:flutter_foodtracker/models/nutrition.dart';
import 'package:flutter_foodtracker/providers/food_provider.dart';
import 'package:flutter_foodtracker/search/food_search.dart';
import 'package:flutter_foodtracker/widgets/app_drawer.dart';
import 'package:flutter_foodtracker/widgets/food_not_found_dialog.dart';
import 'package:flutter_foodtracker/widgets/meal_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../barcode.dart';

class CreateMeal extends StatefulWidget {
  static const routeName = '/create-meal';

  @override
  _CreateMealState createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  List<Ingredient> _ingredients = [];

  String mealName;

  double energy = 0;
  double fat = 0;
  double carbohydrate = 0;
  double protein = 0;
  double amount = 0;

  double customTotal = 0;

  void recalcValues() {
    energy = 0;
    fat = 0;
    carbohydrate = 0;
    protein = 0;
    _ingredients.forEach((ingredient) {
      energy += ingredient.food.nutrition.energy * ingredient.amount;
      fat += ingredient.food.nutrition.fat * ingredient.amount;
      carbohydrate +=
          ingredient.food.nutrition.carbohydrate * ingredient.amount;
      protein += ingredient.food.nutrition.protein * ingredient.amount;
      amount += ingredient.amount;
    });
    amount = customTotal > 0 ? customTotal : amount;
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
                showSearch(context: context, delegate: FoodSearch())
                    .then((value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _ingredients.add(Ingredient(value as Food, 0));
                  });
                });
              }),
          IconButton(
              icon: Icon(Icons.qr_code_scanner),
              onPressed: () {
                Barcode.scanBarcode().then((value) {
                  Provider.of<FoodProvider>(context, listen: false)
                      .getFoodByEan(value)
                      .then((value) {
                    setState(() {
                      _ingredients.add(Ingredient(value, 0));
                    });
                  }).catchError((error) {
                    if (error is FoodNotFoundException) {
                      showDialog(
                          context: context,
                          builder: (ctx) => FoodNotFoundDialog(error.ean));
                    }
                  });
                });
              }),
          IconButton(icon: Icon(Icons.post_add), onPressed: postMeal),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
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
                                      onSubmitted: (value) {
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
              height: MediaQuery.of(context).size.height * 0.2,
              child: MealInfo(
                energy: energy,
                fat: fat,
                carbohydrate: carbohydrate,
                protein: protein,
                customTotalHandler: (value) {
                  setState(() {
                    customTotal = double.parse(value);
                    recalcValues();
                  });
                },
                nameHandler: (value) {
                  setState(() {
                    this.mealName = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> postMeal() {
    var url = Uri.https(HttpConfig.baseUrl, 'foodlist/1');
    http
        .post(url,
            headers: {
              'Authorization': HttpConfig.token,
              'userId': HttpConfig.userId,
            },
            body: json.encode(Food(
                    name: mealName,
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
