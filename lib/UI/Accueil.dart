import 'package:flutter/material.dart';

class Accueil extends StatelessWidget {
  final List<String> restaurants = ["Restaurant 1", "Restaurant 2", "Restaurant 3"];

  Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IUTABLES'O"),
        actions: [
          SearchAnchor(
              builder: (context, controller) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: (){
                    controller.openView();
                  },
                );
              },
              suggestionsBuilder: (context, controller){
                String query = controller.text.toLowerCase();
                List<String> filteredRestaurants = restaurants
                  .where((r) => r.toLowerCase().contains(query))
                  .toList();

                return filteredRestaurants.map((r) {
                  return ListTile(
                    title: Text(r),
                    onTap: () {
                      controller.closeView(r);
                  }
                  );
                });
              },
          )]
      ),
      body: const Center(
        child: Text("Accueil"),
      ),
    );
  }
}
