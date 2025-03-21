import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'UI/restaurantDetaiL.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: await RestaurantDetailPage.create("node/9136326362"),
  ));
}
