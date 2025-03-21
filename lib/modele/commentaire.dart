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
      resto: json["resto"] ?? "",
      username: json["username"] ?? "",
      nbEtoile: json["nbEtoile"] ?? 0,
      dateCommentaire: json["dateCommentaire"] ?? "",
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

}
