import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/models/transaction.dart';
import 'package:flutter_foodtracker/providers/dashboard_provider.dart';
import 'package:flutter_foodtracker/screens/create_food.dart';
import 'package:flutter_foodtracker/widgets/generic_error_modal.dart';
import 'package:provider/provider.dart';
import '../models/food.dart';
import 'package:http/http.dart' as http;

class FoodDetails extends StatefulWidget {
  static const routeName = '/food-details';

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  double _amount = 0;

  Widget buildRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value.toStringAsFixed(0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _food = ModalRoute.of(context).settings.arguments as Food;
    return Scaffold(
      appBar: AppBar(
        title: Text(_food.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateFood.routeName,
                  arguments: {'food': _food, 'isEdit': true});
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      content: Text('Are you sure that you want delete ${_food.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteFood(ctx, _food);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            buildRow('Energy', _food.nutrition.energy),
            buildRow('Fat', _food.nutrition.fat),
            buildRow('Carbs', _food.nutrition.carbohydrate),
            buildRow('Protein', _food.nutrition.protein),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = double.parse(value);
                });
              },
            ),
            TextButton(
                onPressed: () => postTransaction(context, _food, _amount),
                child: Text('Submit')),
          ],
        ),
      ),
    );
  }

  Future<void> postTransaction(BuildContext ctx, Food food, double _amount) {
    var url = Uri.https(HttpConfig.baseUrl, 'intake');
    return http
        .post(url,
            headers: {
              'Authorization': HttpConfig.token,
              'userId': HttpConfig.userId,
            },
            body: json.encode(Transaction(
                    food: food,
                    amount: _amount,
                    foodId: food.id,
                    date: DateTime.now())
                .toJson()))
        .then((value) {
      Provider.of<DashboardProvider>(ctx, listen: false).fetchIntake();
      Navigator.of(ctx).pop();
    });
  }

  Future<void> deleteFood(BuildContext ctx, Food food) {
    var url = Uri.https(HttpConfig.baseUrl, 'food/${food.id}');
    return http.delete(url, headers: {
      'Authorization': HttpConfig.token,
      'userId': HttpConfig.userId,
    }).then((response) {
      if (response.statusCode != 200) {
        throw Error();
      }
      var nav = Navigator.of(ctx);
      nav.pop();
      nav.pop();
    }).catchError((_) {
      showDialog(
          context: context,
          builder: (ctx) =>
              GenericErrorModal(Exception('could not delete food')));
    });
  }
}
