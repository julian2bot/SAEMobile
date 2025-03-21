import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
  const AddComment({super.key});

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer le texte saisi
  final TextEditingController _commentController = TextEditingController();

  int _selectedRating = 0; // note default (0 à 5)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un commentaire")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // text commentaire => textarea
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Votre commentaire'),
                maxLines: 4, //  4 lignes visible de haut
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un commentaire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Sélection de la note avec étoiles
              Text("Note :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border, // Remplit l'étoile si sélectionnée
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = index + 1; //  note entre 1 et 5
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Bouton de validation
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Récupération des valeurs saisies
                    String comment = _commentController.text;
                    int rating = _selectedRating;

                    // Affichage dans la console
                    print("Commentaire : $comment");
                    print("Note : $rating");

                    // Nettoyer les champs après validation
                    _commentController.clear();
                    setState(() {
                      _selectedRating = 0; // Réinitialiser la note
                    });
                  }
                },
                child: const Text('Ajouter le commentaire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
