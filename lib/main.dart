import 'package:flutter/material.dart';
import 'package:second_app_td2/UI/Accueil.dart';
// import 'modele/utilisateur.dart';

// utilisateur creer, get, insert, et delete test / exemple
// void main() async {
//   // Créer un utilisateur
//   User newUser = User(idUser: 1, userName: "JeanDupont");
//
//   User? storedUser = await User.getUser();
//   if (storedUser != null) {
//     print("Utilisateur récupéré : ID=${storedUser.idUser}, Username=${storedUser.userName}");
//   } else {
//     print("Aucun utilisateur trouvé.");
//   }
//
//   // Sauvegarder l'utilisateur
//   await User.saveUser(newUser);
//   print("Utilisateur sauvegardé !");
//
//   // Récupérer l'utilisateur stocké
//   storedUser = await User.getUser();
//   if (storedUser != null) {
//     print("Utilisateur récupéré : ID=${storedUser.idUser}, Username=${storedUser.userName}");
//   } else {
//     print("Aucun utilisateur trouvé.");
//   }
//
//   // Supprimer l'utilisateur
//   await User.clearUser();
//   print("Utilisateur supprimé !");
//
//   // Récupérer l'utilisateur stocké
//   storedUser = await User.getUser();
//   if (storedUser != null) {
//     print("Utilisateur récupéré : ID=${storedUser.idUser}, Username=${storedUser.userName}");
//   } else {
//     print("Aucun utilisateur trouvé.");
//   }
// }





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Appli',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "IUTable O'",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Accueil()),
                );
              },
              child: Text('Connexion'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Action pour inscription
              },
              child: Text('Inscription'),
            ),
          ],
        ),
      ),
    );
  }
}
