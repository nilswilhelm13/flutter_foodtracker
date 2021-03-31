import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/colors.dart';
import 'package:flutter_foodtracker/models/intake.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class IntakePieChart extends StatelessWidget {
  final Intake _intake;

  const IntakePieChart(this._intake);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PieChart(
          PieChartData(
            borderData: FlBorderData(show: false),
            sectionsSpace: 5,
            centerSpaceRadius: 100,
            sections: [
              PieChartSectionData(
                value: _intake.nutrition.protein,
                showTitle: false,
                radius: 80,
                color: FoodColors.protein,
                title: 'Protein',
              ),
              PieChartSectionData(
                  value: _intake.nutrition.carbohydrate,
                  showTitle: false,
                  radius: 80,
                  color: FoodColors.carbohydrate,
                  title: 'Carbs'),
              PieChartSectionData(
                  value: _intake.nutrition.fat,
                  showTitle: false,
                  radius: 80,
                  color: FoodColors.fat,
                  title: 'Fat'),
            ],
          ),
        ),
        Center(
            child: Text(
          '${_intake.nutrition.energy.toStringAsFixed(0)} kcal',
          style: TextStyle(fontSize: 40, color: FoodColors.energy),
        ))
      ],
    );
  }
}
