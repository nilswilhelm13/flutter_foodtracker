import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/colors.dart';
import 'package:flutter_foodtracker/models/dashboard_data.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class IntakeBarCharts extends StatelessWidget {
  final DashboardData _dashboardData;

  IntakeBarCharts(this._dashboardData);

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
    return Column(
      children: [
        buildLinearIndicator('Protein', _dashboardData.intake.nutrition.protein,
            _dashboardData.dailyGoals.nutrition.protein, FoodColors.protein),
        buildLinearIndicator(
            'Carbohydrate',
            _dashboardData.intake.nutrition.carbohydrate,
            _dashboardData.dailyGoals.nutrition.carbohydrate,
            FoodColors.carbohydrate),
        buildLinearIndicator('Fat', _dashboardData.intake.nutrition.fat,
            _dashboardData.dailyGoals.nutrition.fat, FoodColors.fat),
      ],
    );
  }
}
