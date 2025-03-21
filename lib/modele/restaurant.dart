import 'package:flutter/material.dart';
import 'package:sae_mobile/modele/commentaire.dart';
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

    Restaurant({required this.osmid,
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
        });

    static Restaurant fromJson(Map<String, dynamic> json) {
        // todo les commentaires + cuisine qui sont des listes
        
        
        final cuisines = <String>[];
        final commentaires = <String>[];
        
        return Restaurant(
            osmid:json["osmid"],
            nom:json["nomrestaurant"],
            nbEtoile:json["etoiles"],
            codeCommune:json["codeommune"],
            nomCommune:json["nomcommune"] ?? "undefined",
            cuisines:json["cuisines"] ?? [],
            telephone:json["telephone"],
            site:json["siteinternet"],
            imageVertical:json["vertical"],
            imageHorizontal:json["horizontal"],
            noteMoyen:json["noteMoyen"] ?? 0,
            lesCommentaires:json["lesCommentaires"] ?? [],
            type:json["type"] ?? ''
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

    static Restaurant restaurantNull(){
      return Restaurant.newRestaurant(
        '0',
        'Unknown',
        0,
        '00000',
        'Unknown',
        [],
      );
    }

    Future<List<Commentaire>> getLesCommentaires() async{
      if(this.osmid != '0' &&  this.lesCommentaires.isEmpty){
        Map<String, dynamic> reponse = await BdAPI.getCommentairesResto(this.osmid);
        this.lesCommentaires = reponse["commentaires"];
        this.noteMoyen = reponse["noteMoy"];
      }
      return this.lesCommentaires;
    }

    Future<List<String>> getLesCuisines() async{
      if(this.osmid != '0' &&  this.cuisines.isEmpty){
        this.cuisines = await BdAPI.getCuisinePropose(this.osmid);
      }
      return this.cuisines;
    }

}