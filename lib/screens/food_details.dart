import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/colors.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/models/transaction.dart';
import 'package:flutter_foodtracker/providers/dashboard_provider.dart';
import 'package:flutter_foodtracker/screens/create_food.dart';
import 'package:flutter_foodtracker/widgets/generic_error_modal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food.dart';
import 'package:http/http.dart' as http;

class FoodDetails extends StatefulWidget {
  static const routeName = '/food-details';

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  double _amount = 0;
  DateTime date = DateTime.now();

  Widget buildRow(String label, double value, Color color) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value.toStringAsFixed(0)),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.5)],
          )),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
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
                      content: Text(
                          'Are you sure that you want delete ${_food.name}?'),
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
            buildRow('Energy', _food.nutrition.energy, FoodColors.energy),
            buildRow('Fat', _food.nutrition.fat, FoodColors.fat),
            buildRow(
                'Carbs', _food.nutrition.carbohydrate, FoodColors.carbohydrate),
            buildRow('Protein', _food.nutrition.protein, FoodColors.protein),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030))
                            .then((value) => {date = value});
                      },
                      icon: Icon(Icons.calendar_today)),
                  Container(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Amount",
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _amount = double.parse(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => postTransaction(context, _food, _amount),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> postTransaction(
      BuildContext ctx, Food food, double _amount) async {
    final prefs = await SharedPreferences.getInstance();
    var url = Uri.https(HttpConfig.baseUrl, 'intake');
    return http
        .post(url,
            headers: {
              'Authorization': prefs.getString('token'),
              'userId': prefs.getString('userId'),
            },
            body: json.encode(Transaction(
                    food: food, amount: _amount, foodId: food.id, date: date)
                .toJson()))
        .then((value) {
      Provider.of<DashboardProvider>(ctx, listen: false).fetchIntake(date);
      Navigator.of(ctx).pop();
    });
  }

  Future<void> deleteFood(BuildContext ctx, Food food) async {
    final prefs = await SharedPreferences.getInstance();
    var url = Uri.https(HttpConfig.baseUrl, 'food/${food.id}');
    return http.delete(url, headers: {
      'Authorization': prefs.getString('token'),
      'userId': prefs.getString('userId'),
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
