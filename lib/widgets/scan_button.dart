import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/error_handling/food_not_found_exception.dart';
import 'package:flutter_foodtracker/providers/food_provider.dart';
import 'package:flutter_foodtracker/screens/food_details.dart';
import 'package:provider/provider.dart';

import '../barcode.dart';
import 'food_not_found_dialog.dart';

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Barcode.scanBarcode().then((value) {
        Provider.of<FoodProvider>(context, listen: false)
            .getFoodByEan(value)
            .then((value) {
          print(value);
          Navigator.pushNamed(context, FoodDetails.routeName,
              arguments: value);
        }).catchError((error) {
          if (error is FoodNotFoundException) {
            showDialog(
                context: context,
                builder: (ctx) => FoodNotFoundDialog(error.ean)
            );
          }
        });
      }),
      tooltip: 'Increment',
      child: Icon(Icons.qr_code_scanner),
    );
  }
}
