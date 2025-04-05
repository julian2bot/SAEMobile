import 'package:flutter/material.dart';
import 'package:second_app_td2/API/api_bd.dart';
import 'imageCommentaire.dart';
import '../modele/commentaire.dart';

class CommentaireDetail extends StatefulWidget{
  final Commentaire commentaire;
  final isAdmin;

  const CommentaireDetail({
    super.key,
    required this.commentaire,
    this.isAdmin = false,
  });

  @override
  CommentaireState createState() {
    return CommentaireState();
  }
}

class CommentaireState extends State<CommentaireDetail> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    if(isVisible){
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.commentaire.username,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // nom utilisateur + date
              Row(
                children: [
                  if (widget.commentaire.nbEtoile != 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        Color starColor = index < widget.commentaire.nbEtoile
                            ? Colors.amber
                            : Colors.grey;
                        return Icon(Icons.star, color: starColor);
                      }),
                    ),
                  const Spacer(),
                  Text(
                    widget.commentaire.dateCommentaire,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),

              // commentaire
              Text(
                widget.commentaire.commentaire,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 8.0),

              //  charger les images
              FutureBuilder<List<Image>>(
                future: widget.commentaire.getMesPhotos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const SizedBox();
                  }
                  return ImageCommentaireDetail(snapshot: snapshot);
                },
              ),
              if(widget.isAdmin)
                ElevatedButton(onPressed: ()async{
                  bool success = await BdAPI.deleteCommentaireUser(widget.commentaire.resto, widget.commentaire.username);
                  if(success)
                    setState(() {
                      this.isVisible = false;
                    });
                }, child: Text("Supprimer ce commentaire"))
            ],
          ),
        ),
      );
    }
    else
      return SizedBox.shrink();
  }
}
