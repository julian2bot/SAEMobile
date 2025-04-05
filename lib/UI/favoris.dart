import 'package:flutter/material.dart';
import '../modele/restaurant.dart';
import 'ListElem.dart';
import 'restaurantDetaiL.dart';
import '../API/api_bd.dart';
import 'package:go_router/go_router.dart';
import '../modele/utilisateur.dart';

class Favoris extends StatefulWidget {
  const Favoris({super.key});

  @override
  _FavorisState createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  late Future<List<Restaurant>> restaurantsFuture;
  List<Restaurant> _restaurants = [];
  bool isLoading = true;
  String? errorMessage;
  late User _user;
  Map<String, bool> favsAllRestoFav = {};

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
    _loadUser();
  }

  Future<void> _loadUser() async {
    var user = await User.getUser();

    setState(() {
      _user = user!;
    });
  }

  Future<void> _loadRestaurant() async {
    try {
      final User user = (await User.getUser())!;
      restaurantsFuture = user.getLesFavoris();
      restaurantsFuture.then((restaurants) {
        setState(() {
          _restaurants = restaurants;
          isLoading = false;

          Map<String, bool> favsAllRestoFav = {};
          for (var resto in restaurants) {
            favsAllRestoFav[resto.osmid] = true;
          }
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Chargement des favoris")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text("Erreur")),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vos Favoris"),
      ),
      body: FutureBuilder<List<Restaurant>>(
        // Utilisation de FutureBuilder
        future: restaurantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erreur : \${snapshot.error}"));
          }

          if (_restaurants.isEmpty) {
            return const Center(child: Text("Vous n'avez aucun favoris"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: _restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = _restaurants[index];
              return GestureDetector(
                onTap: () {
                  context.go(context.namedLocation('detail', pathParameters: {
                    'id': restaurant.osmid.replaceAll("/", "_")
                  }));
                },
                child: ListElem(
                    restaurant: restaurant,
                    image: restaurant.imageHorizontal,
                    estFavoris: true,
                    user: _user,
                    lesfavs: favsAllRestoFav, // juste pour initaliser car obligé pour l'autre page....
                ),
              );
            },
          );
        },
      ),
    );
  }
}
