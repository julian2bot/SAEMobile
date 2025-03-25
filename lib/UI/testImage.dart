import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class GalerieImages extends StatefulWidget {
  const GalerieImages({super.key});

  @override
  _GalerieImagesState createState() => _GalerieImagesState();
}

class _GalerieImagesState extends State<GalerieImages> {
  late Future<List<Image>> imagesFuture;

  @override
  void initState() {
    super.initState();
    imagesFuture = fetchImages();
  }

// Fonction pour convertir une chaîne hexadécimale en Uint8List
// Uint8List hexToBytes(String hex) {
//   hex = hex.replaceAll(RegExp(r'\s+'), ''); // Enlever les espaces
//   if (hex.startsWith(r'\x')) {
//     hex = hex.substring(2); // Enlever le préfixe '\x'
//   }

//   final byteList = <int>[];
//   for (int i = 0; i < hex.length; i += 2) {
//     final byte = hex.substring(i, i + 2);
//     byteList.add(int.parse(byte, radix: 16));
//   }

//   return Uint8List.fromList(byteList);
// }
Uint8List hexToBytes(String hex) {
  final length = hex.length ~/ 2;
  final result = Uint8List(length);
  for (int i = 0; i < length; i++) {
    result[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return result;
}

  Future<List<Image>> fetchImages() async {
    final supabase = Supabase.instance.client;
    try {
      final data = await supabase.from('photo_avis').select('photocommentaire');
      print("🔍 Données brutes récupérées : $data");

      List<int> oids = [];
      for (var photo in data) {
        if (photo["photocommentaire"] != null) {
          if (photo["photocommentaire"] is int) {
            oids.add(photo["photocommentaire"]);
          } else if (photo["photocommentaire"] is String) {
            oids.add(int.parse(photo["photocommentaire"]));
          }
        }
      }

      print("✅ OIDs récupérés : $oids");

      List<Image> images = [];
      for (int oid in oids) {
        print("📸 Récupération de l'image pour OID $oid...");
        final response = await supabase.rpc('get_photo_by_oid', params: {'oid_value': oid});

        print("🔍 Réponse de la fonction get_photo_by_oid : $response");

        if (response != null && response is String) {
          print("✅ Image récupérée en hex : $response");

          Uint8List imageBytes = hexToBytes(response.substring(2));  // Retirer le préfixe \x

          print("Premier octet de l'image récupérée : ${imageBytes.sublist(0, 10)}");

          try {
            // Vérification que les premiers octets correspondent à un format d'image
            if (imageBytes.length > 4 && imageBytes[0] == 137 && imageBytes[1] == 80) {
              images.add(Image.memory(imageBytes, fit: BoxFit.cover));
              print("✅ Image récupérée et ajoutée !");
            } else {
              print("⚠️ Les données ne semblent pas être une image valide.");
            }
          } catch (e) {
            print("❌ Erreur lors de l'affichage de l'image : $e");
          }
        } else {
          print("⚠️ Aucune image récupérée pour OID $oid");
        }
      }

      return images;
    } catch (e) {
      print("❌ Erreur dans fetchImages : $e");
      return [];
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Galerie d'Images")),
      body: FutureBuilder<List<Image>>(
        future: imagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("⚠️ Aucune image trouvée"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return snapshot.data![index];
            },
          );
        },
      ),
    );
  }
}



