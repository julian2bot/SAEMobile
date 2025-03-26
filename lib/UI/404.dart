import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Page404 extends StatelessWidget {
  final String? errorMessage;

  const Page404({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text("Erreur : " + (this.errorMessage ?? "404 Page introuvable")),
              ElevatedButton(
                onPressed: () {
                  context.go(context.namedLocation('home'));
                },
                child: const Text("Retour à l'accueil"),
              ),
            ],
          ),
        )
    );
  }
}