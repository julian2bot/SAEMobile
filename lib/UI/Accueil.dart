import 'package:flutter/material.dart';
import '../modele/restaurant.dart';
import 'ListElem.dart';
import 'RecoElem.dart';
import '../API/api_bd.dart';
import '../modele/utilisateur.dart';
import 'package:go_router/go_router.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  late Future<List<Restaurant>> restaurantsFuture;
  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  List<Restaurant> _recommandations = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Restaurant> restaurants = await BdAPI.getResto();
    var user = await User.getUser();
    List<Restaurant> recommandations = await user?.getMesRecommendations() ?? [];

    setState(() {
      _restaurants = restaurants;
      _filteredRestaurants = restaurants;
      _recommandations = recommandations;
    });
  }

  void _filterRestaurants(String query) {
    setState(() {
      _filteredRestaurants = _restaurants
          .where((restaurant) => restaurant.nom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  int limiteurList() {
    return _filteredRestaurants.length > 5 ? 5 : _filteredRestaurants.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IUTABLES'O"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un restaurant...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              onChanged: _filterRestaurants,
            ),
          ),
        ),
      ),
      body: _restaurants.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              itemCount: _filteredRestaurants.length > 5 ? 5 : _filteredRestaurants.length,
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
            ),
            const Row(
              children: <Widget>[
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Recommandé",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              ],
            ),
            // Ajout du bouton ici
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  context.go(context.namedLocation('favorites'));
                },
                child: Text('Gérer les cuisines favorites'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              itemCount: _recommandations.length > 3 ? 3 : _recommandations.length,
              itemBuilder: (context, index) {
                final restaurant = _recommandations[index];
                return GestureDetector(
                  onTap: () {
                    context.go(context.namedLocation('detail', pathParameters: {'id' : restaurant.osmid.replaceAll("/", "_")}));
                  },
                  child: RecoElem(
                    restaurant: restaurant,
                    image: restaurant.imageHorizontal,
                    estFavoris: false,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
