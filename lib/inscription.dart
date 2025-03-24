import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget{
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verifyPasswordController = TextEditingController();

  void _submit() {
    print("Email: ${emailController.text}, Mot de passe: ${passwordController.text}");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Données saisies"),
        content: Text("Email: ${emailController.text}\nMot de passe: ${passwordController.text}\n Verification : ${verifyPasswordController.text}"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('inscription'),
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
            SizedBox(height: 20),
            TextField(
              controller: verifyPasswordController,
              decoration: InputDecoration(labelText: 'Verification du mot de passe'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
