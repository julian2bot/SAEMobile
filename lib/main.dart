import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// import 'UI/restaurantDetaiL.dart';
// import 'UI/Accueil.dart';

import 'UI/mytheme.dart';
import 'router/router.dart';
import 'viewModels/settingViewModel.dart';
import 'modele/utilisateur.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_){
                SettingViewModel settingViewModel = SettingViewModel();
                //getSettings est deja appelee dans le constructeur
                return settingViewModel;
              }),
        ],
    child: Consumer<SettingViewModel>(
        builder: (context,SettingViewModel notifier,child){
        return MaterialApp.router(
          title: 'Flutter Demo',
          routerConfig: router,
          theme: notifier.isDark ? MyTheme.dark():MyTheme.light(),
        );
      },
    )
    );
  }
}