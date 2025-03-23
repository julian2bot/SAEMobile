import 'package:shared_preferences/shared_preferences.dart';
import 'restaurant.dart';
import 'commentaire.dart';
import '../API/api_bd.dart';

class User {
  final bool isAdmin;
  final String userName;

  User({required this.userName, required this.isAdmin});

  static User fromJson(Map<String, dynamic> json) {
    return User(
      userName: json["username"] ?? "",
      isAdmin: json["estadmin"] ?? false,
    );
  }

  static User newUser(String userName, {bool isAdmin = false}) {
    User newuser = User(userName: userName, isAdmin: isAdmin);
    // todo: relier a la bd et insert l'utilisateur dans la bd distante
    saveUser(newuser);
    return newuser;
  }

  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userName", user.userName);
    await prefs.setBool("isAdmin", user.isAdmin);
  }

  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString("userName");
    bool? isAdmin = prefs.getBool("isAdmin");

    if (userName != null) {
      return User(userName: userName, isAdmin: isAdmin??false);
    }
    return null; 
  }

  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userName");
    await prefs.remove("isAdmin");
  }

  Future<List<Restaurant>> getLesFavoris() async{
    return await BdAPI.getLesFavoris(this.userName);
  }

  Future<List<Restaurant>> getMesRecommendations() async{
    return await BdAPI.getMesRecommandations(this.userName);
  }

  Future<List<Commentaire>> getMesAvis() async{
    return await BdAPI.getMesAvis(this.userName);
  }

  Future<Commentaire> getCommentaireResto(String osmId) async{
    return await BdAPI.getCommentairesRestoUser(osmId, this.userName);
  }

  Future<List<String>> getMesCuisinesPref() async{
    return await BdAPI.getCuisinesPref(this.userName);
  }
}
