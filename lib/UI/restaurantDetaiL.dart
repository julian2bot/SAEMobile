import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import "../API/api_bd.dart";
import '../API/geolocator.dart';

import '../modele/commentaire.dart';
import '../modele/restaurant.dart';

import 'ajout_commentaire.dart';
import 'commentaire.dart';
import 'restaurantInfo.dart';
import 'restaurantHeader.dart';

class RestaurantDetailPage extends StatefulWidget {
  late String? idRestaurant;

  RestaurantDetailPage({Key? key, required this.idRestaurant}) : super(key: key) {
    if(this.idRestaurant!=null)
      this.idRestaurant = this.idRestaurant!.replaceAll("_", "/");
    print("ID du restaurant: $idRestaurant");
  }

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  Restaurant? restaurant;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  Future<void> _loadRestaurant() async {
    try {
      if(widget.idRestaurant != null){
        final resto = await BdAPI.getRestaurantByID(widget.idRestaurant!);
        if (resto == null) {
          context.go(context.namedLocation('404message', pathParameters: {'errorMessage' : "Restaurant introuvable"}));
        }
        await resto!.getLesCommentaires();

        setState(() {
          restaurant = resto;
          isLoading = false;
        });
      }
      else{
        setState(() {
          errorMessage = "Erreur: pas d'identifiant";
          isLoading = false;
        });
      }
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
        appBar: AppBar(title: Text("Chargement du restaurant")),
        body: Center(child: CircularProgressIndicator()),
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
        title: Text(restaurant!.nom),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du restaurant

            RestaurantHeader(restaurant: restaurant!),
            SizedBox(height: 16.0),
            

            // Informations du restaurant dans une carte
            Restaurantinfo(restaurant: restaurant!),
            SizedBox(height: 16.0),



                    // Site web
                    if (restaurant!.site != "undefined")
                      ElevatedButton.icon(
                        onPressed: () => _launchURL(restaurant!.site),
                        icon: Icon(Icons.web,color: Colors.black),
                        label: Text(
                          'Site Web: ${restaurant!.site}',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Séparateur pour commentaires
            Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: 16.0),



            // Commentaires
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Commentaires:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_comment_outlined),
                  onPressed: () {
                    print("creer un commentaire");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddComment(restaurantId: restaurant?.osmid??""),
                        ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            

            
            // debut boucle for
            for (var commentaire in restaurant?.lesCommentaires ?? [])
              CommentaireDetail(commentaire: commentaire),
              // fin boucle for


          ],
        ),
      ),
    );
  }


}