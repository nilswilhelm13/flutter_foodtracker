import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/providers/dashboard_provider.dart';
import 'package:flutter_foodtracker/providers/food_provider.dart';
import 'package:flutter_foodtracker/providers/intakes.dart';
import 'package:flutter_foodtracker/providers/transactions.dart';
import 'package:flutter_foodtracker/screens/barcode_scanner.dart';
import 'package:flutter_foodtracker/screens/create_food.dart';
import 'package:flutter_foodtracker/screens/create_meal.dart';
import 'package:flutter_foodtracker/screens/dashboard.dart';
import 'package:flutter_foodtracker/screens/food_details.dart';
import 'package:flutter_foodtracker/screens/history.dart';
import 'package:flutter_foodtracker/screens/login_screen.dart';
import 'package:flutter_foodtracker/screens/transactions_list.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Transactions()),
        ChangeNotifierProvider.value(value: Intakes()),
        ChangeNotifierProvider.value(value: DashboardProvider()),
        ChangeNotifierProvider.value(value: FoodProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Dashboard(),
        routes: {
          TransactionsList.routeName: (ctx) => TransactionsList(),
          Dashboard.routeName: (ctx) => Dashboard(),
          CreateMeal.routeName: (ctx) => CreateMeal(),
          FoodDetails.routeName: (ctx) => FoodDetails(),
          BarCodeScanner.routeName: (ctx) => BarCodeScanner(),
          CreateFood.routeName: (ctx) => CreateFood(),
          History.routeName: (ctx) => History(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
        },
      ),
    );
  }
}
