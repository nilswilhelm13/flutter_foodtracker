import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodtracker/models/ingredient.dart';

class CreateMeal extends StatefulWidget {
  static const routeName = '/create-meal';

  @override
  _CreateMealState createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  List<Ingredient> _ingredients;

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
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: Card(
                      child: ListTile(
                        title: Text(
                          'ingredient.food.name',
                        ),
                        trailing: Container(
                            width: 40,
                            child: TextField(
                              keyboardType: TextInputType.number,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
