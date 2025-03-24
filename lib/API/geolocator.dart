import 'package:geolocator/geolocator.dart';
import 'dart:math';

import '../modele/restaurant.dart';

class GeoPosition {
  // Fonction pour déterminer la position actuelle
  static Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Les services de localisation sont désactivés.");
      return null;
    }

    // Vérifie les permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("L'utilisa    teur a refusé la permission de localisation.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("L'utilisateur a refusé la permission de localisation définitivement.");
      return null;
    }

    // Obtenir la position actuelle
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Fonction publique pour récupérer la position
  static Future<Position?> getLocation() async {
    return await _determinePosition();
  }



  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371.0; // Rayon de la Terre (km)

    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double dist =  R * c; // dist (km)
    return double.parse(dist.toStringAsFixed(1));
  }

  static Future<double> distance(Restaurant resto) async {
    Position? position = await GeoPosition.getLocation();
    if(position!= null){
      print("${resto.longitude} ${resto.latitude} ${position.longitude} ${position.latitude}");

      return calculateDistance(resto.latitude, resto.longitude, position.latitude, position.longitude);

    }
    return 0.0;
  }

}
