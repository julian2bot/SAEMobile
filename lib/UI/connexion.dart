import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modele/utilisateur.dart';
import '../API/api_bd.dart';
import '../router/router.dart';
import 'popUp.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _submit() async{
    print("username: ${usernameController.text}, Mot de passe: ${passwordController.text}");

    if(await BdAPI.canLogin(usernameController.text,passwordController.text)){
      print("il peut se log");
      await BdAPI.userConnecter(usernameController.text);
      
      User? use = await User.getUser();
      if(use !=null){
        print(use.userName);
        GoRouter.of(context).go(context.namedLocation('home'));
      }
    }else{
      showPopUp(context, "Mot de passe ou nom d'utilisateur incorrect.", false);
      //
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text("Données saisies"),
      //     content: Text("Email: ${usernameController.text}\nMot de passe: ${passwordController.text}"),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context),
      //         child: Text("OK"),
      //       ),
      //     ],
      //   ),
      // );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Se connecter'),  
            ),
          ],
        ),
      ),
    );
  }
}