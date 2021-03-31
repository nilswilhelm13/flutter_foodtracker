import 'package:flutter_foodtracker/models/transaction.dart';

import 'daily_goals.dart';
import 'intake.dart';

class DashboardData {
  Intake intake;
  DailyGoals dailyGoals;
  List<Transaction> transactions;

  DashboardData.fromJson(Map<String, dynamic> json) {
    intake = Intake.fromJson(json['intake']);
    dailyGoals = DailyGoals.fromJson(json['dailyGoals']);
    transactions = (json['transactions'] as List<dynamic>)
        .map((transactionJSON) =>
            Transaction.fromJson(transactionJSON as Map<String, dynamic>))
        .toList();
  }
}
