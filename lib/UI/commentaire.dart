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
                          Icon(Icons.person),
                          SizedBox(width: 8.0),
                          Text(
                            commentaire.username,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            commentaire.dateCommentaire,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      
                      // commentaire
                      Text(
                        commentaire.commentaire,
                        style: TextStyle(fontSize: 16),
                      ),

                      SizedBox(height: 8.0),

                      //  charger les images
                      FutureBuilder<List<Image>>(
                        future: commentaire.getMesPhotos(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); 
                          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                            return SizedBox(); 
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