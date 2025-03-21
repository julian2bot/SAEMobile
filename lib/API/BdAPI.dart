import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:csv/csv.dart';

class BdAPI {
  bool bdIsInit = false;

  Future<List<List<dynamic>>> loadCSV() async {
    final String rawData = await rootBundle.loadString('assets/pass.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);
    return csvTable;
  }

  Future<void> initBD() async {
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
  Future<bool> regionExists(String codeRegion) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('REGION')
        .select('coderegion')
        .eq('coderegion', codeRegion)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si un département existe
  Future<bool> departementExists(String codeDepartement) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('DEPARTEMENT')
        .select('codedepartement')
        .eq('codedepartement', codeDepartement)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si une commune existe
  Future<bool> communeExists(String codeCommune) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('COMMUNE')
        .select('codecommune')
        .eq('codecommune', codeCommune)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si un restaurant existe
  Future<bool> restaurantExists(String osmid) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('RESTAURANT')
        .select('osmid')
        .eq('osmid', osmid)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si une cuisine existe
  Future<int> getCuisineId(String nomCuisine) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('CUISINE')
        .select('idcuisine')
        .eq('nomcuisine', nomCuisine)
        .maybeSingle();
    return response!=null ? response['idcuisine'] : -1;
  }

  // Vérifie si un commentaire existe
  Future<bool> commentaireExists(String osmid, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('AVIS')
        .select('osmid')
        .eq('osmid', osmid)
        .eq('username', username)
        .maybeSingle();
    return response != null;
  }

  // Vérifie si un restaurant est dans les favoris
  Future<bool> estFavoris(String osmid, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('RESTAURANT_FAVORIS')
        .select('osmid')
        .eq('osmid', osmid)
        .eq('username', username)
        .maybeSingle();
    return response != null;
  }

  // Getters

  
  // Récupère une région par son code
  Future<List<Map<String, dynamic>>> getRegion(String codeRegion) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('REGION')
        .select()
        .eq('coderegion', codeRegion);
    return data;
  }

  // Récupère un département par son code
  Future<List<Map<String, dynamic>>> getDepartement(String codeDepartement) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('DEPARTEMENT')
        .select()
        .eq('codedepartement', codeDepartement);
    return data;
  }

  // Récupère une commune par son code
  Future<List<Map<String, dynamic>>> getCommune(String codeCommune) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('COMMUNE')
        .select()
        .eq('codecommune', codeCommune);
    return data;
  }

  // Récupère tous les restaurants
  Future<List<Map<String, dynamic>>> getResto() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase.from('RESTAURANT').select();
    return data;
  }

  // Récupère un restaurant par son ID
  Future<List<Map<String, dynamic>>> getRestaurantByID(String osmID) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('RESTAURANT')
        .select()
        .eq('osmid', osmID);
    if (data.isNotEmpty) {
      data[0]['cuisines'] = await getCuisinePropose(osmID);
    }
    return data;
  }

  // Récupère un restaurant par son nom
  Future<List<Map<String, dynamic>>> getRestaurantByName(String name) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('RESTAURANT')
        .select()
        .ilike('nomrestaurant', '%$name%');
    for (var resto in data) {
      resto['cuisines'] = await getCuisinePropose(resto['osmid']);
    }
    return data;
  }

  // Récupère l'ID de la prochaine cuisine
  Future<int> getNextCuisineID() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('CUISINE')
        .select('idcuisine')
        .order('idcuisine', ascending: false)
        .limit(1)
        .maybeSingle();
    return data != null ? (data['idcuisine'] as int) + 1 : 0;
  }

  // Récupère les cuisines proposées pour un restaurant
  Future<List<String>> getCuisinePropose(String osmID) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('PROPOSE')
        .select('nomcuisine')
        .eq('osmid', osmID);
    return data.map((e) => e['nomcuisine'] as String).toList();
  }

  // Récupère tous les types de restaurants
  Future<List<String>> getAllTypeResto() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase.from('RESTAURANT').select('DISTINCT(type)');
    return data.map((e) => e['type'] as String).toList();
  }

  // Récupère les restaurants par type
  Future<List<Map<String, dynamic>>> getRestoByType(List<String> types) async {
    await initBD();
    if (types.isEmpty) return [];
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('RESTAURANT')
        .select()
        .or(types.map((type) => "type.ilike.%$type%").join(','));
    return data;
  }

  // Récupère toutes les cuisines des restaurants
  Future<List<String>> getAllCuisinesResto() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase.from('CUISINE').select('DISTINCT(nomcuisine)');
    return data.map((e) => e['nomcuisine'] as String).toList();
  }

  // Récupère toutes les marques des restaurants
  Future<List<String>> getAllMarques() async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('RESTAURANT')
        .select('DISTINCT(marque)')
        .not('marque', 'is', null);
    return data.map((e) => e['marque'] as String).toList();
  }

  // Récupère les restaurants par marque
  Future<List<Map<String, dynamic>>> getRestoByMarque(String marque) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('RESTAURANT')
        .select()
        .ilike('marque', '%$marque%');
    return data;
  }

  // Récupère les restaurants par cuisine
  Future<List<List<Map<String, dynamic>>>> getRestoByCuisine(List<String> cuisines) async {
    await initBD();
    if (cuisines.isEmpty) return [];
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('PROPOSE')
        .select('osmid, count(osmid) as nb')
        .or(cuisines.map((cuisine) => "nomcuisine.ilike.%$cuisine%").join(','))
        // .groupBy('osmid')
        .order('nb', ascending: false);
    List<List<Map<String, dynamic>>> restos = [];
    for (var rest in data) {
      restos.add(await getRestaurantByID(rest['osmid']));
    }
    return restos;
  }

  // Récupère les restaurants par services
  Future<List<Map<String, dynamic>>> getRestoByServices(List<String> services) async {
    await initBD();
    if (services.isEmpty) return [];
    final supabase = Supabase.instance.client;
    final conditions = services.map((service) => "$service.not.is.null").toList();
    final data = await supabase
        .from('RESTAURANT')
        .select()
        .or(conditions.join(','));
    return data;
  }

  // Récupère les commentaires d'un restaurant
  Future<Map<String, dynamic>> getCommentairesResto(String osmID) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('AVIS')
        .select()
        .eq('osmid', osmID);
    if (data.isEmpty) {
      return {"noteMoy": 0, "commentaires": []};
    }
    double noteTotal = 0;
    int count = 0;
    for (var avis in data) {
      if (avis['note'] != null) {
        noteTotal += avis['note'];
        count++;
      }
    }
    double noteMoyenne = count > 0 ? noteTotal / count : 0;
    return {"noteMoy": noteMoyenne, "commentaires": data};
  }

  // Récupère les commentaires d'un utilisateur pour un restaurant
  Future<Map<String, dynamic>?> getCommentairesRestoUser(String osmID, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('AVIS')
        .select()
        .eq('osmid', osmID)
        .eq('username', username)
        .maybeSingle();
    return data;
  }

  // Récupère les avis d'un utilisateur
  Future<List<Map<String, dynamic>>> getMesAvis(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('AVIS')
        .select('*')
        .eq('username', username);
    return data;
  }

  // Récupère les recommandations pour un utilisateur
  Future<List<Map<String, dynamic>>> getMesRecommandations(String username, {int max = 10}) async {
    final favoris = await getLesFavoris(username);
    final avis = await getMesAvis(username);
    final supabase = Supabase.instance.client;
    final meilleursData = await supabase
        .from('AVIS')
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
      lesTypes[favResto['type']] = (lesTypes[favResto['type']] ?? 0) + 1;
      final cuisines = await getCuisinePropose(favResto['osmid']);
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
    final sortedCuisines = Map.fromEntries(lesCuisines.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    final sortedTypes = Map.fromEntries(lesTypes.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
    final topCuisines = sortedCuisines.keys.take(2).toList();
    final topTypes = sortedTypes.keys.take(2).toList();
    final lesCuisinesRestos = await getRestoByCuisine(topCuisines);
    final lesTypesRestos = await getRestoByType(topTypes);
    List<Map<String, dynamic>> lesRecos = [];
    int indexCuisines = 0;
    int indexTypes = 0;
    while (indexCuisines < max && indexCuisines < lesCuisinesRestos.length && lesRecos.length < max) {
      final resto = lesCuisinesRestos[indexCuisines];
      if (!avis.contains(resto) && !favoris.contains(resto) && !lesRecos.contains(resto)) {
        lesRecos.add(resto);
      }
      indexCuisines++;
    }
    while (indexTypes < max && indexTypes < lesTypesRestos.length && lesRecos.length < max) {
      final resto = lesTypesRestos[indexTypes];
      if (!avis.contains(resto) && !favoris.contains(resto) && !lesRecos.contains(resto)) {
        lesRecos.add(resto);
      }
      indexTypes++;
    }
    if (lesRecos.length < max) {
      final lesRestosLambda = await getResto();
      int indexLambda = 0;
      while (indexLambda < max && indexLambda < lesRestosLambda.length && lesRecos.length < max) {
        final resto = lesRestosLambda[indexLambda];
        if (!avis.contains(resto) && !favoris.contains(resto) && !lesRecos.contains(resto)) {
          lesRecos.add(resto);
        }
        indexLambda++;
      }
    }
    for (var reco in lesRecos) {
      if (!reco.containsKey('cuisines')) {
        reco['cuisines'] = await getCuisinePropose(reco['osmid']);
      }
    }
    return lesRecos;
  }

  // Recherche des restaurants par nom ou cuisine
  Future<Map<String, dynamic>> rechercheResto(String value) async {
    final cuis = await getRestoByCuisine([value]);
    final resto = await getRestaurantByName(value);
    final result = {
      'restos': [...cuis, ...resto],
      'user': '', // Remplacez par le nom d'utilisateur si connecté
      'favori': await getLesFavoris('') ?? [], // Remplacez par le nom d'utilisateur si connecté
    };
    return result;
  }

  // Récupère les images d'un restaurant
  Future<Map<String, dynamic>> getImagesResto(String osmid) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('RESTAURANT')
        .select('horizontal, vertical')
        .eq('osmid', osmid)
        .maybeSingle();
    if (data == []) {
      return {
        'vertical': [],
        'horizontal': [],
      };
    }
    return data;
  }

  // Récupère les favoris d'un utilisateur
  Future<List<Map<String, dynamic>>> getLesFavoris(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('RESTAURANT_FAVORIS')
        .select('*')
        .eq('username', username);
    return data;
  }

  // Insert

  // Créer une région si elle n'existe pas encore
  Future<bool> createRegion(String codeRegion, String nomRegion) async {
    await initBD();
    if (await regionExists(codeRegion)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('REGION')
        .insert({'coderegion': codeRegion, 'nomregion': nomRegion});
    return response.error == null;
  }

  // Créer un département si il n'existe pas encore
  Future<bool> createDepartement(String codeRegion, String codeDepartement, String nomDepartement) async {
    await initBD();
    if (await departementExists(codeDepartement)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('DEPARTEMENT')
        .insert({'coderegion': codeRegion, 'codedepartement': codeDepartement, 'nomdepartement': nomDepartement});
    return response.error == null;
  }

  // Créer une commune si elle n'existe pas encore
  Future<bool> createCommune(String codeDepartement, String codeCommune, String nomCommune) async {
    await initBD();
    if (await communeExists(codeCommune)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('COMMUNE')
        .insert({'codedepartement': codeDepartement, 'codecommune': codeCommune, 'nomcommune': nomCommune});
    return response.error == null;
  }

  // Crée un restaurant à partir d'une liste d'informations
  Future<bool> createRestaurant(List<dynamic> info) async {
    await initBD();
    if (info.length != 24 || await restaurantExists(info[0])) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('RESTAURANT')
        .insert(info.asMap().map((index, value) => MapEntry('col$index', value)));
    return response.error == null;
  }

  // Créer un type de cuisine s'il n'a pas été créé
  Future<int> createCuisine(String nomCuisine) async {
    await initBD();
    final idCuisine = await getCuisineId(nomCuisine);
    if (idCuisine != -1) {
      return idCuisine;
    }
    final supabase = Supabase.instance.client;
    final nextIdResponse = await supabase
        .from('CUISINE')
        .select('idcuisine')
        .order('idcuisine', ascending: false)
        .limit(1)
        .maybeSingle();
    final nextId = (nextIdResponse != null ? nextIdResponse['idcuisine'] : 0) + 1;
    final response = await supabase
        .from('CUISINE')
        .insert({'idcuisine': nextId, 'nomcuisine': nomCuisine});
    if (response.error != null) {
      return -1;
    }
    return nextId;
  }

  // Insert une proposition de cuisine pour un restaurant (Crée la cuisine si elle n'existe pas)
  Future<bool> insertCuisinePropose(String osmID, String nomCuisine) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final existingPropose = await supabase
        .from('PROPOSE')
        .select('idcuisine')
        .eq('osmid', osmID)
        .eq('nomcuisine', nomCuisine)
        .maybeSingle();
    if (existingPropose != null) {
      return false;
    }
    final idCuisine = await createCuisine(nomCuisine);
    final response = await supabase
        .from('PROPOSE')
        .insert({'idcuisine': idCuisine, 'osmid': osmID});
    return response.error == null;
  }

  // Insert les horaires d'ouvertures d'un restaurant
  Future<bool> insertHoraires(String osmID, String horaires) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final transformedHours = transformOpeningHours(horaires);
    for (var unHorraire in transformedHours) {
      for (var unJour in unHorraire["jours"]) {
        for (var unCrenau in unHorraire["heures"]) {
          final response = await supabase
              .from('HEURE_OUVERTURE')
              .insert({'osmid': osmID, 'jouroçuverture': unJour, 'heuredebut': unCrenau["debut"], 'heurefin': unCrenau["fin"]});
          if (response.error != null) {
            print("erreur resto : $osmID format : $horaires");
            return false;
          }
        }
      }
    }
    return true;
  }

  // Ajoute un commentaire d'un utilisateur pour un restaurant
  Future<bool> insertCommentaire(String osmID, String username, int note, String commentaire) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final date = DateTime.now().toIso8601String();
    final response = await supabase
        .from('AVIS')
        .insert({'osmid': osmID, 'username': username, 'note': note, 'commentaire': commentaire, 'datecommentaire': date});
    if (response.error != null) {
      print("erreur ${response.error}");
      return false;
    }
    return true;
  }

  // Ajoute ou retire un restaurant aux favoris de l'utilisateur
  Future<bool> ajouteRetirerFavoris(String osmID, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final isFavoris = await estFavoris(osmID, username);
    if (isFavoris) {
      final response = await supabase
          .from('RESTAURANT_FAVORIS')
          .delete()
          .eq('osmid', osmID)
          .eq('username', username);
      return response.error == null;
    } else {
      final response = await supabase
          .from('RESTAURANT_FAVORIS')
          .insert({'osmid': osmID, 'username': username});
      return response.error == null;
    }
  }

  // Delete

  // Supprime un commentaire d'un utilisateur sur un restaurant
  Future<bool> deleteCommentaireUser(String osmID, String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    if (!await commentaireExists(osmID, username)) {
      return false;
    }
    final response = await supabase
        .from('AVIS')
        .delete()
        .eq('osmid', osmID)
        .eq('username', username);
    return response.error == null;
  }

  // Update

  // Ajoute des images à un restaurant par son ID
  Future<bool> addImageRestaurantById(String osmid, String imageH, String imageV) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('RESTAURANT')
        .update({'horizontal': imageH, 'vertical': imageV})
        .eq('osmid', osmid);
    return response.error == null;
  }

  // Modifie un commentaire existant
  Future<bool> updateCommentaire(String osmid, String username, String commentaire, int etoiles) async {
    await initBD();
    final supabase = Supabase.instance.client;
    if (!await commentaireExists(osmid, username)) {
      return false;
    }
    final response = await supabase
        .from('AVIS')
        .update({'commentaire': commentaire, 'note': etoiles})
        .eq('osmid', osmid)
        .eq('username', username);
    return response.error == null;
  }

  // User Management

  // Vérifie si un utilisateur existe
  Future<bool> usernameExists(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('UTILISATEUR')
        .select('username')
        .eq('username', username)
        .maybeSingle();
    return response != null;
  }

  // Récupère les informations d'un utilisateur
  Future<Map<String, dynamic>?> getUser(String username) async {
    await initBD();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('UTILISATEUR')
        .select('*')
        .eq('username', username)
        .maybeSingle();
    return response;
  }

  // Connecte un utilisateur (met les infos dans une session)
  Future<void> userConnecter(String username) async {
    await initBD();
    final userInfo = await getUser(username);
    if (userInfo != null) {
      // Simuler une session avec une map
      final session = {
        "connecte": {
          "username": userInfo['username'],
          "admin": userInfo['estadmin'] ? "true" : "false",
        }
      };
      // Vous pouvez stocker cette session dans un état global ou un gestionnaire de session
      print(session);
    }
  }

  // Vérifie si un utilisateur est administrateur
  Future<bool> isAdmin(String username) async {
    final userInfo = await getUser(username);
    return userInfo?['estadmin'] == true;
  }

  // Ajoute un utilisateur à la base de données
  Future<bool> createUser(String username, String mdp, bool isAdmin) async {
    await initBD();
    if (await usernameExists(username)) {
      return false;
    }
    final hashedPassword = hashPassword(mdp);
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('UTILISATEUR')
        .insert({'username': username, 'mdp': hashedPassword, 'estadmin': isAdmin});
    return response.error == null;
  }

  // Vérifie si la connexion est autorisée pour un username et un mdp
  Future<bool> canLogin(String username, String mdp) async {
    await initBD();
    final hashedPassword = hashPassword(mdp);
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('UTILISATEUR')
        .select('*')
        .eq('username', username)
        .eq('mdp', hashedPassword)
        .maybeSingle();
    return response != null;
  }

  // Supprime un utilisateur
  Future<bool> deleteUser(String username) async {
    await initBD();
    if (!await usernameExists(username)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('UTILISATEUR')
        .delete()
        .eq('username', username);
    return response.error == null;
  }

  // Met à jour les informations d'un utilisateur
  Future<bool> updateUser(String usernameBefore, String newUsername, String mdp, bool isAdmin) async {
    await initBD();
    if (usernameBefore != newUsername && await usernameExists(newUsername)) {
      return false;
    }
    final hashedPassword = hashPassword(mdp);
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('UTILISATEUR')
        .update({'username': newUsername, 'mdp': hashedPassword, 'estadmin': isAdmin})
        .eq('username', usernameBefore);
    return response.error == null;
  }

  // Met à jour le nom d'utilisateur
  Future<bool> updateNameUser(String usernameBefore, String newUsername) async {
    await initBD();
    if (usernameBefore != newUsername && await usernameExists(newUsername)) {
      return false;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('UTILISATEUR')
        .update({'username': newUsername})
        .eq('username', usernameBefore);
    if (response.error == null) {
      await userConnecter(newUsername);
      return true;
    }
    return false;
  }

  // Fonction utilitaire pour hacher le mot de passe
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  List<String> getAllDays(String firstDay, String lastDay) {
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

  List<Map<String, dynamic>> transformOpeningHours(String opening) {
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
            resUneHeure["fin"] = tempUneHeure.length > 1 ? tempUneHeure[1] : "00:00";

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



}
