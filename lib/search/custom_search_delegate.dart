import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/models/food.dart';
import 'package:flutter_foodtracker/models/ingredient.dart';
import 'package:flutter_foodtracker/models/nutrition.dart';

class CustomSearchDelegate extends SearchDelegate {
  var names = ['Celina', 'Nils', 'Horst', 'Miriam'];

  Ingredient _ingredient = Ingredient(Food(
      id: 'id',
      name: 'Apfel',
      nutrition:
      Nutrition(energy: 12, fat: 23, carbohydrate: 43, protein: 9999)), 12);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // return Column(
    //   children: names.map((e) => Text(e)).toList()
    // );
    return Center(
        child: ListTile(
      title: Text('Hallo'),
      trailing: IconButton(
        icon: Icon(Icons.car_rental),
        onPressed: () {
          close(context, _ingredient);
        },
      ),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('Tschüss'));
  }
}
