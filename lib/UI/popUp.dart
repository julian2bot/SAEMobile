import 'package:flutter/material.dart';

void showPopUp(BuildContext context, String message, bool success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      duration: const Duration(seconds: 3),
      backgroundColor: success ? Colors.green : Colors.red,
    ),
  );
}
