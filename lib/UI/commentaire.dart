import 'package:flutter/material.dart';
import 'imageCommentaire.dart';
import '../modele/commentaire.dart';

class CommentaireDetail extends StatelessWidget {
  final Commentaire commentaire;

  const CommentaireDetail({
    super.key,
    required this.commentaire,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // nom utilisateur + date
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 8.0),
                          Text(
                            commentaire.username,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            commentaire.dateCommentaire,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      
                      // commentaire
                      Text(
                        commentaire.commentaire,
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 8.0),

                      //  charger les images
                      FutureBuilder<List<Image>>(
                        future: commentaire.getMesPhotos(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); 
                          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                            return const SizedBox(); 
                          }
                          return ImageCommentaireDetail(snapshot:snapshot);
                        },

                          
                      ),
                    ],
                  ),
                ),
              );  
  }
}