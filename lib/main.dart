import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'UI/restaurantDetaiL.dart';
import 'router/router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,
    );
  }
}