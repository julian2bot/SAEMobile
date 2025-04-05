import 'package:flutter/material.dart';
import 'popUp.dart';
import '../API/api_bd.dart';
import '../modele/utilisateur.dart';
import 'package:go_router/go_router.dart';
import '../router/router.dart';


class SigninPage extends StatefulWidget{
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verifyPasswordController = TextEditingController();
  
  void _submit() async {
    
    String username = usernameController.text.trim();
    print("Email: ${username}, Mot de passe: ${passwordController.text}");
    if(username.isNotEmpty){

      if(passwordController.text==verifyPasswordController.text && passwordController.text.isNotEmpty){
        if(await BdAPI.usernameExists(username)){
          print("user existe deja");
          showPopUp(context, "L'utilisateur existe déjà.", false);
        }
        else{
          await BdAPI.createUser(username, passwordController.text, false);
          await BdAPI.userConnecter(username);
          GoRouter.of(context).go(context.namedLocation('home'));
        }
      }
      else{
        showPopUp(context, "Vos mots de passe ne correspondent pas.", false);
      }
    }
    else{
      showPopUp(context, "Entrez un nom d'utilisateur.", false);
    }
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text("Données saisies"),
    //     content: Text("Email: ${emailController.text}\nMot de passe: ${passwordController.text}\n Verification : ${verifyPasswordController.text}"),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: Text("OK"),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('inscription'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: verifyPasswordController,
              decoration: const InputDecoration(labelText: 'Verification du mot de passe'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
