import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodtracker/models/ingredient.dart';
import 'package:flutter_foodtracker/search/custom_search_delegate.dart';

class CreateMeal extends StatefulWidget {
  static const routeName = '/create-meal';

  @override
  _CreateMealState createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  List<Ingredient> _ingredients = [];

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
              })
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(_ingredients.fold(0, (previousValue, element) => previousValue + element.amount).toString()),
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
                                      });
                                    },
                                  )),
                            ))
                        .toList(),
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