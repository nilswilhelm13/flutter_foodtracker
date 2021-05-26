import 'package:flutter/material.dart';

class GenericErrorModal extends StatelessWidget {
  final Exception exception;

  GenericErrorModal(this.exception);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Something went wrong'),
      content: Text(exception.toString()),
    );
    ;
  }
}
