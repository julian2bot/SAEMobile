import 'package:shared_preferences/shared_preferences.dart';
import 'restaurant.dart';

class User {
  final int idUser;
  final String userName;

  User({required this.idUser,required this.userName});

  static User fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json["idUser"] ?? "",
      userName: json["userName"] ?? "",
    );
  }

  static User newUser(int id, String userName) {
    User newuser = User(idUser: id, userName: userName);
    // todo: relier a la bd et insert l'utilisateur dans la bd distante
    saveUser(newuser);
    return newuser;
  }

  static List<Restaurant> getLesFavoris(){
    return [];
  }

  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("userId", user.idUser);
    await prefs.setString("userName", user.userName);
  }


  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt("userId");
    String? userName = prefs.getString("userName");

    if (id != null && userName != null) {
      return User(idUser: id, userName: userName);
    }
    return null; 
  }

  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userId");
    await prefs.remove("userName");
  }




}
