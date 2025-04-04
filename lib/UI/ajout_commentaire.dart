import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../API/api_bd.dart';
import '../modele/utilisateur.dart';
import '../modele/commentaire.dart';
import './popUp.dart';

class AddComment extends StatefulWidget {
  final String restaurantId;
  const AddComment({super.key, required this.restaurantId});

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  bool loaded = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  Image? _selectedImageEdit;
  Commentaire? comm;
  // Controllers pour récupérer le texte saisi
  final TextEditingController _commentController = TextEditingController();

  int _selectedRating = 0; // note default (0 à 5)

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImage =
            File(image.path); // Convertit en fichier pour l'affichage
      });
    }
  }

  Future<void> _loadComm() async {
    User user = (await User.getUser())!;
    Commentaire? commentaire = await BdAPI.getCommentairesRestoUser(
        widget.restaurantId, user.userName);

    setState(() {
      loaded = true;
      comm = commentaire;
      _commentController.text = ((comm != null) ? comm!.commentaire : "");
      _selectedRating = ((comm != null) ? comm!.nbEtoile : 0);
      _loadImage();
    });
  }

  Future<void> _loadImage() async {
    if (comm != null) {
      List<Image> images = await comm!.getMesPhotos();
      setState(() {
        _selectedImageEdit = images[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadComm();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Scaffold(
        appBar: AppBar(title: const Text("Chargement du commentaire")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(comm!=null ? "Modifier votre commentaire" : "Ajouter un commentaire")),
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
                decoration:
                    const InputDecoration(labelText: 'Votre commentaire'),
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
              const Text("Note :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedRating
                          ? Icons.star
                          : Icons
                              .star_border, // Remplit l'étoile si sélectionnée
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

              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Aligner à droite
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(
                          12), // Ajuster la taille des boutons
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
                Image.file(_selectedImage!,
                    height: 150, width: double.infinity, fit: BoxFit.cover)
              else if (_selectedImageEdit != null)
                GestureDetector(
                  onTap: () {
                    // pour afficher en plus grands
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: _selectedImageEdit,
                          ),
                        ),
                      ),
                    );
                  },

                  // pour afficher en petit
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: _selectedImageEdit,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // validation
              ElevatedButton(
                  child: Text((comm != null ? "Modifier le commentaire" : 'Ajouter le commentaire')),
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

                      if (comm == null) {
                        // Ajout
                        if (_selectedImage != null) {
                          print("Image sélectionnée : ${_selectedImage!.path}");
                          if (username != null) {
                            bool success = await BdAPI.insertCommentairePhoto(
                                username,
                                widget.restaurantId,
                                comment,
                                rating,
                                _selectedImage);

                            showPopUp(
                                context,
                                success
                                    ? "Commentaire ajouté avec succès !"
                                    : "Erreur lors de l'ajout du commentaire.",
                                success);
                          }
                        } else {
                          if (username != null) {
                            bool success = await BdAPI.insertCommentaire(
                                widget.restaurantId, username, rating, comment);

                            showPopUp(
                                context,
                                success
                                    ? "Commentaire ajouté avec succès !"
                                    : "Erreur lors de l'ajout du commentaire.",
                                success);
                          }

                          print("Image sélectionnée : nan");
                        }
                      } else {
                        // edit
                        print("edit");
                        if (_selectedImage != null) {
                          print("ya image");
                          print("Image sélectionnée : ${_selectedImage!.path}");
                          if (username != null) {
                            bool success = await BdAPI.updateCommentairePhoto(
                                username,
                                widget.restaurantId,
                                comment,
                                rating,
                                _selectedImage);

                            showPopUp(
                                context,
                                success
                                    ? "Commentaire modifié avec succès !"
                                    : "Erreur lors de la modification du commentaire.",
                                success);
                          }
                        } else {
                          if (username != null) {
                            bool success = await BdAPI.updateCommentaire(
                                widget.restaurantId, username, comment, rating);

                            showPopUp(
                                context,
                                success
                                    ? "Commentaire modifié avec succès !"
                                    : "Erreur lors de la modification du commentaire.",
                                success);
                          }
                        }

                        // clear champs
                        _commentController.clear();
                        setState(() {
                          _selectedRating = 0;
                        });
                        Navigator.pop(context, 'Nouveau commentaire');
                      }
                    }
                    ;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
