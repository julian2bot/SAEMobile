import 'package:flutter/material.dart';

class ImageCommentaireDetail extends StatelessWidget {
  final AsyncSnapshot<List<Image>> snapshot;

  const ImageCommentaireDetail({
    super.key,
    required this.snapshot,
  });


@override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: snapshot.data!.map((image) {
        return GestureDetector(
          onTap: () {
            // pour afficher en plus grands
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(25.0), 
                    child: Image(image: image.image),
                  ),
                ),
              ),
            );
          },

          // pour afficher en petit
          child: SizedBox(
            width: 60, 
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: image, 
            ),
          ),
        );
      }).toList(),
    );    
  }
}