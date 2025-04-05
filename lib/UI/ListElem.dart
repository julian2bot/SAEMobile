import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:second_app_td2/modele/restaurant.dart';
import '../modele/utilisateur.dart';

class ListElem extends StatefulWidget {
  final User user;
  Restaurant restaurant;
  String image;
  bool estFavoris;
  Map<String, bool> lesfavs = {};

  ListElem(
      {super.key,
      required this.restaurant,
      required this.image,
      required this.user,
      required this.lesfavs,
      this.estFavoris = false});

  @override
  _ListElemState createState() => _ListElemState();
}

class _ListElemState extends State<ListElem> {
  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
      bool fav = await widget.user.estFavoris(widget.restaurant.osmid);

    setState(() {
      widget.estFavoris = fav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(

        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Card(
          elevation: 5,
          child: SizedBox(
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2.0,
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/Boeuf.png',
                          height: 100,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        height: 100,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                        child: _ArticleDescription(
                          nom: widget.restaurant.nom,
                          cuisine: "",
                          codeCommune: widget.restaurant.codeCommune,
                          nomCommune: widget.restaurant.nomCommune,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          bool estFavoris = await widget.user
                              .ajoutRetireFavoris(widget.restaurant.osmid);
                              widget.lesfavs[widget.restaurant.osmid] = !(widget.lesfavs[widget.restaurant.osmid]??false);
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
                  ],
                ),
              )),
        ));
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
