import 'package:flutter/material.dart';
import 'UI/restaurantDetaiL.dart';
import 'UI/Accueil.dart';

import 'package:sae_mobile/UI/mytheme.dart';
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
      theme: MyTheme.dark(),
    );
  }
}