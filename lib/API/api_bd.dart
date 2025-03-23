import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import '../modele/restaurant.dart';
import '../modele/commentaire.dart';
import '../modele/utilisateur.dart' as utilisateur;

class BdAPI {
  static bool bdIsInit = false;

  static Future<List<List<dynamic>>> loadCSV() async {
    final String rawData = await rootBundle.loadString('assets/pass.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);
    return csvTable;
  }

  static Future<void> initBD() async {
    if (!bdIsInit) {
      List<List<dynamic>> passData = await loadCSV();
      await Supabase.initialize(
        url: passData[0][0],
        anonKey: passData[1][0],
      );
      bdIsInit = true;
    }
  }

  // Vérificateurs

  // Vérifie si une région existe
  static Future<bool> regionExists(String codeRegion) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('region')
        .select('coderegion')
        .eq('coderegion', codeRegion)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si un département existe
  static Future<bool> departementExists(String codeDepartement) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('departement')
        .select('codedepartement')
        .eq('codedepartement', codeDepartement)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si une commune existe
  static Future<bool> communeExists(String codeCommune) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('commune')
        .select('codecommune')
        .eq('codecommune', codeCommune)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si un restaurant existe
  static Future<bool> restaurantExists(String osmid) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('restaurant')
        .select('osmid')
        .eq('osmid', osmid)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si une cuisine existe
  static Future<int> getCuisineId(String nomCuisine) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('cuisine')
        .select('idcuisine')
        .eq('nomcuisine', nomCuisine)
        .maybeSingle();
    return response != null ? response['idcuisine'] : -1;
  }

  // Vérifie si un commentaire existe
  static Future<bool> commentaireExists(String osmid, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('avis')
        .select('osmid')
        .eq('osmid', osmid)
        .eq('username', username)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si un restaurant est dans les favoris
  static Future<bool> estFavoris(String osmid, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('restaurant_favoris')
        .select('osmid')
        .eq('osmid', osmid)
        .eq('username', username)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si une cuisine (id) est une préféré d'un user
  static Future<bool> estCuisinePref(String username, int cuisineId) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('cuisine_favorites')
        .select()
        .eq('idcuisine', cuisineId)
        .eq('username', username)
        .maybeSingle();
    return response != null;
  }

  // Getters

  // Récupère une région par son code
  static Future<Map<String, dynamic>> getRegion(String codeRegion) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('region')
        .select()
        .eq('coderegion', codeRegion)
        .maybeSingle();
    return Map<String, dynamic>.from(data!);
  }

  // Récupère un département par son code
  static Future<Map<String, dynamic>> getDepartement(
      String codeDepartement) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('departement')
        .select()
        .eq('codedepartement', codeDepartement)
        .maybeSingle();
    return Map<String, dynamic>.from(data!);
  }

  // Récupère une commune par son code
  static Future<Map<String, dynamic>> getCommune(String codeCommune) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('commune')
        .select()
        .eq('codecommune', codeCommune)
        .maybeSingle();
    return Map<String, dynamic>.from(data!);
  }

  // Récupère tous les restaurants
  static Future<List<Restaurant>> getResto() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase.from('restaurant').select();
    final List<Restaurant> lesRestos = [];

    for (var resto in data) {
      lesRestos.add(Restaurant.fromJson(resto));
    }

    return lesRestos;
  }

  // Récupère un restaurant par son ID
  static Future<Restaurant> getRestaurantByID(String osmID) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('restaurant')
        .select()
        .eq('osmid', osmID)
        .maybeSingle();
    if (data != null) {
      final Map<String, dynamic> restaurantData =
          Map<String, dynamic>.from(data);
      restaurantData['cuisines'] = await getCuisinePropose(osmID);
      restaurantData['nomcommune'] =
          (await getCommune(restaurantData["codecommune"]))["nomcommune"];
      print("\n FINAL DATA" + restaurantData.toString());
      return Restaurant.fromJson(restaurantData);
    }
    return Restaurant.restaurantNull();
  }

  // Récupère un restaurant par son nom
  static Future<List<Restaurant>> getRestaurantByName(String name) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('restaurant')
        .select()
        .ilike('nomrestaurant', '%$name%');
    final List<Restaurant> lesRestos = [];
    for (var resto in data) {
      resto['cuisines'] = await getCuisinePropose(resto['osmid']);
      lesRestos.add(Restaurant.fromJson(resto));
    }
    return lesRestos;
  }

  // Récupère l'ID de la prochaine cuisine
  static Future<int> getNextCuisineID() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('cuisine')
        .select('idcuisine')
        .order('idcuisine', ascending: false)
        .limit(1)
        .maybeSingle();
    return data != null ? (data['idcuisine'] as int) + 1 : 0;
  }

  // Récupère les cuisines proposées pour un restaurant
  static Future<List<String>> getCuisinePropose(String osmID) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final proposeData =
        await supabase.from('propose').select('idcuisine').eq('osmid', osmID);

    List<String> cuisines = [];
    for (var cuisine in proposeData) {
      final cuisineData = await supabase
          .from('cuisine')
          .select('nomcuisine')
          .eq('idcuisine', cuisine["idcuisine"])
          .maybeSingle();
      if (cuisineData != null) {
        cuisines.add(cuisineData["nomcuisine"]);
      }
    }

    return cuisines;
  }

  // Renvois les cuisines préféré d'un utilisateur
  static Future<List<String>> getCuisinesPref(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final proposeData = await supabase
        .from('cuisine_favorites')
        .select('idcuisine')
        .eq('username', username);

    List<String> cuisines = [];
    for (var cuisine in proposeData) {
      final cuisineData = await supabase
          .from('cuisine')
          .select('nomcuisine')
          .eq('idcuisine', cuisine["idcuisine"])
          .maybeSingle();
      if (cuisineData != null) {
        cuisines.add(cuisineData["nomcuisine"]);
      }
    }

    return cuisines;
  }

  // Récupère tous les types de restaurants
  static Future<List<String>> getAllTypeResto() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase.from('restaurant').select('DISTINCT(type)');
    return data.map((e) => e['type'] as String).toList();
  }

  // Récupère les restaurants par type
  static Future<List<Restaurant>> getRestoByType(List<String> types) async {
    await initBD();
    if (types.isEmpty) return [];
    final supabase = Supabase.instance.client;
    final List<Restaurant> lesRestos = [];

    final data = await supabase
        .from('restaurant')
        .select()
        .or(types.map((type) => "type.ilike.%$type%").join(','));

    for (var resto in data) {
      lesRestos.add(Restaurant.fromJson(resto));
    }
    return lesRestos;
  }

  // Récupère toutes les cuisines des restaurants
  static Future<List<String>> getAllCuisinesResto() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase.from('cuisine').select('DISTINCT(nomcuisine)');
    return data.map((e) => e['nomcuisine'] as String).toList();
  }

  // Récupère toutes les marques des restaurants
  static Future<List<String>> getAllMarques() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('restaurant')
        .select('DISTINCT(marque)')
        .not('marque', 'is', null);
    return data.map((e) => e['marque'] as String).toList();
  }

  // Récupère les restaurants par marque
  static Future<List<Restaurant>> getRestoByMarque(String marque) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final List<Restaurant> lesRestos = [];
    final data =
        await supabase.from('restaurant').select().ilike('marque', '%$marque%');
    for (var resto in data) {
      lesRestos.add(Restaurant.fromJson(resto));
    }
    return lesRestos;
  }

  // Récupère les restaurants par cuisine
  static Future<List<Restaurant>> getRestoByCuisine(
      List<String> cuisines) async {
    await initBD();
    if (cuisines.isEmpty) return [];
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('propose')
        .select('osmid, count(osmid) as nb')
        .or(cuisines.map((cuisine) => "nomcuisine.ilike.%$cuisine%").join(','))
        // .groupBy('osmid')
        .order('nb', ascending: false);
    List<Restaurant> restos = [];
    for (var rest in data) {
      restos.add(await getRestaurantByID(rest['osmid']));
    }
    return restos;
  }

  // Récupère les restaurants par services
  static Future<List<Restaurant>> getRestoByServices(
      List<String> services) async {
    await initBD();
    if (services.isEmpty) return [];
    final supabase = Supabase.instance.client;
    final conditions =
        services.map((service) => "$service.not.is.null").toList();
    List<Restaurant> restos = [];
    final data =
        await supabase.from('restaurant').select().or(conditions.join(','));
    for (var rest in data) {
      restos.add(Restaurant.fromJson(rest));
    }
    return restos;
  }

  // Récupère les commentaires d'un restaurant
  static Future<Map<String, dynamic>> getCommentairesResto(String osmID) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase.from('avis').select().eq('osmid', osmID);
    if (data.isEmpty) {
      return {"noteMoy": 0, "commentaires": []};
    }
    double noteTotal = 0;
    int count = 0;
    List<Commentaire> lesComms = [];
    for (var avis in data) {
      if (avis['note'] != null) {
        noteTotal += avis['note'];
        count++;
      }
      lesComms.add(Commentaire.fromJson(avis));
    }
    double noteMoyenne = count > 0 ? noteTotal / count : 0;
    return {"noteMoy": noteMoyenne, "commentaires": lesComms};
  }

  // Récupère les commentaires d'un utilisateur pour un restaurant
  static Future<Commentaire> getCommentairesRestoUser(
      String osmID, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('avis')
        .select()
        .eq('osmid', osmID)
        .eq('username', username)
        .maybeSingle();
    if (data == null) {
      return Commentaire.commentaireNull();
    } else {
      return Commentaire.fromJson(data);
    }
  }

  // Récupère les avis d'un utilisateur
  static Future<List<Commentaire>> getMesAvis(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final List<Commentaire> lesComms = [];
    final data =
        await supabase.from('avis').select('*').eq('username', username);
    for (var comm in data) {
      lesComms.add(Commentaire.fromJson(comm));
    }
    return lesComms;
  }

  // Récupère les photos d'un commentaires
  static Future<List<String>> getPhotosCommentaire(
      String osmID, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from("photo_avis")
        .select("photocommentaire")
        .eq('osmid', osmID)
        .eq('username', username);
    final List<String> res = [];
    for (var photo in data) {
      res.add(photo["photocommentaire"]);
    }
    return res;
  }

  // Récupère les photos des commentaires d'un restos
  static Future<List<String>> getPhotosCommentairesResto(String osmID) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from("photo_avis")
        .select("photocommentaire")
        .eq('osmid', osmID);
    final List<String> res = [];
    for (var photo in data) {
      res.add(photo["photocommentaire"]);
    }
    return res;
  }

  // Récupère les recommandations pour un utilisateur
  static Future<List<Restaurant>> getMesRecommandations(String username,
      {int max = 10}) async {
    await initBD();
    final favoris = await getLesFavoris(username);
    final avis = await getMesAvis(username);
    final supabase = Supabase.instance.client;
    final meilleursData = await supabase
        .from('avis')
        .select('*')
        .eq('username', username)
        .gte('note', 3);
    final meilleurs = meilleursData;
    if (meilleurs.isEmpty) {
      return [];
    }
    Map<String, int> lesCuisines = {};
    Map<String, int> lesTypes = {};
    for (var favResto in favoris) {
      lesTypes[favResto.type] = (lesTypes[favResto.type] ?? 0) + 1;
      final cuisines = await getCuisinePropose(favResto.osmid);
      for (var cuisine in cuisines) {
        lesCuisines[cuisine] = (lesCuisines[cuisine] ?? 0) + 1;
      }
    }
    for (var favResto in meilleurs) {
      lesTypes[favResto['type']] = (lesTypes[favResto['type']] ?? 0) + 1;
      final cuisines = await getCuisinePropose(favResto['osmid']);
      for (var cuisine in cuisines) {
        lesCuisines[cuisine] = (lesCuisines[cuisine] ?? 0) + 1;
      }
    }
    final sortedCuisines = Map.fromEntries(lesCuisines.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
    final sortedTypes = Map.fromEntries(
        lesTypes.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    final topCuisines = sortedCuisines.keys.take(2).toList();
    final topTypes = sortedTypes.keys.take(2).toList();
    final lesCuisinesRestos = await getRestoByCuisine(topCuisines);
    final lesTypesRestos = await getRestoByType(topTypes);
    List<Restaurant> lesRecos = [];
    int indexCuisines = 0;
    int indexTypes = 0;
    while (indexCuisines < max &&
        indexCuisines < lesCuisinesRestos.length &&
        lesRecos.length < max) {
      final resto = lesCuisinesRestos[indexCuisines];
      if (!favoris.contains(resto) &&
          !lesRecos.contains(resto) &&
          !avisContinentResto(avis, resto.osmid)) {
        lesRecos.add(resto);
      }
      indexCuisines++;
    }
    while (indexTypes < max &&
        indexTypes < lesTypesRestos.length &&
        lesRecos.length < max) {
      final resto = lesTypesRestos[indexTypes];
      if (!favoris.contains(resto) &&
          !lesRecos.contains(resto) &&
          !avisContinentResto(avis, resto.osmid)) {
        lesRecos.add(resto);
      }
      indexTypes++;
    }
    if (lesRecos.length < max) {
      final lesRestosLambda = await getResto();
      int indexLambda = 0;
      while (indexLambda < max &&
          indexLambda < lesRestosLambda.length &&
          lesRecos.length < max) {
        final resto = lesRestosLambda[indexLambda];
        if (!favoris.contains(resto) &&
            !lesRecos.contains(resto) &&
            !avisContinentResto(avis, resto.osmid)) {
          lesRecos.add(resto);
        }
        indexLambda++;
      }
    }
    for (var reco in lesRecos) {
      if (reco.cuisines == []) {
        reco.cuisines = await getCuisinePropose(reco.osmid);
      }
    }
    return lesRecos;
  }

  // Recherche des restaurants par nom ou cuisine
  static Future<Map<String, dynamic>> rechercheResto(String value) async {
    await initBD();
    final cuis = await getRestoByCuisine([value]);
    final resto = await getRestaurantByName(value);
    final user = await utilisateur.User.getUser();
    final result = {
      'restos': [...cuis, ...resto],
      'user': (user == null)
          ? ""
          : user.userName, // Remplacez par le nom d'utilisateur si connecté
      'favori': (user == null)
          ? []
          : await getLesFavoris(
              user.userName), // Remplacez par le nom d'utilisateur si connecté
    };
    return result;
  }

  // Récupère les images d'un restaurant
  static Future<Map<String, dynamic>> getImagesResto(String osmid) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('restaurant')
        .select('horizontal, vertical')
        .eq('osmid', osmid)
        .maybeSingle();
    if (data == null) {
      return {
        'vertical': [],
        'horizontal': [],
      };
    }
    return data;
  }

  // Récupère les favoris d'un utilisateur
  static Future<List<Restaurant>> getLesFavoris(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('restaurant_favoris')
        .select('*')
        .eq('username', username);
    final List<Restaurant> lesRestos = [];
    for (var resto in data) {
      lesRestos.add(await getRestaurantByID(resto["osmid"]));
    }
    return lesRestos;
  }

  // Insert

  // Créer une région si elle n'existe pas encore
  static Future<bool> createRegion(String codeRegion, String nomRegion) async {
    await initBD();
    if (await regionExists(codeRegion)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('region')
        .insert({'coderegion': codeRegion, 'nomregion': nomRegion}).select();
    return response.isNotEmpty;
  }

  // Créer un département si il n'existe pas encore
  static Future<bool> createDepartement(
      String codeRegion, String codeDepartement, String nomDepartement) async {
    await initBD();
    if (await departementExists(codeDepartement)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase.from('departement').insert({
      'coderegion': codeRegion,
      'codedepartement': codeDepartement,
      'nomdepartement': nomDepartement
    }).select();
    return response.isNotEmpty;
  }

  // Créer une commune si elle n'existe pas encore
  static Future<bool> createCommune(
      String codeDepartement, String codeCommune, String nomCommune) async {
    await initBD();
    if (await communeExists(codeCommune)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase.from('commune').insert({
      'codedepartement': codeDepartement,
      'codecommune': codeCommune,
      'nomcommune': nomCommune
    }).select();
    return response.isNotEmpty;
  }

  // Crée un restaurant à partir d'une liste d'informations
  static Future<bool> createRestaurant(List<dynamic> info) async {
    await initBD();
    if (info.length != 24 || await restaurantExists(info[0])) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('restaurant')
        .insert(
            info.asMap().map((index, value) => MapEntry('col$index', value)))
        .select();
    return response.isNotEmpty;
  }

  // Créer un type de cuisine s'il n'a pas été créé
  static Future<int> createCuisine(String nomCuisine) async {
    await initBD();
    final idCuisine = await getCuisineId(nomCuisine);
    if (idCuisine != -1) {
      return idCuisine;
    }
    final supabase = Supabase.instance.client;
    final nextIdResponse = await supabase
        .from('cuisine')
        .select('idcuisine')
        .order('idcuisine', ascending: false)
        .limit(1)
        .maybeSingle();
    final nextId =
        (nextIdResponse != null ? nextIdResponse['idcuisine'] : 0) + 1;
    final response = await supabase
        .from('cuisine')
        .insert({'idcuisine': nextId, 'nomcuisine': nomCuisine}).select();
    if (response.isEmpty) {
      return -1;
    }
    return nextId;
  }

  // Insert une proposition de cuisine pour un restaurant (Crée la cuisine si elle n'existe pas)
  static Future<bool> insertCuisinePropose(
      String osmID, String nomCuisine) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final existingPropose = await supabase
        .from('propose')
        .select('idcuisine')
        .eq('osmid', osmID)
        .eq('nomcuisine', nomCuisine)
        .maybeSingle();
    if (existingPropose != null) {
      return false;
    }
    final idCuisine = await createCuisine(nomCuisine);
    final response = await supabase
        .from('propose')
        .insert({'idcuisine': idCuisine, 'osmid': osmID}).select();
    return response.isNotEmpty;
  }

  // Insert les horaires d'ouvertures d'un restaurant
  static Future<bool> insertHoraires(String osmID, String horaires) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final transformedHours = transformOpeningHours(horaires);
    for (var unHorraire in transformedHours) {
      for (var unJour in unHorraire["jours"]) {
        for (var unCrenau in unHorraire["heures"]) {
          final response = await supabase.from('heure_ouverture').insert({
            'osmid': osmID,
            'jouroçuverture': unJour,
            'heuredebut': unCrenau["debut"],
            'heurefin': unCrenau["fin"]
          }).select();
          if (response.isEmpty) {
            print("erreur resto : $osmID format : $horaires");
            return false;
          }
        }
      }
    }
    return true;
  }

  // Ajoute un commentaire d'un utilisateur pour un restaurant
  static Future<bool> insertCommentaire(
      String osmID, String username, int note, String commentaire) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final date = DateTime.now().toIso8601String();
    final response = await supabase.from('avis').insert({
      'osmid': osmID,
      'username': username,
      'note': note,
      'commentaire': commentaire,
      'datecommentaire': date
    }).select();
    if (response.isEmpty) {
      print("erreur ${response}");
      return false;
    }
    return true;
  }

  // Ajoute ou retire un restaurant aux favoris de l'utilisateur
  static Future<bool> ajouteRetirerFavoris(
      String osmID, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final isFavoris = await estFavoris(osmID, username);
    if (isFavoris) {
      final response = await supabase
          .from('restaurant_favoris')
          .delete()
          .eq('osmid', osmID)
          .eq('username', username)
          .select();
      return response.isNotEmpty;
    } else {
      final response = await supabase
          .from('restaurant_favoris')
          .insert({'osmid': osmID, 'username': username}).select();
      return response.isNotEmpty;
    }
  }

  // Ajoute ou retire une cuisine pref
  static Future<bool> ajouteRetirerCuisinePref(
      String nomCuisine, String username) async {
    await initBD();
    final idCuisine = await getCuisineId(nomCuisine);
    final supabase = Supabase.instance.client;
    final isPref = await estCuisinePref(username, idCuisine);
    if (isPref) {
      final response = await supabase
          .from('cuisine_favorites')
          .delete()
          .eq('idcuisine', idCuisine)
          .eq('username', username)
          .select();
      return response.isNotEmpty;
    } else {
      final response = await supabase
          .from('cuisine_favorites')
          .insert({'idcuisine': idCuisine, 'username': username}).select();
      return response.isNotEmpty;
    }
  }

  // Ajoute une image d'un commentaire à la BD
  static Future<bool> ajoutePhotoCommentaire(
      String osmID, String username, String lienPhoto) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response =
        await supabase // Gère automatiquement l'id de la photo gràce à l'option is identity mise sur la colone dans supabase
            .from('photo_avis')
            .insert({
      'username': username,
      'osmid': osmID,
      'photocommentaire': lienPhoto
    }).select();
    return response.isNotEmpty;
  }

  // Delete

  // Supprime un commentaire d'un utilisateur sur un restaurant
  static Future<bool> deleteCommentaireUser(
      String osmID, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    if (!await commentaireExists(osmID, username)) {
      return false;
    }
    await deleteAllPhotoCommentaire(osmID, username);
    final response = await supabase
        .from('avis')
        .delete()
        .eq('osmid', osmID)
        .eq('username', username)
        .select();
    return response.isNotEmpty;
  }

  // Supprime une photo d'un commentaire
  static Future<bool> deletePhotoCommentaire(
      String osmID, String username, int idPhoto) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('photo_avis')
        .delete()
        .eq('osmid', osmID)
        .eq('photoid', idPhoto)
        .eq('username', username)
        .select();
    return response.isNotEmpty;
  }

  // Supprime toutes les photos d'un commentaire
  static Future<bool> deleteAllPhotoCommentaire(
      String osmID, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('photo_avis')
        .delete()
        .eq('osmid', osmID)
        .eq('username', username)
        .select();
    return response.isNotEmpty;
  }

  // Update

  // Ajoute des images à un restaurant par son ID
  static Future<bool> addImageRestaurantById(
      String osmid, String imageH, String imageV) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('restaurant')
        .update({'horizontal': imageH, 'vertical': imageV}).eq('osmid', osmid);
    return response.error == null;
  }

  // Modifie un commentaire existant
  static Future<bool> updateCommentaire(
      String osmid, String username, String commentaire, int etoiles) async {
    await initBD();
    final supabase = Supabase.instance.client;
    if (!await commentaireExists(osmid, username)) {
      return false;
    }
    final response = await supabase
        .from('avis')
        .update({'commentaire': commentaire, 'note': etoiles})
        .eq('osmid', osmid)
        .eq('username', username);
    return response.error == null;
  }

  // User Management

  // Vérifie si un utilisateur existe
  static Future<bool> usernameExists(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('utilisateur')
        .select('username')
        .eq('username', username)
        .maybeSingle();
    return response != null;
  }

  // Récupère les informations d'un utilisateur
  static Future<Map<String, dynamic>?> getUser(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('utilisateur')
        .select('*')
        .eq('username', username)
        .maybeSingle();
    return response;
  }

  // Connecte un utilisateur (met les infos dans une session)
  static Future<void> userConnecter(String username) async {
    await initBD();
    final userInfo = await getUser(username);
    if (userInfo != null) {
      utilisateur.User.saveUser(utilisateur.User(
          userName: userInfo['username'],
          isAdmin: userInfo['estadmin'] ?? false));
    }
  }

  // Vérifie si un utilisateur est administrateur
  static Future<bool> isAdmin(String username) async {
    final userInfo = await getUser(username);
    return userInfo?['estadmin'] == true;
  }

  // Ajoute un utilisateur à la base de données
  static Future<bool> createUser(
      String username, String mdp, bool isAdmin) async {
    await initBD();
    if (await usernameExists(username)) {
      return false;
    }
    final hashedPassword = hashPassword(mdp);
    final supabase = Supabase.instance.client;
    final response = await supabase.from('utilisateur').insert(
        {'username': username, 'mdp': hashedPassword, 'estadmin': isAdmin});
    return response.error == null;
  }

  // Vérifie si la connexion est autorisée pour un username et un mdp
  static Future<bool> canLogin(String username, String mdp) async {
    await initBD();
    final hashedPassword = hashPassword(mdp);
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('utilisateur')
        .select('*')
        .eq('username', username)
        .eq('mdp', hashedPassword)
        .maybeSingle();
    return response != null;
  }

  // Supprime un utilisateur
  static Future<bool> deleteUser(String username) async {
    await initBD();
    if (!await usernameExists(username)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('utilisateur')
        .delete()
        .eq('username', username)
        .select();
    return response.isNotEmpty;
  }

  // Met à jour les informations d'un utilisateur
  static Future<bool> updateUser(String usernameBefore, String newUsername,
      String mdp, bool isAdmin) async {
    await initBD();
    if (usernameBefore != newUsername && await usernameExists(newUsername)) {
      return false;
    }
    final hashedPassword = hashPassword(mdp);
    final supabase = Supabase.instance.client;
    final response = await supabase.from('utilisateur').update({
      'username': newUsername,
      'mdp': hashedPassword,
      'estadmin': isAdmin
    }).eq('username', usernameBefore);
    return response.error == null;
  }

  // Met à jour le nom d'utilisateur
  static Future<bool> updateNameUser(
      String usernameBefore, String newUsername) async {
    await initBD();
    if (usernameBefore != newUsername && await usernameExists(newUsername)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('utilisateur')
        .update({'username': newUsername}).eq('username', usernameBefore);
    if (response.error == null) {
      await userConnecter(newUsername);
      return true;
    }
    return false;
  }

  // UTILITAIRE

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static List<String> getAllDays(String firstDay, String lastDay) {
    List<String> days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
    List<String> res = [];

    int firstIndex = days.indexOf(firstDay);
    int lastIndex = days.indexOf(lastDay);

    if (firstIndex == -1 || lastIndex == -1) {
      return [];
    }

    for (int i = firstIndex; i <= lastIndex; i++) {
      res.add(days[i]);
    }

    return res;
  }

  static List<Map<String, dynamic>> transformOpeningHours(String opening) {
    List<Map<String, dynamic>> res = [];

    List<String> lesHoraires = opening.split("; ");
    for (String value in lesHoraires) {
      Map<String, dynamic> truc = {};
      List<String> temp = value.split(" ");
      String firstPart = temp.isNotEmpty ? temp[0] : "";
      String secondPart = temp.length > 1 ? temp.sublist(1).join(" ") : "";

      List<String> lesJours = [];
      for (String jour in firstPart.split(",")) {
        List<String> oui = [];
        List<String> tempJour = jour.split("-");

        if (tempJour.length > 1) {
          oui = getAllDays(tempJour[0], tempJour[1]);
        } else {
          oui = tempJour;
        }

        lesJours.addAll(oui);
      }

      truc["jours"] = lesJours;
      truc["heures"] = [];

      if (truc["jours"].isNotEmpty) {
        if (temp.length > 1) {
          secondPart = secondPart.replaceAll(" ", "");
          List<String> tempHeures = secondPart.split(",");

          for (String uneHeure in tempHeures) {
            Map<String, String> resUneHeure = {};
            List<String> tempUneHeure = uneHeure.split("-");

            resUneHeure["debut"] = tempUneHeure[0];
            resUneHeure["fin"] =
                tempUneHeure.length > 1 ? tempUneHeure[1] : "00:00";

            truc["heures"].add(resUneHeure);
          }
        } else {
          truc["heures"].add({"debut": "00:00", "fin": "00:00"});
        }

        res.add(truc);
      }
    }

    return res;
  }

  static bool avisContinentResto(List<Commentaire> comms, String osmid) {
    for (var com in comms) {
      if (com.resto == osmid) {
        return false;
      }
    }
    return true;
  }
}
