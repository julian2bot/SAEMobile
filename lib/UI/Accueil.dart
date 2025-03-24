import 'package:flutter/material.dart';
import '../modele/restaurant.dart';
import 'ListElem.dart';
import 'restaurantDetaiL.dart';

class Accueil extends StatelessWidget {
  final List<Restaurant> restaurants = [
    Restaurant.newRestaurant(
      "123456",
      "Le Gourmet Parisien",
      5,
      "75001",
      "Paris",
      ["Française", "Européenne", "Végétarienne"],
      telephone: "+33 1 23 45 67 89",
      site: "https://legourmetparisien.fr",
      imageVertical: "https://example.com/image1_vertical.jpg",
      imageHorizontal: "https://example.com/image1_horizontal.jpg",
      noteMoyen: 4,
      lesCommentaires: [],
    ),
    Restaurant.newRestaurant(
      "789012",
      "Sushi World",
      4,
      "75002",
      "Paris",
      ["Japonais", "Sushi", "Végétalien"],
      telephone: "+33 1 98 76 54 32",
      site: "https://sushiworld.fr",
      imageVertical: "https://example.com/image2_vertical.jpg",
      imageHorizontal: "https://example.com/image2_horizontal.jpg",
      noteMoyen: 4,
      lesCommentaires: [],
    ),
  ];

  Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IUTABLES'O"),
        actions: [
          SearchAnchor(
            builder: (context, controller) {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  controller.openView();
                },
              );
            },
            suggestionsBuilder: (context, controller) {
              String query = controller.text.toLowerCase();
              List<Restaurant> filteredRestaurants = restaurants
                  .where((r) => r.nom.toLowerCase().contains(query))
                  .toList();

              return filteredRestaurants.map((r) {
                return ListTile(
                  title: Text(r.nom),
                  subtitle: Text(r.nomCommune),
                  onTap: () {
                    //restaurantDetail(r.osmid);   TODO
                    controller.closeView(r.nom);
                  },
                );
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => 
              //   ),
              // );
            },
            child: ListElem(
              image: restaurant.imageHorizontal,
              nom: restaurant.nom,
              noteMoy: restaurant.noteMoyen,
              cuisine: restaurant.cuisines.join(", "),
              codeCommune: restaurant.codeCommune,
              nomCommune: restaurant.nomCommune,
            ),
          );
        },
      ),
    );
  }
}
