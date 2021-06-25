import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/colors.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/config/scale.dart';
import 'package:flutter_foodtracker/models/intake.dart';
import 'package:flutter_foodtracker/widgets/app_drawer.dart';
import 'package:flutter_foodtracker/widgets/generic_error_modal.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  static const String routeName = '/history';
  @override
  State<StatefulWidget> createState() => HistoryState();
}

class HistoryState extends State<History> {
  bool isShowingMainData;
  bool _isLoading = true;
  List<FlSpot> _proteinData = [];
  List<FlSpot> _carbsData = [];
  List<FlSpot> _fatData = [];
  double maxY = 0;
  double minX = double.infinity;
  double maxX = 0;
  static const double oneDayInMilliseconds = 86400000;

  @override
  void initState() {
    fetchHistory();
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last Week'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AspectRatio(
              aspectRatio: 1.23,
              child: Container(
                decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.all(Radius.circular(18)),
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color(0xff2c274c),
                    //     Color(0xff46426c),
                    //   ],
                    //   begin: Alignment.bottomCenter,
                    //   end: Alignment.topCenter,
                    // ),
                    ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 37,
                        ),
                        const Text(
                          'Last Week',
                          style: TextStyle(
                            color: Color(0xff827daa),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'Last 7 Days',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 37,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, left: 6.0),
                            child: LineChart(
                              sampleData1(),
                              swapAnimationDuration:
                                  const Duration(milliseconds: 250),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white
                            .withOpacity(isShowingMainData ? 1.0 : 0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          isShowingMainData = !isShowingMainData;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
        showTitles: true,
        getTitles: (value) {
          print(value);
          var date = DateFormat('E')
              .format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
          return date;
        },
        interval: oneDayInMilliseconds);
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      horizontalInterval: 500,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Color(0x70CBBCBC),
          strokeWidth: 1,
          dashArray: [1]
        );
      },
      // checkToShowHorizontalLine: (value) {
      //   return (value - minY) % _leftTitlesInterval == 0;
      // },
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.grey.withOpacity(0.8),
          getTooltipItems: (items) {
            return items.map((item){
              return LineTooltipItem(item.y.toStringAsFixed(0), TextStyle(color: item.bar.colors[0]));
            }).toList();
          }
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: _gridData(),
      titlesData: FlTitlesData(
        bottomTitles: _bottomTitles(),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            return value.toInt().toString();
          },
          margin: 8,
          reservedSize: 30,
          interval: 500,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: minX,
      maxX: maxX,
      maxY: min(maxY, 3000),
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  LineChartBarData buildData(Color color, List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [
        color,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
        colors: [color.withOpacity(.1)]
      ),
    );
  }

  List<LineChartBarData> linesBarData1() {
    return [
      buildData(FoodColors.protein, _proteinData),
      buildData(FoodColors.carbohydrate, _carbsData),
      buildData(FoodColors.fat, _fatData),
    ];
  }

  fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    var url = Uri.https(HttpConfig.baseUrl, 'history');
    _isLoading = true;
    try {
      final response = await http.get(url, headers: {
        'Authorization': prefs.getString('token'),
        'userId': prefs.getString('userId'),
      });
      if (response.statusCode != 200) {
        throw Exception('could not fetch history');
      }
      List<dynamic> responseJSON = json.decode(response.body);
      List<Intake> intakeList = responseJSON
          .map((intakeJSON) =>
              Intake.fromJson(intakeJSON as Map<String, dynamic>))
          .toList();
      print(response.body);
      setState(() {
        intakeList.asMap().forEach((index, intake) {
          var protein = (intake.nutrition.protein * Scale.caloriesPerGramProtein).round().toDouble();
          var carbs = (intake.nutrition.carbohydrate * Scale.caloriesPerGramCarbohydrate).round().toDouble();
          var fat = (intake.nutrition.fat * Scale.caloriesPerGramFat).round().toDouble();
          var dateInMilliseconds =
              intake.date.millisecondsSinceEpoch.toDouble();
          maxY = max(maxY, protein);
          maxY = max(maxY, carbs);
          maxY = max(maxY, fat);
          minX = min(minX, dateInMilliseconds);
          maxX = max(maxX, dateInMilliseconds);
          _proteinData.add(FlSpot(dateInMilliseconds, protein));
          _carbsData
              .add(FlSpot(dateInMilliseconds, carbs));
          _fatData.add(FlSpot(dateInMilliseconds, fat));
        });
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      showDialog(context: context, builder: (ctx) => GenericErrorModal(error));
    }
  }

  dateToInt() {}
}
