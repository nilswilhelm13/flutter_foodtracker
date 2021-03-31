import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/screens/create_meal.dart';
import 'package:flutter_foodtracker/screens/dashboard.dart';
import 'package:flutter_foodtracker/screens/transactions_list.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Transactions'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TransactionsList.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.pie_chart),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(Dashboard.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.set_meal),
            title: Text('Create Meal'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(CreateMeal.routeName);
            },
          ),
        ],
      ),
    );
  }
}
