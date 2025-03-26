import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../modele/commentaire.dart';
import '../modele/restaurant.dart';

import 'ajout_commentaire.dart';

import "../API/api_bd.dart";
import '../API/geolocator.dart';

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
            if (restaurant!.imageHorizontal.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: CachedNetworkImage(
                    imageUrl: restaurant!.imageHorizontal,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
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

            // titre / dist
            Stack(
              clipBehavior: Clip.none,

              children: [
                Center(
                  child: Text(
                    restaurant!.nom,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                // dist
                Positioned(
                  right: 10,
                  bottom: 60,
                  child: FutureBuilder<double>(
                    future: GeoPosition.distance(restaurant!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // chargement
                      } else if (snapshot.hasError) {
                        return Text("-- Km");
                      } else if (snapshot.hasData) {
                        double distance = snapshot.data!;
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '${distance.toStringAsFixed(1)} km',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return Text("-- Km");
                      }
                    },
                  ),
                ),
              ],
            )
            ,



            if(restaurant!.nbEtoile != 0)

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                List.generate(5, (index) {
                  // Détermine la couleur de l'étoile en fonction de l'index
                  Color starColor =
                  index < restaurant!.nbEtoile ? Colors.amber : Colors.grey;
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
                      'Adresse: ${restaurant!.codeCommune}, ${restaurant!.nomCommune}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    SizedBox(width: double.infinity),

                    if (restaurant!.cuisines.isNotEmpty)
                    // Cuisines
                      Text(
                        'Cuisines: ${restaurant!.cuisines.join(', ')}',
                        style: TextStyle(fontSize: 18),
                      ),
                    SizedBox(height: 8.0),

                    // Téléphone
                    if (restaurant!.telephone != "undefined")
                      ElevatedButton.icon(
                        onPressed: () => _launchPhoneCall(restaurant!.telephone),
                        icon: Icon(Icons.phone),
                        label: Text("Appeler ${restaurant!.telephone}",
                            style: TextStyle(color: Colors.black)),
                      ),

                    SizedBox(height: 8.0),
                    SizedBox(width: double.infinity),

                    // Site web
                    if (restaurant!.site != "undefined")
                      ElevatedButton.icon(
                        onPressed: () => _launchURL(restaurant!.site),
                        icon: Icon(Icons.web),
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
                Text(
                  'Commentaires:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    print("creer un commentaire");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddComment()),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 8.0),
            for (var commentaire in restaurant!.lesCommentaires)
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
                            commentaire
                                .username, // Remplacez par le nom d'utilisateur réel
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            commentaire
                                .dateCommentaire, // Remplacez par la date réelle
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
}