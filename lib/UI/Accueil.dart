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
  late User _user;
  Map<String, bool> _favorisListe = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Restaurant> restaurants = await BdAPI.getResto();
    var user = await User.getUser();
    List<Restaurant> recommandations =
        await user?.getMesRecommendations() ?? [];

    Map<String, bool> favsAllResto = {};
    for (var resto in restaurants) {
      favsAllResto[resto.osmid] = await user!.estFavoris(resto.osmid);
    }
    print(recommandations);
    setState(() {
      _user = user!;

      _restaurants = restaurants;
      _filteredRestaurants = restaurants;
      _recommandations = recommandations;
      _favorisListe = favsAllResto;
    });
  }

  void _filterRestaurants(String query) async {
    setState(() {
      _filteredRestaurants = _restaurants
          .where((restaurant) =>
              restaurant.nom.toLowerCase().contains(query.toLowerCase()))
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
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
                    itemCount: _filteredRestaurants.length > 5
                        ? 5
                        : _filteredRestaurants.length,

                    itemBuilder: (context, index) {
                      final restaurant = _filteredRestaurants[index];
                      final estFav = _favorisListe[restaurant.osmid] ?? false;

                      return GestureDetector(
                        onTap: () {
                          context.go(context.namedLocation('detail',
                              pathParameters: {
                                'id': restaurant.osmid.replaceAll("/", "_")
                              }));
                        },
                        child: ListElem(
                          restaurant: restaurant,
                          image: restaurant.imageHorizontal,
                          estFavoris: estFav,
                          user: _user,
                          lesfavs:_favorisListe, // pour pouvoir les edits dans un resto et edit aussi la Map ici (pas la meilleur facon de faire maiiss...)
                        ),
                      );
                    },
                  ),
                  const Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(thickness: 1, color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Recommandé",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Divider(thickness: 1, color: Colors.grey)),
                    ],
                  ),
                  // Ajout du bouton ici
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.go(context.namedLocation('cuisinefavorites'));
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
                    itemCount: _recommandations.length > 3
                        ? 3
                        : _recommandations.length,
                    itemBuilder: (context, index) {
                      final restaurant = _recommandations[index];
                      final estFav = _favorisListe[restaurant.osmid] ?? false;
                      return GestureDetector(
                        onTap: () {
                          context.go(context.namedLocation('detail',
                              pathParameters: {
                                'id': restaurant.osmid.replaceAll("/", "_")
                              }));
                        },
                        child: RecoElem(
                          restaurant: restaurant,
                          image: restaurant.imageHorizontal,
                          estFavoris: estFav,
                          user: _user,
                          lesfavs: _favorisListe,
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
