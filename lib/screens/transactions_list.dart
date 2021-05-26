import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/error_handling/generic_error_handling.dart';
import 'package:flutter_foodtracker/providers/transactions.dart';
import 'package:flutter_foodtracker/widgets/app_drawer.dart';
import 'package:flutter_foodtracker/widgets/generic_error_modal.dart';
import 'package:flutter_foodtracker/widgets/transaction_item.dart';
import 'package:flutter_foodtracker/widgets/transaction_modal.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';

class TransactionsList extends StatefulWidget {
  static const routeName = '/transactions';

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  bool _isLoading = true;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    var provider = Provider.of<Transactions>(context, listen: false);
    provider.fetchTransactions().then((value) {
      setState(() {
        _isLoading = false;
        _transactions = provider.transactions;
      });
    }).catchError((error) {
      showDialog(context: context, builder: (ctx) => GenericErrorModal(error));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      drawer: AppDrawer(),
      body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (_, i) => GestureDetector(
                      onTap: () => showDialog(
                            context: context,
                            builder: (ctx) =>
                                TransactionModal(transaction: _transactions[i]),
                          ),
                      child: TransactionItem(_transactions[i])))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
