import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../API/api_bd.dart';
import '../modele/utilisateur.dart';
import './popUp.dart';

class AddComment extends StatefulWidget {
  final String restaurantId;
  const AddComment({super.key, required this.restaurantId});

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage; 

  // Controllers pour récupérer le texte saisi
  final TextEditingController _commentController = TextEditingController();

  int _selectedRating = 0; // note default (0 à 5)



  Future<void> _pickImage(ImageSource source) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path); // Convertit en fichier pour l'affichage
        });
      }
    }





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
              const Text("Note :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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



              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     ElevatedButton.icon(
              //       icon: const Icon(Icons.image),
              //       label: const Text(""),
              //       onPressed: () => _pickImage(ImageSource.gallery),
              //     ),
              //     ElevatedButton.icon(
              //       icon: const Icon(Icons.camera),
              //       label: const Text(""),
              //       onPressed: () => _pickImage(ImageSource.camera),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Aligner à droite
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12), // Ajuster la taille des boutons
                      shape: const CircleBorder(), // Boutons ronds
                    ),
                    child: const Icon(Icons.image),
                  ),
                  const SizedBox(width: 10), // Espace de 20px
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.camera),
                  ),
                ],
              ),


              // Affichage de l'image sélectionnée
              if (_selectedImage != null)
                Image.file(_selectedImage!, height: 150, width: double.infinity, fit: BoxFit.cover),

              const SizedBox(height: 20),





              // validation
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                      // recup les infos
                    String comment = _commentController.text;
                    int rating = _selectedRating;

                    // Affichage dans la console
                    print("Commentaire : $comment");
                    print("Note : $rating");
                    
                    String? username = await User.getUserName();
                    print("username: ${username}");
                    print("osmid: ${widget.restaurantId}");


                    if (_selectedImage != null) {
                      print("Image sélectionnée : ${_selectedImage!.path}");
                      if(username != null){
                        bool success = await BdAPI.insertCommentairePhoto(username, widget.restaurantId, comment, rating, _selectedImage);

                        showPopUp(context, success ? "Commentaire ajouté avec succès !" : "Erreur lors de l'ajout du commentaire." , success);
                      }
                    }else{
                      if(username != null){
                        bool success = await BdAPI.insertCommentaire(widget.restaurantId, username, rating, comment);

                        showPopUp(context, success ? "Commentaire ajouté avec succès !" : "Erreur lors de l'ajout du commentaire." , success);
                      }

                      print("Image sélectionnée : nan");
                    
                    }


                    // clear champs
                    _commentController.clear();
                    setState(() {
                      _selectedRating = 0; 
                    });
                    Navigator.pop(context, 'Nouveau commentaire');
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
