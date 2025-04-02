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
import 'ViewAllPicture.dart';

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
        appBar: AppBar(title: const Text("Chargement du restaurant")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Erreur")),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant!.nom),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du restaurant

            RestaurantHeader(restaurant: restaurant!),
            const SizedBox(height: 16.0),
              

              // Informations du restaurant dans une carte
              Restaurantinfo(restaurant: restaurant!),
              const SizedBox(height: 16.0),


              // Séparateur pour commentaires
              const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 16.0),



            // Commentaires
            Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Commentaires:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    IconButton(
                      icon: const Icon(Icons.collections),
                      onPressed: () {
                        print("creer un commentaire");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              GaleriePhotos(restaurantId: restaurant?.osmid ?? ""),
                          ),
                      );
                    }),
                    IconButton(
                      icon: const Icon(Icons.add_comment_outlined),
                      onPressed: () {
                        print("creer un commentaire");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddComment(restaurantId: restaurant?.osmid ?? ""),
                          ),
                        ).then((result) {
                          if (result != null) {
                            restaurant!.getLesCommentaires()
                                .then((_) {
                              setState(() {
                                _loadRestaurant();
                              });
                            });
                          }
                        }
                        );
                      })
                    ]),
                  ],
                ),
                const SizedBox(height: 8.0),

              if (restaurant!.noteMoyen != 0)
                Row(children: [
                  const Text("NOTE MOYENNE: ",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), 
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        Color starColor =
                            index < restaurant!.noteMoyen ? Colors.amber : Colors.grey;
                        return Icon(Icons.star, color: starColor);
                      }),
                    ),

                  const SizedBox(height: 16.0),
                ]
              ),      
            ],),
            

            
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