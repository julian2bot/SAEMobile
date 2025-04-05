// restaurant_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../lib/modele/restaurant.dart';
import '../lib/modele/commentaire.dart';

void main() {
  group('Restaurant Tests', () {
    test('fromJson creates valid Restaurant object', () {
      final json = {
        "osmid": "1234",
        "nomrestaurant": "Le Bon Resto",
        "etoiles": 3,
        "codecommune": "75000",
        "nomcommune": "Paris",
        "cuisines": ["Française", "Italienne"],
        "telephone": "0123456789",
        "siteinternet": "https://lebonresto.fr",
        "vertical": "vertical.jpg",
        "horizontal": "horizontal.jpg",
        "noteMoyen": 4,
        "lesCommentaires": [Commentaire(resto: "999", username: "usertestflutter", nbEtoile: 3, dateCommentaire: "2023-23-02", commentaire: "c'est un commentaire")],
        "type": "Restaurant",
        "latitude": "48.8566",
        "longitude": "2.3522"
      };

      final resto = Restaurant.fromJson(json);

      expect(resto.osmid, "1234");
      expect(resto.nom, "Le Bon Resto");
      expect(resto.nbEtoile, 3);
      expect(resto.codeCommune, "75000");
      expect(resto.nomCommune, "Paris");
      expect(resto.cuisines, ["Française", "Italienne"]);
      expect(resto.telephone, "0123456789");
      expect(resto.site, "https://lebonresto.fr");
      expect(resto.imageVertical, "vertical.jpg");
      expect(resto.imageHorizontal, "horizontal.jpg");
      expect(resto.noteMoyen, 4);
      expect(resto.type, "Restaurant");
      expect(resto.latitude, closeTo(48.8566, 0.0001));
      expect(resto.longitude, closeTo(2.3522, 0.0001));
    });

    test('newRestaurant creates object with correct values', () {
      final resto = Restaurant.newRestaurant(
        "999",
        "Chez Lulu",
        2,
        "69000",
        "Lyon",
        ["Française"],
        telephone: "0123456789",
        site: "chezlulu.fr",
        imageVertical: "v.jpg",
        imageHorizontal: "h.jpg",
        noteMoyen: 3,
        lesCommentaires: [Commentaire(resto: "999", username: "usertestflutter", nbEtoile: 3, dateCommentaire: "2023-23-02", commentaire: "c'est un commentaire")],
        latitude: 45.75,
        longitude: 4.85,
      );

      expect(resto.osmid, "999");
      expect(resto.nom, "Chez Lulu");
      expect(resto.nbEtoile, 2);
      expect(resto.codeCommune, "69000");
      expect(resto.nomCommune, "Lyon");
      expect(resto.cuisines, ["Française"]);
      expect(resto.telephone, "0123456789");
      expect(resto.site, "chezlulu.fr");
      expect(resto.imageVertical, "v.jpg");
      expect(resto.imageHorizontal, "h.jpg");
      expect(resto.noteMoyen, 3);
      expect(resto.lesCommentaires, isNotEmpty);
      expect(resto.latitude, 45.75);
      expect(resto.longitude, 4.85);
    });


    test('newRestaurant creates object with correct values and empty commentaire', () {
      final resto = Restaurant.newRestaurant(
        "999",
        "Chez Lulu",
        2,
        "69000",
        "Lyon",
        ["Française"],
        telephone: "0123456789",
        site: "chezlulu.fr",
        imageVertical: "v.jpg",
        imageHorizontal: "h.jpg",
        noteMoyen: 3,
        lesCommentaires: [],
        latitude: 45.75,
        longitude: 4.85,
      );

      expect(resto.osmid, "999");
      expect(resto.nom, "Chez Lulu");
      expect(resto.nbEtoile, 2);
      expect(resto.codeCommune, "69000");
      expect(resto.nomCommune, "Lyon");
      expect(resto.cuisines, ["Française"]);
      expect(resto.telephone, "0123456789");
      expect(resto.site, "chezlulu.fr");
      expect(resto.imageVertical, "v.jpg");
      expect(resto.imageHorizontal, "h.jpg");
      expect(resto.noteMoyen, 3);
      expect(resto.lesCommentaires, isEmpty);
      expect(resto.latitude, 45.75);
      expect(resto.longitude, 4.85);
    });

    test('Equality operator == works for same osmid', () {
      final r1 = Restaurant.newRestaurant("1", "R1", 1, "", "", ["salad"]);
      final r2 = Restaurant.newRestaurant("1", "R2", 2, "", "", ["salad"]);

      expect(r1 == r2, isTrue);
    });

    test('Equality operator == returns false for different osmid', () {
      final r1 = Restaurant.newRestaurant("1", "R1", 1, "", "", ["salad"]);
      final r2 = Restaurant.newRestaurant("2", "R2", 2, "", "", ["salad"]);

      expect(r1 == r2, isFalse);
    });

    test('hashCode is based on osmid', () {
      final r1 = Restaurant.newRestaurant("42", "Nom", 2, "", "", ["salad"]);
      final r2 = Restaurant.newRestaurant("42", "NomDiff", 3, "", "", ["salad"]);

      expect(r1.hashCode, r2.hashCode);
    });

    test('toString returns expected format', () {
      final r = Restaurant.newRestaurant("88", "Pizza House", 4, "", "", ["salad"]);
      expect(r.toString(), "Restaurant(osmid: 88, nom: Pizza House)");
    });
  });
}
