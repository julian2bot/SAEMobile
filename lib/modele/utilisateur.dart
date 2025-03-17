class User {
  final String userName;

  User({required this.userName});

  static User fromJson(Map<String, dynamic> json) {
    return User(
      userName: json["userName"] ?? "",
    );
  }

  static User newUser(String userName) {
    return User(userName: userName);
  }

  static List<Restaurant> getLesFavoris(){
    return [];
  }

  static void insertInfoBdlocal(){
    // dans sqlfite faut mettre les infos de l'utilisateur 
  }

  
  static void getInfoBdlocal(){
    // dans sqlfite faut get les infos de l'utilisateur 
    // voir ce que ca return aussi pour changer
  }
    // todo
    // get / insert quelque chose en particulier dans la bd local sqlfite
}
