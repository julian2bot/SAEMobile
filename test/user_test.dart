// user_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/modele/utilisateur.dart';
import '../lib/API/api_bd.dart';
import '../lib/modele/restaurant.dart';
import '../lib/modele/commentaire.dart';
import 'mocks.dart';

void main() {
  group('User Tests', () {
    late MockSharedPreferences mockPrefs;
    late MockBdAPI mockApi;

    const testUserName = 'testuserflutter';
    const testIsAdmin = true;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      mockPrefs = MockSharedPreferences();
      mockApi = MockBdAPI();
      SharedPreferences.setMockInitialValues({});
    });

    test('fromJson creates a valid User', () {
      final json = {"username": "bob", "estadmin": true};
      final user = User.fromJson(json);

      expect(user.userName, "bob");
      expect(user.isAdmin, true);
    });

    test('newUser creates and saves user', () async {
      final user = User.newUser("michel", isAdmin: false);
      expect(user.userName, "michel");
      expect(user.isAdmin, false);
    });

    test('saveUser and getUser', () async {
      final user = User(userName: "luc", isAdmin: true);
      await User.saveUser(user);
      final result = await User.getUser();

      expect(result, isNotNull);
      expect(result!.userName, equals("luc"));
      expect(result.isAdmin, isTrue);
    });

    test('getUser returns null when user not found', () async {
      await User.clearUser(); // clear any saved user
      final result = await User.getUser();
      expect(result, isNull);
    });

    test('getUserName returns correct name', () async {
      final user = User(userName: "anna", isAdmin: false);
      await User.saveUser(user);
      final name = await User.getUserName();
      expect(name, equals("anna"));
    });

    test('isAuthentificated returns true if user exists', () async {
      await User.saveUser(User(userName: "valid", isAdmin: false));
      final auth = await User.isAuthentificated();
      expect(auth, isTrue);
    });

    test('isAuthentificated returns false if no user', () async {
      await User.clearUser();
      final auth = await User.isAuthentificated();
      expect(auth, isFalse);
    });

    test('clearUser clears stored data', () async {
      await User.saveUser(User(userName: "todelete", isAdmin: true));
      await User.clearUser();
      final user = await User.getUser();
      expect(user, isNull);
    });

    // test('getLesFavoris calls BdAPI and returns restaurants', () async {
    //   final user = User(userName: testUserName, isAdmin: testIsAdmin);
    //   final expected = [Restaurant(nom: 'Resto1')];

    //   when(BdAPI.getLesFavoris(testUserName)).thenAnswer((_) async => expected);

    //   final result = await user.getLesFavoris();
    //   expect(result, expected);
    // });

    // test('getMesRecommendations returns recommendations', () async {
    //   final user = User(userName: testUserName, isAdmin: testIsAdmin);
    //   final expected = [Restaurant(nom: 'Resto2')];

    //   when(BdAPI.getMesRecommandations(testUserName)).thenAnswer((_) async => expected);

    //   final result = await user.getMesRecommendations();
    //   expect(result, expected);
    // });

    // test('getMesAvis returns user comments', () async {
    //   final user = User(userName: testUserName, isAdmin: testIsAdmin);
    //   final expected = [Commentaire(commentaire: "bon resto")];

    //   when(BdAPI.getMesAvis(testUserName)).thenAnswer((_) async => expected);

    //   final result = await user.getMesAvis();
    //   expect(result, expected);
    // });

    // test('getCommentaireResto returns comment for specific resto', () async {
    //   final user = User(userName: testUserName, isAdmin: testIsAdmin);
    //   final expected = Commentaire(commentaire: "avis");

    //   when(BdAPI.getCommentairesRestoUser("1234", testUserName)).thenAnswer((_) async => expected);

    //   final result = await user.getCommentaireResto("1234");
    //   expect(result, expected);
    // });


    // test('estFavoris returns true if in favoris', () async {
    //   final user = User(userName: testUserName, isAdmin: testIsAdmin);

    //   when(BdAPI.estFavoris("node/12358260008", testUserName)).thenAnswer((_) async => true);

    //   final result = await user.estFavoris("node/12358260008");
    //   expect(result, isTrue);
    // });

    // test('ajoutRetireFavoris calls BdAPI and returns updated favoris state', () async {
    //   final user = User(userName: testUserName, isAdmin: testIsAdmin);

    //   when(BdAPI.ajouteRetirerFavoris("999", testUserName)).thenAnswer((_) async {});
    //   when(BdAPI.estFavoris("999", testUserName)).thenAnswer((_) async => false);

    //   final result = await user.ajoutRetireFavoris("999");
    //   expect(result, isFalse);
    // });
  });
}
