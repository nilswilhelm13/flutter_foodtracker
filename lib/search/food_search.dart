import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/models/food.dart';
import 'package:flutter_foodtracker/models/ingredient.dart';
import 'package:http/http.dart' as http;

class FoodSearch extends SearchDelegate {

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
    return FutureBuilder(
        future: searchFood(query),
        builder: (context, AsyncSnapshot<List<Food>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (ctx, i) => ListTile(
                onTap: () {
                  close(context, snapshot.data[i]);
                },
                title: Text(
                  snapshot.data[i].name,
                ),
              ),
            );
          }
          return Center(
            child: Text('Nothing found'),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('Tschüss'));
  }

  Future<List<Food>> searchFood(String query) async {
    print('search food ...');
    var url = Uri.https(HttpConfig.baseUrl, 'search/$query');
    try {
      final response = await http.get(url, headers: {
        'Authorization': HttpConfig.token,
        'userId': HttpConfig.userId,
      });
      var foodsJSON = json.decode(response.body) as List<dynamic>;
      print(foodsJSON);
      var result = foodsJSON
          .map((food) => Food.fromJson(food as Map<String, dynamic>))
          .toList();
      return result;
    } catch (error) {
      print(error.toString());
    }
  }
}
