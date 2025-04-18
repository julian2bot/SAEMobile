import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import "package:geolocator/geolocator.dart";

import '../modele/restaurant.dart';
import "../API/geolocator.dart";

class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantHeader({
    super.key,
    required this.restaurant,
  });

  String lienItineraire(double lat, double lon) {
    // todo : ajouter sur un ontap sur la distance (mais ca marche pas jsp pourquoi...)
    return "https://www.google.com/maps/dir/?api=1&destination=$lat,$lon";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (restaurant.imageHorizontal.isNotEmpty)
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: CachedNetworkImage(
                imageUrl: restaurant.imageHorizontal,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                // errorWidget: (context, url, error) => Image.asset(
                //   'assets/images/Boeuf.png',
                //   height: 200,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),


                // TODO : SINON DECOMMENTER "errorWidget" AU DESSUS
                errorWidget: (context, url, error) {
                  return FutureBuilder<Image?>(
                    future: restaurant.getPhotoCommentaire(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), 
                          child: SizedBox(
                            width: double.infinity,
                            height: 200, 
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.hardEdge,
                              child: snapshot.data!,
                            ),
                          ),
                        );
                      } else {
                        return Image.asset(
                          'assets/images/Boeuf.png',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  );
                },

                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        const SizedBox(height: 16.0),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Text(
                restaurant.nom,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 60,
              child: GestureDetector(
                onTap: () {
                  print(lienItineraire(
                      restaurant.latitude, restaurant.longitude));
                  // Ajoute ici une action, comme ouvrir une carte
                },
                child: FutureBuilder<double>(
                  future: GeoPosition.distance(restaurant),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // chargement
                    } else if (snapshot.hasError) {
                      return const Text("-- Km");
                    } else if (snapshot.hasData) {
                      double distance = snapshot.data!;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          '${distance.toStringAsFixed(1)} km',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      );
                    } else {
                      return const Text("-- Km");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        if (restaurant.nbEtoile != 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              Color starColor =
                  index < restaurant.nbEtoile ? Colors.amber : Colors.grey;
              return Icon(Icons.star, color: starColor);
            }),
          ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
