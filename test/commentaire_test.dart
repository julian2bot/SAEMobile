import 'package:flutter_test/flutter_test.dart';
import '../lib/modele/commentaire.dart'; 

void main() {
  group('Commentaire Tests', () {
    test('fromJson creates valid Commentaire object', () {
      // Arrange
      final json = {
        "osmid": "123",
        "username": "michel",
        "note": 4,
        "datecommentaire": "2025-04-05",
        "commentaire": "Excellent resto !"
      };

      // Act
      final commentaire = Commentaire.fromJson(json);

      // Assert
      expect(commentaire.resto, equals("123"));
      expect(commentaire.username, equals("michel"));
      expect(commentaire.nbEtoile, equals(4));
      expect(commentaire.dateCommentaire, equals("2025-04-05"));
      expect(commentaire.commentaire, equals("Excellent resto !"));
    });

    test('newCommentaire creates valid Commentaire object', () {
      // Arrange
      final commentaire = Commentaire.newCommentaire(
        "456",
        "jeanne",
        5,
        "2025-04-04",
        "Un vrai régal !",
      );

      // Assert
      expect(commentaire.resto, equals("456"));
      expect(commentaire.username, equals("jeanne"));
      expect(commentaire.nbEtoile, equals(5));
      expect(commentaire.dateCommentaire, equals("2025-04-04"));
      expect(commentaire.commentaire, equals("Un vrai régal !"));
    });
  });
}
