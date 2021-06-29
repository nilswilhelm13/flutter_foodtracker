import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/models/food.dart';
import 'package:flutter_foodtracker/screens/food_details.dart';
import 'package:flutter_foodtracker/widgets/generic_error_modal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateFood extends StatefulWidget {
  static const String routeName = '/create-food';

  @override
  _CreateFoodState createState() => _CreateFoodState();
}

class _CreateFoodState extends State<CreateFood> {
  final _form = GlobalKey<FormState>();
  Food _food;
  var _isInit = true;
  var _isEdit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _isEdit = args['isEdit'];
      if (_isEdit) {
        _food = args['food'];
      } else {
        _food = Food.emptyWithEAN(args['ean']);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget numberInputField(String label, double initValue, Function onSaved) {
    return TextFormField(
        initialValue: initValue.toString(),
        decoration: InputDecoration(labelText: label),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number.';
          }
          if (double.parse(value) < 0) {
            return 'Please enter a number greater or equal zero.';
          }
          return null;
        },
        onSaved: onSaved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Food' : 'Create Food'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _food.name,
                        decoration: InputDecoration(labelText: 'Name'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _food.name = value;
                        },
                      ),
                      TextFormField(
                        initialValue: _food.brand,
                        decoration: InputDecoration(labelText: 'Brand'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          _food.brand = value;
                        },
                      ),
                      TextFormField(
                        initialValue: _food.ean,
                        decoration: InputDecoration(labelText: 'EAN'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          _food.ean = value;
                        },
                      ),
                      numberInputField('Calories', _food.nutrition.energy,
                          (value) {
                        _food.nutrition.energy = double.parse(value);
                      }),
                      numberInputField('Fat', _food.nutrition.fat, (value) {
                        _food.nutrition.fat = double.parse(value);
                      }),
                      numberInputField(
                          'Carbohydrate', _food.nutrition.carbohydrate, (value) {
                        _food.nutrition.carbohydrate = double.parse(value);
                      }),
                      numberInputField('Protein', _food.nutrition.protein,
                          (value) {
                        _food.nutrition.protein = double.parse(value);
                      }),
                      TextButton(
                          onPressed: _isEdit ? editFood : postFood,
                          child: Text('Submit'))
                    ],
                  ),
                ),
              ),
          ),
    );
  }

  postFood() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    var url = Uri.https(HttpConfig.baseUrl, 'food');
    _isLoading = true;
    print(_food.nutrition.protein);
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(url,
          headers: {
            'Authorization': prefs.getString('token'),
            'userId': prefs.getString('userId'),
          },
          body: json.encode(_food.toJson()));
      _isLoading = false;
      if (response.statusCode ~/ 100 != 2) {
        showDialog(context: context,
            builder: (ctx) =>
                GenericErrorModal(Exception(
                    "status code:" + response.statusCode.toString())));
      }
      var createdFood = json.decode(response.body) as Map<String, dynamic>;
      Navigator.pushReplacementNamed(context, FoodDetails.routeName,
          arguments: Food.fromJson(createdFood));
    }
    catch (error) {

    }
  }

  editFood() async {
    if (!_form.currentState.validate()) {
      return;
    }
    print(_food.id);
    _form.currentState.save();
    var url = Uri.https(HttpConfig.baseUrl, 'food/${_food.id}');
    _isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.put(url,
          headers: {
            'Authorization':prefs.getString('token'),
            'userId': prefs.getString('userId'),
          },
          body: json.encode({
            "ean": _food.ean,
            "name": _food.name,
            "nutrition": {
              "energy": _food.nutrition.energy,
              "fat": _food.nutrition.fat,
              "carbohydrate": _food.nutrition.carbohydrate,
              "protein": _food.nutrition.protein,
              "salt": _food.nutrition.salt
            },
            "brand": _food.brand,
          }));
      _isLoading = false;
      if (response.statusCode ~/ 100 != 2) {
        showDialog(context: context, builder: (ctx) => GenericErrorModal(Exception(
            "status code:" + response.statusCode.toString())));
      }
      var editedFood = json.decode(response.body) as Map<String, dynamic>;
      Navigator.pushReplacementNamed(context, FoodDetails.routeName, arguments: Food.fromJson(editedFood));
    } catch (error) {

    }
  }
}
