import 'package:flutter/material.dart';
import 'package:second_app_td2/UI/mytheme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../modele/restaurant.dart';
import '../modele/utilisateur.dart';
import '../viewModels/settingViewModel.dart';
import 'package:provider/provider.dart';
import '../API/api_bd.dart';

class UneCuisine extends StatefulWidget{
  bool estFavoris;
  final String uneCuisine;
  
  UneCuisine({
    super.key,
    required this.uneCuisine,
    this.estFavoris = false,
  });


  @override
  _ElemCuisine createState() => _ElemCuisine();
}

class _ElemCuisine extends State<UneCuisine> {
  late bool _isFavoris;

  
  void _MettreFavoris() async {
    String? username = await User.getUserName();
    if (username != null) {
      await BdAPI.ajouteRetirerCuisinePref(widget.uneCuisine, username);
      setState(() {
        _isFavoris = !_isFavoris; // Bascule l'état
      });
    }
  }


  @override
  void initState() {
    super.initState();
    // _loadState();
    _isFavoris = widget.estFavoris;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
            color: _isFavoris ? (context.watch<SettingViewModel>().isDark ? MyTheme.colDark : MyTheme.colLight) : Colors.white, 

            child: InkWell(
              onTap: () async {
                // String? username = await User.getUserName();
                _MettreFavoris();
                // BdAPI.ajouteRetirerCuisinePref(widget.uneCuisine, username!);
                print("cuisine: ${widget.uneCuisine} ajouter/ retirer des favoris");
                
              },
              child: Container(
                height: 100.0,
                child: Center(child: 
                  Text(widget.uneCuisine,
                    style: 
                      TextStyle(
                        color: _isFavoris ? Colors.white : Colors.black,
                        ),
                  )
                ),
              ),
            ),
          );
  }
}