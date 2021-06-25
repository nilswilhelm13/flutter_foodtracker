import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    return [..._transactions];
  }

  Future<void> fetchTransactions(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    var url =
        Uri.https(HttpConfig.baseUrl, 'transactions', {
          'date': DateFormat('yyyy-MM-dd').format(date)
        });
    try {
      final response = await http.get(url, headers: {
        'Authorization': prefs.getString('token'),
        'userId': prefs.getString('userId'),
      },);
      if (response.statusCode / 100 != 2){
        throw Exception('fetching failed. status code: ${response.statusCode}');
      }
      var transactionsJSON = json.decode(response.body) as List<dynamic>;
      _transactions = transactionsJSON
          .map((transaction) => Transaction.fromJson(transaction as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (error) {
      throw(error);
    }
  }

  Future<void> deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    var url =
    Uri.https(HttpConfig.baseUrl, 'intake/$id');
    try {
      final response = await http.delete(url, headers: {
        'Authorization': prefs.getString('token'),
        'userId':prefs.getString('userId'),
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
