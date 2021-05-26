import 'package:flutter/material.dart';

class MealInfo extends StatelessWidget {
  final double energy;
  final double fat;
  final double carbohydrate;
  final double protein;
  final Function customTotalHandler;
  final Function nameHandler;

  MealInfo(
      {this.energy,
      this.fat,
      this.carbohydrate,
      this.protein,
      this.customTotalHandler,
      this.nameHandler});

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
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onSubmitted: nameHandler,
                onChanged: nameHandler,
              ),
            ),
            Row(
              crossAxisAlignment:  CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Custom Total'),
                Container(
                  width: 70,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onSubmitted: customTotalHandler,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                displayValue('Energy', energy),
                displayValue('Fat', fat),
                displayValue('Carbs', carbohydrate),
                displayValue('Protein', protein),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
