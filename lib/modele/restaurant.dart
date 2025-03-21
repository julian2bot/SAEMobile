import 'package:flutter/material.dart';
import 'package:sae_mobile/modele/commentaire.dart';

class Restaurant {
    final String osmid;
    final String nom;
    final int nbEtoile;
    final String codeCommune;
    final String nomCommune;
    final List<String> cuisines;
    final String telephone;
    final String site;
    final String imageVertical;
    final String imageHorizontal;
    final int noteMoyen;
    final List<Commentaire> lesCommentaires;


    Restaurant({required this.osmid,
            required this.nom,
            required this.nbEtoile,
            required this.codeCommune,
            required this.nomCommune,
            required this.cuisines,
            this.telephone = "",
            this.site = "",
            this.imageVertical = "",
            this.imageHorizontal = "",
            this.noteMoyen = 0,
            this.lesCommentaires = const [],
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
            cuisines:json["cuisine"],
            telephone:json["telephone"],
            site:json["site"],
            imageVertical:json["imageVertical"],
            imageHorizontal:json["imageHorizontal"],
            noteMoyen:json["noteMoyen"],
            lesCommentaires:json["lesCommentaires"]
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
        );
    }



}