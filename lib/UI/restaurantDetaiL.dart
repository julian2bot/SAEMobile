import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modele/restaurant.dart';
import '../modele/commentaire.dart';
import "../API/api_bd.dart";

class RestaurantDetailPage extends StatelessWidget {
    final String idrestaurant;
    final Restaurant restaurant;

    const RestaurantDetailPage._internal(this.idrestaurant, this.restaurant);

    static Future<RestaurantDetailPage> create(String idRestaurant) async {
      print("Avant");
      // Appel asynchrone pour obtenir les données du restaurant
      final restaurant = await BdAPI.getRestaurantByID(idRestaurant);
      await restaurant.getLesCommentaires();
      // Retourne une instance de RestaurantDetailPage
      print("Apres");
      return RestaurantDetailPage._internal(idRestaurant, restaurant);
    }
    
    // static Future<Restaurant> getRestoByID(String id) async{
    //   return BdAPI.getRestaurantByID(id);
    // }
    //
    // RestaurantDetailPage({required this.idrestaurant}){}
    //     : restaurant = await RestaurantDetailPage.getRestoByID(idrestaurant);

    void _launchURL(String url) async {
        Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        } else {
        throw 'Impossible d\'ouvrir l\'URL : $url';
        }
    }

        
    void _launchPhoneCall(String phoneNumber) async {
        Uri uri = Uri.parse('tel:$phoneNumber');
        if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
        } else {
            throw 'Impossible d\'ouvrir le numéro : $phoneNumber';
        }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.nom),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            // Image du restaurant
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
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/Boeuf.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,

                  ),
                ),
              ),
            SizedBox(height: 16.0),

            // Nom du restaurant et étoiles (header)
            Center(
              child: Text(
                restaurant.nom,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                // [
                List.generate(5, (index) {
                  // Détermine la couleur de l'étoile en fonction de l'index
                  Color starColor = index < restaurant.nbEtoile ? Colors.amber : Colors.grey;
                  return Icon(
                    Icons.star,
                    color: starColor,
                  );
                }),

                // SizedBox(width: 4.0),
                // Text(
                //   '${restaurant.nbEtoile} étoiles',
                //   style: TextStyle(fontSize: 18),
                // ),
              // ],
            ),
            SizedBox(height: 16.0),

            // Informations du restaurant dans une carte
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // adresse
                    Text(
                      'Adresse: ${restaurant.codeCommune}, ${restaurant.nomCommune}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    SizedBox(width: double.infinity),

                    // Cuisines
                    Text(
                      'Cuisines: ${restaurant.cuisines.join(', ')}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),



                    // Téléphone
                    if (restaurant.telephone.isNotEmpty)
                        ElevatedButton.icon(
                            onPressed: () => _launchPhoneCall(restaurant.telephone),
                            icon: Icon(Icons.phone),
                            label: Text("Appeler ${restaurant.telephone}",
                            style: TextStyle(color: Colors.black)),
                        ),

                    SizedBox(height: 8.0),
                    SizedBox(width: double.infinity),

                    // Site web
                    if (restaurant.site.isNotEmpty)
                        ElevatedButton.icon(

                            onPressed: () => _launchURL(restaurant.site),
                            icon: Icon(Icons.web),
                            label: Text(
                                'Site Web: ${restaurant.site}',
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
            Text(
              'Commentaires:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            for (var commentaire in restaurant.lesCommentaires)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8.0),
                          Text(
                            commentaire.username, // Remplacez par le nom d'utilisateur réel
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            commentaire.dateCommentaire, // Remplacez par la date réelle
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        commentaire.commentaire,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}