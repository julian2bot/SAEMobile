import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecoElem extends StatelessWidget {
  const RecoElem({
    super.key,
    required this.image,
    required this.nom,
    required this.noteMoy,
    required this.cuisine,
    required this.codeCommune,
    required this.nomCommune,
  });

  final String image;
  final String nom;
  final int noteMoy;
  final String cuisine;
  final String codeCommune;
  final String nomCommune;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Card(
          child: SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.0,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/Boeuf.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _ArticleDescription(
                      nom: nom,
                      noteMoy: noteMoy,
                      cuisine: cuisine,
                      codeCommune: codeCommune,
                      nomCommune: nomCommune,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    required this.nom,
    required this.noteMoy,
    required this.cuisine,
    required this.codeCommune,
    required this.nomCommune,
  });

  final String nom;
  final int noteMoy;
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
            style: const TextStyle(fontSize: 20.0, color: Colors.black54),
          ),
        ),
        Text(codeCommune, style: const TextStyle(fontSize: 20.0, color: Colors.black87))
      ],
    );
  }
}
