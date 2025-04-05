// mocks.dart
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/API/api_bd.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockBdAPI extends Mock implements BdAPI {}
