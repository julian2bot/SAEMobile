import 'package:flutter/material.dart';
import '../modele/commentaire.dart';
import '../API/api_bd.dart';

class Restaurant {
  final String osmid;
  final String nom;
  final int nbEtoile;
  final String codeCommune;
  final String nomCommune;
  List<String> cuisines;
  final String telephone;
  final String site;
  final String imageVertical;
  final String imageHorizontal;
  int noteMoyen;
  List<Commentaire> lesCommentaires;
  final String type;

  final double latitude;
  final double longitude;

  Restaurant({
    required this.osmid,
    required this.nom,
    required this.nbEtoile,
    required this.codeCommune,
    required this.nomCommune,
    required this.cuisines,
    this.type = "",
    this.telephone = "",
    this.site = "",
    this.imageVertical = "",
    this.imageHorizontal = "",
    this.noteMoyen = 0,
    this.lesCommentaires = const [],
    this.longitude =0,
    this.latitude = 0,
  });

  static Restaurant fromJson(Map<String, dynamic> json) {
    print("\n FROM JSON \n");
    return Restaurant(
      osmid: json["osmid"] ?? "",
      nom: json["nomrestaurant"] ?? "",
      nbEtoile: json["etoiles"] ?? 0,
      codeCommune: json["codecommune"] ?? "",
      nomCommune: json["nomcommune"] ?? "undefined",
      cuisines: json["cuisines"] ?? [],
      telephone: json["telephone"] ?? "undefined",
      site: json["siteinternet"] ?? "undefined",
      imageVertical: json["vertical"] ?? "undefined",
      imageHorizontal: json["horizontal"] ?? "undefined",
      noteMoyen: (json["noteMoyen"] as num?)?.toInt() ?? 0,
      lesCommentaires: json["lesCommentaires"] ?? [],
      type: json["type"] ?? "",
      latitude: double.tryParse(json["latitude"]) ?? 0,
      longitude: double.tryParse(json["longitude"]) ?? 0,
    );
  }

  static Restaurant newRestaurant(
    String osmid,
    String nom,
    int nbEtoile,
    String codeCommune,
    String nomCommune,
    List<String> cuisines, {
    String telephone = "",
    String site = "",
    String imageVertical = "",
    String imageHorizontal = "",
    int noteMoyen = 0,
    List<Commentaire> lesCommentaires = const [],
    double latitude = 0,
    double longitude = 0,
  }) {
    return Restaurant(
      osmid: osmid,
      nom: nom,
      nbEtoile: nbEtoile,
      codeCommune: codeCommune,
      nomCommune: nomCommune,
      cuisines: cuisines,
      telephone: telephone,
      site: site,
      imageVertical: imageVertical,
      imageHorizontal: imageHorizontal,
      noteMoyen: noteMoyen,
      lesCommentaires: lesCommentaires,
      latitude: latitude,
      longitude: longitude,
    );
  }
  //
  // static Restaurant restaurantNull() {
  //   return Restaurant.newRestaurant(
  //     '0',
  //     'Unknown',
  //     0,
  //     '00000',
  //     'Unknown',
  //     [],
  //   );
  // }

  Future<List<Commentaire>> getLesCommentaires() async {
    if (this.osmid != '0' && this.lesCommentaires.isEmpty) {
      Map<String, dynamic> reponse =
          await BdAPI.getCommentairesResto(this.osmid);
      this.lesCommentaires = reponse["commentaires"];
      this.noteMoyen = (reponse["noteMoy"] as num?)?.toInt() ?? 0;
    }
    return this.lesCommentaires;
  }

  Future<List<String>> getLesCuisines() async {
    if (this.osmid != '0' && this.cuisines.isEmpty) {
      this.cuisines = await BdAPI.getCuisinePropose(this.osmid);
    }
    return this.cuisines;
  }

  Future<List<String>> getMesPhotosCommentaire() async {
    if (this.osmid != '0') {
      return await BdAPI.getPhotosCommentairesResto(this.osmid);
    }
    return [];
  }
}
