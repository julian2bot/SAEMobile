import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:second_app_td2/modele/restaurant.dart';

class RecoElem extends StatelessWidget {
  final Restaurant restaurant;
  final String image;
  final bool estFavoris;

  const RecoElem({super.key, required this.restaurant, required this.image, this.estFavoris = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 5,
        child: SizedBox(
          height: 150,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 2.0,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/Boeuf.png',
                      height: 150,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                    height: 150,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _ArticleDescription(
                      nom: restaurant.nom,
                      cuisine: "",
                      codeCommune: restaurant.codeCommune,
                      nomCommune: restaurant.nomCommune,
                    ),
                  ),
                ),
                Icon(
                  estFavoris ? Icons.favorite : Icons.favorite_border,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    required this.nom,
    required this.cuisine,
    required this.codeCommune,
    required this.nomCommune,
  });

  final String nom;
  final String cuisine;
  final String codeCommune;
  final String nomCommune;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nom,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Expanded(
          child: Text(
            cuisine,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.0),
          ),
        ),
        Text(codeCommune, style: const TextStyle(fontSize: 12.0))
      ],
    );
  }
}
