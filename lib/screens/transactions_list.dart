import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  DateTime date = DateTime.now();
  @override
  void initState() {
    fetchTransactions();
    super.initState();
  }

  void fetchTransactions(){
    var provider = Provider.of<Transactions>(context, listen: false);
    provider.fetchTransactions(date).then((value) {
      setState(() {
        _isLoading = false;
        _transactions = provider.transactions;
      });
    }).catchError((error) {
      showDialog(context: context, builder: (ctx) => GenericErrorModal(error));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(onPressed: (){
            showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030)).then((value) {
              date = value;
              fetchTransactions();
            });
          }, icon: Icon(Icons.calendar_today))
        ],
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
