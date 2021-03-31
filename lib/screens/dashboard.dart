import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/colors.dart';
import 'package:flutter_foodtracker/models/daily_goals.dart';
import 'package:flutter_foodtracker/models/intake.dart';
import 'package:flutter_foodtracker/providers/dashboard_provider.dart';
import 'package:flutter_foodtracker/widgets/app_drawer.dart';
import 'package:flutter_foodtracker/widgets/intake_pie_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  String title = 'Dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = true;
  Intake _intake;
  DailyGoals _dailyGoals;

  @override
  void initState() {
    var provider = Provider.of<DashboardProvider>(context, listen: false);
    provider.fetchIntake().then((value) {
      setState(() {
        _intake = provider.dashboardData.intake;
        _dailyGoals = provider.dashboardData.dailyGoals;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget buildIndicator(String label, double value, double goal, Color color) {
    return Column(
      children: [
        Text(label),
        CircularPercentIndicator(
          center:
              Text('${value.toStringAsFixed(0)}/${goal.toStringAsFixed(0)}'),
          radius: 70,
          percent: 0.7,
          progressColor: color,
          footer: Text(label),
        ),
      ],
    );
  }

  Widget buildLinearIndicator(
      String label, double value, double goal, Color color) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            center: Text(
              '${value.toStringAsFixed(0)}/${goal.toStringAsFixed(0)}',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            percent: min(value / goal, 1),
            progressColor: color,
            lineHeight: 15,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              Container(height: height * 0.6, child: IntakePieChart(_intake)),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width * .7,
                child: Column(
                  children: [
                    buildLinearIndicator('Protein', _intake.nutrition.protein,
                        _dailyGoals.nutrition.protein, FoodColors.protein),
                    buildLinearIndicator(
                        'Carbohydrate',
                        _intake.nutrition.carbohydrate,
                        _dailyGoals.nutrition.carbohydrate,
                        FoodColors.carbohydrate),
                    buildLinearIndicator('Fat', _intake.nutrition.fat,
                        _dailyGoals.nutrition.fat, FoodColors.fat),
                  ],
                ),
              )
            ]),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Increment',
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
