import 'package:flutter/material.dart';
import '../API/api_bd.dart';
import '../modele/utilisateur.dart';
import "imageCommentaire.dart";

class GaleriePhotos extends StatefulWidget {
  final String restaurantId;

  const GaleriePhotos({super.key, required this.restaurantId});

  @override
  _GaleriePhotosState createState() => _GaleriePhotosState();
}

class _GaleriePhotosState extends State<GaleriePhotos> {
  late Future<List<Image>> futureImages;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() {
    setState(() {
      futureImages = BdAPI.getPhotosCommentairesResto(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Galerie Photos")),
      body: FutureBuilder<List<Image>>(
        // FutureBuilder pour charger les images
        future: futureImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune photo disponible"));
          }

          List<Image> images = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = (constraints.maxWidth / 150)
                    .floor(); // Ajuste selon la largeur
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount > 0
                        ? crossAxisCount
                        : 2, // Minimum 2 images par ligne
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: images[index],
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: images[index],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
