import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/screens/create_food.dart';

class FoodNotFoundDialog extends StatelessWidget {
  final String ean;

  FoodNotFoundDialog(this.ean);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Food not found'),
      content: Text(
        'The food with ean: $ean does not exist yet. Do you want to create it?',
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(CreateFood.routeName,
                  arguments: {'isEdit': false, 'ean': ean});
            },
            child: Text('Yes')),
      ],
    );
  }
}
