import 'package:flutter/material.dart';

class Signin_Page{
  void _submit() {
    print("Email: ${emailController.text}, Mot de passe: ${passwordController.text}");
    if(${passwordController.text} != ${validationPasswordController.text}){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erreur"),
          content: ,
        )
      )
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Données saisies"),
        content: Text("Email: ${emailController.text}\nMot de passe: ${passwordController.text}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
        title: Text('Inscription'),
    centerTitle: true,
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 10),
          TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'Mot de passe'),
          obscureText: true,
          ),
          TextField(
            controller: validationPasswordController,
            decoration: InputDecoration(labelText: 'Confiramtion du mot de passe'),
          obscureText: true,
          )
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
            // Action pour valider la connexion
            },
            child: Text('Se connecter'),
          ),
        ],
      ),
    ),
  }
}