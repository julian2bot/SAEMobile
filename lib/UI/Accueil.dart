import 'package:flutter/material.dart';
import '../modele/restaurant.dart';
import 'ListElem.dart';
import 'restaurantDetaiL.dart';
import '../API/api_bd.dart';
import 'package:go_router/go_router.dart';

class Accueil extends StatefulWidget {
  Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  late Future<List<Restaurant>> restaurantsFuture;
  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    restaurantsFuture = BdAPI.getResto();
    restaurantsFuture.then((restaurants) {
      setState(() {
        _restaurants = restaurants;
        _filteredRestaurants = restaurants;
      });
    });
  }

  void _filterRestaurants(String query) {
    setState(() {
      _filteredRestaurants = _restaurants
          .where((restaurant) => restaurant.nom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IUTABLES'O"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un restaurant...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              onChanged: _filterRestaurants,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Restaurant>>( // Utilisation de FutureBuilder
        future: restaurantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : \${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun restaurant disponible"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: _filteredRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = _filteredRestaurants[index];
              return GestureDetector(
                onTap: () {
                  context.go(context.namedLocation('detail', pathParameters: {'id' : restaurant.osmid.replaceAll("/", "_")}));
                },
                child: ListElem(
                  restaurant: restaurant,
                  image: restaurant.imageHorizontal,
                  estFavoris: false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
