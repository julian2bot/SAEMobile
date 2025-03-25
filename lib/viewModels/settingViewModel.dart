import 'package:flutter/material.dart';
import '../repository/settingRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingViewModel extends ChangeNotifier {
  late bool _isDark;
  late SettingRepository _settingRepository;
  bool get isDark => _isDark;

  SettingViewModel (){
    _isDark = false;
    _settingRepository = SettingRepository();
    getSettings();
  }
//Switching the themes
  set isDark(bool value) {
    _isDark = value;
    _settingRepository.saveSettings(value);
    notifyListeners();
  }

  getSettings() async {
    _isDark = await _settingRepository.getSettings();
    notifyListeners();
  }
}
