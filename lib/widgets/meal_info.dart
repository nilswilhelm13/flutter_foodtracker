import 'package:flutter/material.dart';

class MealInfo extends StatelessWidget {

  final double energy;
  final double fat;
  final double carbohydrate;
  final double protein;

  MealInfo({this.energy, this.fat, this.carbohydrate, this.protein});

  Widget displayValue(String label, double value) {
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(value.toStringAsFixed(1)),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            displayValue('Energy', energy),
            displayValue('Fat', fat),
            displayValue('Carbs', carbohydrate),
            displayValue('Protein', protein),
          ],
        ),
      ),
    );
  }
}
