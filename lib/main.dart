import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/models/dashboard_data.dart';
import 'package:flutter_foodtracker/providers/dashboard_provider.dart';
import 'package:flutter_foodtracker/providers/intakes.dart';
import 'package:flutter_foodtracker/providers/transactions.dart';
import 'package:flutter_foodtracker/screens/create_meal.dart';
import 'package:flutter_foodtracker/screens/dashboard.dart';
import 'package:flutter_foodtracker/screens/transactions_list.dart';
import 'package:flutter_foodtracker/widgets/app_drawer.dart';
import 'package:flutter_foodtracker/widgets/intake_pie_chart.dart';
import 'package:provider/provider.dart';

import 'models/intake.dart';

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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Dashboard(),
        routes: {
          TransactionsList.routeName: (ctx) => TransactionsList(),
          Dashboard.routeName: (ctx) => Dashboard(),
          CreateMeal.routeName: (ctx) => CreateMeal(),
        },
      ),
    );
  }
}
