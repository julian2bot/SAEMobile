import 'package:flutter/material.dart';

import '../API/api_bd.dart';

class Commentaire {
  final String resto; // id restaurant
  final String username;
  final int nbEtoile;
  final String dateCommentaire;
  final String commentaire;

  Commentaire({
    required this.resto,
    required this.username,
    required this.nbEtoile,
    required this.dateCommentaire,
    required this.commentaire,
  });

  static Commentaire fromJson(Map<String, dynamic> json) {
    return Commentaire(
      resto: json["osmid"] ?? "",
      username: json["username"] ?? "",
      nbEtoile: json["note"] ?? 0,
      dateCommentaire: json["datecommentaire"] ?? "",
      commentaire: json["commentaire"] ?? "",
    );
  }

  static Commentaire newCommentaire(
    String resto,
    String username,
    int nbEtoile,
    String dateCommentaire,
    String commentaire,
  ) {
    return Commentaire(
      resto: resto,
      username: username,
      nbEtoile: nbEtoile,
      dateCommentaire: dateCommentaire,
      commentaire: commentaire,
    );
  }

  // static Commentaire commentaireNull() {
  //   return Commentaire.newCommentaire(
  //       'undefined', 'undefined', 0, 'undefined', 'undefined');
  // }

  Future<List<Image>> getMesPhotos() async {
    if (this.resto != 'undefined') {
      List<String> urls = await BdAPI.getPhotosCommentaire(this.resto, this.username);
      return urls.map((url) => Image.network(url)).toList();
    }
    return [];
  }

}
