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
    /// return [];
    List<Restaurant> restaurants = [
      Restaurant.newRestaurant(
          "123456",
          "Le Gourmet Parisien",
          5,
          "75001",
          "Paris",
          ["Française", "Européenne", "Végétarienne"],
          telephone: "+33 1 23 45 67 89",
          site: "https://legourmetparisien.fr",
          imageVertical: "https://example.com/image1_vertical.jpg",
          imageHorizontal: "https://example.com/image1_horizontal.jpg",
          noteMoyen: 4,
          lesCommentaires: ["Excellente cuisine, service impeccable!", "Ambiance agréable, mais un peu cher."]
      ),
      Restaurant.newRestaurant(
          "789012",
          "Sushi World",
          4,
          "75002",
          "Paris",
          ["Japonais", "Sushi", "Végétalien"],
          telephone: "+33 1 98 76 54 32",
          site: "https://sushiworld.fr",
          imageVertical: "https://example.com/image2_vertical.jpg",
          imageHorizontal: "https://example.com/image2_horizontal.jpg",
          noteMoyen: 4,
          lesCommentaires: ["Sushis frais et délicieux.", "Un peu trop de monde, réservation nécessaire."]
      ),
      Restaurant.newRestaurant(
          "345678",
          "Pasta & Co",
          3,
          "75003",
          "Paris",
          ["Italien", "Pâtes", "Pizza"],
          telephone: "+33 1 67 89 10 11",
          site: "https://pastaandco.fr",
          imageVertical: "https://example.com/image3_vertical.jpg",
          imageHorizontal: "https://example.com/image3_horizontal.jpg",
          noteMoyen: 3,
          lesCommentaires: ["Bonne pizza mais les pâtes manquaient un peu de goût.", "Service un peu lent."]
      ),
      Restaurant.newRestaurant(
          "901234",
          "Le Café du Marché",
          4,
          "75004",
          "Paris",
          ["Française", "Brasserie", "Classique"],
          telephone: "+33 1 23 98 76 54",
          site: "https://cafedumarche.fr",
          imageVertical: "https://example.com/image4_vertical.jpg",
          imageHorizontal: "https://example.com/image4_horizontal.jpg",
          noteMoyen: 4,
          lesCommentaires: ["Plat du jour savoureux", "Service agréable mais restaurant un peu bruyant."]
      ),
      Restaurant.newRestaurant(
          "567890",
          "El Taco Loco",
          3,
          "75005",
          "Paris",
          ["Mexicain", "Tacos", "Grill"],
          telephone: "+33 1 76 54 32 10",
          site: "https://eltacoloco.fr",
          imageVertical: "https://example.com/image5_vertical.jpg",
          imageHorizontal: "https://example.com/image5_horizontal.jpg",
          noteMoyen: 3,
          lesCommentaires: ["Tacos très épicés", "Bonne ambiance, mais l'attente est un peu longue."]
      ),
    ];

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
