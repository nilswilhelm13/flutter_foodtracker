import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/providers/dashboard_provider.dart';
import 'package:flutter_foodtracker/screens/food_details.dart';
import 'package:flutter_foodtracker/search/food_search.dart';
import 'package:flutter_foodtracker/widgets/app_drawer.dart';
import 'package:flutter_foodtracker/widgets/generic_error_modal.dart';
import 'package:flutter_foodtracker/widgets/intake_bar_charts.dart';
import 'package:flutter_foodtracker/widgets/intake_pie_chart.dart';
import 'package:flutter_foodtracker/widgets/scan_button.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  final String title = 'Dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = true;
  String barcode = '';

  void fetchIntake(BuildContext context) {
    var provider = Provider.of<DashboardProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    provider.fetchIntake().then((value) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      showDialog(context: context, builder: (ctx) => GenericErrorModal(error));
    });
  }

  @override
  void initState() {
    fetchIntake(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var dashboardData = Provider.of<DashboardProvider>(context).dashboardData;
    if (dashboardData == null) {
      fetchIntake(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: FoodSearch())
                    .then((value) {
                  if (value == null) {
                    return;
                  }
                  Navigator.of(context).pushNamed(
                    FoodDetails.routeName,
                    arguments: value,
                  );
                });
              }),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (!dashboardData.intake.nutrition.isEmpty())
              ? Column(children: [
                  Container(
                      height: height * 0.6,
                      child: IntakePieChart(dashboardData.intake)),
                  Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width * .7,
                    child: IntakeBarCharts(dashboardData)
                  )
                ])
              : Center(child: Text('There is nothing!')),
      drawer: AppDrawer(),
      floatingActionButton: ScanButton(),
    );
  }
}
