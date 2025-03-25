import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../viewModels/settingViewModel.dart';
import './mytheme.dart';
import 'package:go_router/go_router.dart';
import '../modele/utilisateur.dart';

class EcranSettings extends StatefulWidget {
  @override
  State<EcranSettings> createState() => _EcranSettingsState();
}

class _EcranSettingsState extends State<EcranSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paramètres")),
      body: Center(
        child: SettingsList(
          darkTheme: SettingsThemeData(
              settingsListBackground: MyTheme.dark().scaffoldBackgroundColor,
              settingsSectionBackground:
                  MyTheme.dark().scaffoldBackgroundColor),
          lightTheme: SettingsThemeData(
              settingsListBackground: MyTheme.light().scaffoldBackgroundColor,
              settingsSectionBackground:
                  MyTheme.light().scaffoldBackgroundColor),
          sections: [
            SettingsSection(title: const Text('Thème visuel'), tiles: [
              SettingsTile.switchTile(
                initialValue: context
                    .watch<SettingViewModel>()
                    .isDark, //Provider.of<SettingViewModel>(context).isDark,
                onToggle: (bool value) {
                  context.read<SettingViewModel>().isDark = value;
                }, //Provider.of<SettingViewModel>(context,listen:false).isDark=value;},
                title: const Text('Dark mode'),
                leading: const Icon(Icons.invert_colors),
              ),
            ]),
            SettingsSection(title: const Text('Utilisateur'), tiles: [
              SettingsTile.navigation(
                onPressed: (context) {
                  User.clearUser();
                  GoRouter.of(context).go(context.namedLocation('login'));
                },
                title: const Text("Changer de nom d'utilisateur"),
                leading: const Icon(Icons.person),
              ),
              SettingsTile.navigation(
                onPressed: (context) {
                  User.clearUser();
                  GoRouter.of(context).go(context.namedLocation('login'));
                },
                title: const Text('Déconexion'),
                leading: const Icon(Icons.logout),
              )
            ])
          ],
        ),
      ),
    );
  }
}
