import 'package:flutter/material.dart';
import '../API/api_bd.dart';
import '../modele/utilisateur.dart';

import 'Cuisine.dart';

class CuisinesFavoris extends StatefulWidget {
  const CuisinesFavoris({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<CuisinesFavoris> {
  List<String> lesCuisines = [];
  late Future<List<String>> lesFuturesCuisines;
  late List<String> lesFavoris;
  bool cuisineInit = false;
  bool cuisinePrefInit = false;

  @override
  void initState() {
    super.initState();
    _loadCuisines();
    _loadFavoris();
  }

  void _loadCuisines() {
    lesFuturesCuisines = BdAPI.getAllCuisinesResto();
    lesFuturesCuisines.then((cuisines) {
      setState(() {
        lesCuisines = cuisines;
        cuisineInit = true;
      });
    });
  }

  void _loadFavoris() async {
    String? username = await User.getUserName();
    if (username != null) {
      List<String> fav = await BdAPI.getCuisinesPref(username);
      setState(() {
        lesFavoris = fav;
        cuisinePrefInit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!cuisineInit || !cuisinePrefInit) {
      return Scaffold(
        appBar: AppBar(title: const Text("Chargement des cuisines")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<List<String>>(
      // Utilisation de FutureBuilder
      future: lesFuturesCuisines,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Erreur FutureBuilder: ${snapshot.error}");

          return const Center(child: Text("Erreur : \${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucun restaurant disponible"));
        }
        return Scaffold(
            appBar: AppBar(title: Text("Vos cuisines")),
            body: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 🌟 Deux cartes par ligne
                crossAxisSpacing: 20.0, // 🌟 Espacement horizontal entre cartes
                mainAxisSpacing: 20.0, // 🌟 Espacement vertical entre cartes
                childAspectRatio: 2.5, // 🌟 Ratio largeur/hauteur des cartes
              ),

              itemCount: snapshot.data!.length, // Utiliser snapshot.data
              itemBuilder: (context, index) {
                String cuisineActuelle = snapshot.data![index];
                bool estFavoris = lesFavoris.contains(cuisineActuelle);

                return UneCuisine(
                  uneCuisine: cuisineActuelle,
                  estFavoris: estFavoris,
                );
              },
            ));
      },
    );
  }
}
