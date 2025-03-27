import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../viewModels/settingViewModel.dart';
import './mytheme.dart';
import '../modele/utilisateur.dart';
import '../API/api_bd.dart';
import '../UI/popUp.dart';

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
                  GoRouter.of(context).go(context.namedLocation('user'));
                },
                title: const Text("Changer de nom d'utilisateur"),
                leading: const Icon(Icons.person),
              ),
              SettingsTile.navigation(
                onPressed: (context) {
                  User.clearUser();
                  GoRouter.of(context).go(context.namedLocation('homepage'));
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

class FormUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(title: Text("Nom d'utilisateur")),
      body: FutureBuilder(
        future: User.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Erreur de chargement"));
          }

          final username = snapshot.data!.userName;

          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: Center(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    spacing: 20,
                    children: [
                      FormBuilderTextField(
                        name: 'username',
                        decoration: const InputDecoration(
                            labelText: "Nom d'utilisateur"),
                        initialValue: username,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.saveAndValidate();
                          debugPrint(_formKey.currentState?.value.toString());
                          String newUsername =
                              (_formKey.currentState?.value["username"]);
                          bool result =
                              await BdAPI.updateNameUser(username, newUsername);
                          showPopUp(
                              context,
                              result
                                  ? "Modification réussi"
                                  : "Un utilisateur avec ce nom existe déjà",
                              result);

                          if (result) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Modifier le nom d'utilisateur"),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
