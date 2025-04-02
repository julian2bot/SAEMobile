// user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/modele/utilisateur.dart';
import 'mocks.dart';

void main() {
  group('User Tests', () {
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      mockSharedPreferences = MockSharedPreferences();

      // Mock the SharedPreferences instance to return the mock
      SharedPreferences.setMockInitialValues({});
    });

    test('create and getUser returns the correct user', () async {
      // Arrange
      // Configure the mock to return the expected values
      when(mockSharedPreferences.getString("userName")).thenReturn("michel");
      when(mockSharedPreferences.getBool("isAdmin")).thenReturn(false);

      // Act
      // Create a new user
      User michel = User.newUser("michel", isAdmin: false);

      // Mock the saveUser method to use the mockSharedPreferences
      await User.saveUser(michel);

      // Retrieve the user
      User? user = await User.getUser();

      // Assert
      expect(user, isNotNull);
      expect(user!.userName, equals("michel"));
      expect(user.isAdmin, isFalse);
    });

    test('getUser returns null when no user data is saved', () async {
      // Arrange
      when(mockSharedPreferences.getString("userName")).thenReturn(null);

      // Act
      User? user = await User.getUser();

      // Assert
      expect(user, isNull);
    });
  });
}
