import 'package:flutter/material.dart';

class Restaurant {
    final String osmid
    final String nom
    final int nbEtoile
    final String codeCommune
    final String nomCommune
    final List<String> cuisines
    final String telephone;
    final String site;
    final String imageVertical;
    final String imageHorizontal;
    final int noteMoyen;
    final List<String> lesCommentaires;


    Restaurant({required this.osmid,
            required this.nom,
            required this.nbEtoile,
            required this.codeCommune,
            required this.nomCommune,
            required this.cuisine,
            this.telephone = "",
            this.site = "",
            this.imageVertical = "",
            this.imageHorizontal = "",
            this.noteMoyen = "",
            this.lesCommentaires = [] 
        });
    

    static Restaurant fromJson(Map<String, dynamic> json) {
        // todo les commentaires + cuisine qui sont des listes
        
        
        final cuisines = <String>[];
        final commentaires = <String>[];
        
        return Restaurant(
            osmid:json["osmid"],
            nom:json["nom"],
            nbEtoile:json["nbEtoile"],
            codeCommune:json["codeCommune"],
            nomCommune:json["nomCommune"],
            cuisine:json["cuisine"],
            telephone:json["telephone"],
            site:json["site"],
            imageVertical:json["imageVertical"],
            imageHorizontal:json["imageHorizontal"],
            noteMoyen:json["noteMoyen"],
            lesCommentaires:json["lesCommentaires"]
        );
    }


    static Restaurant.newRestaurant(
        int osmid,
        String nom,
        int nbEtoile,
        String codeCommune,
        String nomCommune,
        String cuisine, {
        String telephone = "",
        String site = "",
        String imageVertical = "",
        String imageHorizontal = "",
        double noteMoyen = 0.0,
        List<dynamic> lesCommentaires = const [],
    }) {
        return Restaurant(
        osmid: osmid,
        nom: nom,
        nbEtoile: nbEtoile,
        codeCommune: codeCommune,
        nomCommune: nomCommune,
        cuisine: cuisine,
        telephone: telephone,
        site: site,
        imageVertical: imageVertical,
        imageHorizontal: imageHorizontal,
        noteMoyen: noteMoyen,
        lesCommentaires: lesCommentaires,
        );
    }



}