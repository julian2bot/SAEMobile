import 'package:flutter/material.dart';

class Accueil extends StatelessWidget {
  final List<String> restaurants = ["Restaurant 1", "Restaurant 2", "Restaurant 3"];

  Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(   // Correction ici
        title: Text("IUTABLES'O"),
      ),
      body: Center(
        child: Text("Accueil"),  // Correction ici
      ),
    );
  }
}
