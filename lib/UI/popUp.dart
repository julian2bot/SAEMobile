import 'package:flutter/material.dart';

void showPopUp(BuildContext context, String message, bool success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      duration: Duration(seconds: 3),
      backgroundColor: success ? Colors.green : Colors.red,
    ),
  );
}
