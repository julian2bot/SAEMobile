import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:second_app_td2/modele/restaurant.dart';
import '../modele/utilisateur.dart';

class RecoElem extends StatefulWidget {
  late User user;
  Restaurant restaurant;
  String image;
  bool estFavoris;
  RecoElem(
      {super.key,
      required this.restaurant,
      required this.image,
      this.estFavoris = false});

  @override
  _RecoElem createState() => _RecoElem();
}

class _RecoElem extends State<RecoElem> {
  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    User user = (await User.getUser())!;
    bool fav = await user.estFavoris(widget.restaurant.osmid);
    setState(() {
      widget.estFavoris = fav;
      widget.user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/Boeuf.png',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          bool estFavoris = await widget.user
                              .ajoutRetireFavoris(widget.restaurant.osmid);
                          setState(() {
                            widget.estFavoris = estFavoris;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Icon(
                        widget.estFavoris
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: _ArticleDescription(
                  nom: widget.restaurant.nom,
                  cuisine: "",
                  codeCommune: widget.restaurant.codeCommune,
                  nomCommune: widget.restaurant.nomCommune,
                ),
              ),
            ],
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
        Text(
          cuisine,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12.0),
        ),
        Text(codeCommune, style: const TextStyle(fontSize: 12.0))
      ],
    );
  }
}
