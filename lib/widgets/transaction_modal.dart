import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/models/transaction.dart';

class TransactionModal extends StatelessWidget {
  const TransactionModal({
    Key key,
    @required Transaction transaction,
  })  : _transaction = transaction,
        super(key: key);

  final Transaction _transaction;

  buildRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key),
        Text(value),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(_transaction.food.name),
      children: [
        Container(
          padding: EdgeInsets.all(25),
          child: Column(children: [
            buildRow(
                'Energy', '${_transaction.nutrition.energy.toStringAsFixed(2)}kcal'),
            buildRow('Fat', '${_transaction.nutrition.fat.toStringAsFixed(2)}g'),
            buildRow('Carbohydrate',
                '${_transaction.nutrition.carbohydrate.toStringAsFixed(2)}g'),
            buildRow(
                'Protein', '${_transaction.nutrition.protein.toStringAsFixed(2)}g'),
          ]),
        )
      ],
    );
  }
}
