import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';
import 'dart:convert';

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2MTc3MjQyNTAsInVzZXIiOiJ0ZXN0QGV4YW1wbGUuY29tIn0.FebKTuCM1ZuDt6_iDFtceNh9aUQSL6S27V8yS7_7qzk';

  List<Transaction> get transactions {
    return [..._transactions];
  }

  Future<void> fetchTransactions() async {
    var url =
        Uri.https('backend.nilswilhelm.net', 'transactions/test@example.com}');
    try {
      final response = await http.get(url, headers: {
        'Authorization': token,
        'userId': 'test@example.com',
      });
      var transactionsJSON = json.decode(response.body) as List<dynamic>;
      _transactions = transactionsJSON
          .map((transaction) => Transaction.fromJson(transaction))
          .toList();
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> deleteTransaction(String id) async {
    var url =
    Uri.https('backend.nilswilhelm.net', 'intake/$id');
    try {
      final response = await http.delete(url, headers: {
        'Authorization': token,
        'userId': 'test@example.com',
      });
      if (response.statusCode == 200) {
        _transactions.removeWhere((element) => element.id == id);
        notifyListeners();
      }

    } catch (error) {
      print(error.toString());
    }
  }
}
