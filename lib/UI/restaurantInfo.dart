import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../modele/restaurant.dart';

class Restaurantinfo extends StatelessWidget {
  final Restaurant restaurant;

  const Restaurantinfo({
    super.key,
    required this.restaurant,
  });

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
    return Card(
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
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8.0),
                    const SizedBox(width: double.infinity),

                    if (restaurant.cuisines.isNotEmpty)
                    // Cuisines
                      Text(
                        'Cuisines: ${restaurant.cuisines.join(', ')}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    const SizedBox(height: 8.0),

                    // Téléphone
                    if (restaurant.telephone != "undefined")
                      ElevatedButton.icon(
                        onPressed: () => _launchPhoneCall(restaurant.telephone),
                        icon: const Icon(Icons.phone, color: Colors.black,),
                        label: Text("Appeler ${restaurant.telephone}",
                            style: const TextStyle(color: Colors.black),),
                      ),

                    const SizedBox(height: 8.0),
                    const SizedBox(width: double.infinity),

                    // Site web
                    if (restaurant.site != "undefined")
                      ElevatedButton.icon(
                        onPressed: () => _launchURL(restaurant.site),
                        icon: const Icon(Icons.web, color: Colors.black,),
                        label: Text(
                          'Site Web: ${restaurant.site}',
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            );
  }
}