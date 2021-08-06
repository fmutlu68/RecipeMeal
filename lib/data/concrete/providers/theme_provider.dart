import 'package:flutter/material.dart';

import 'package:flutter_meal_app_update/data/concrete/managers/local_preferences_manager.dart';
import 'package:flutter_meal_app_update/mobileUi/themes/dark_theme.dart';
import 'package:flutter_meal_app_update/mobileUi/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = loadCurrentTheme();

  ThemeData get currentTheme => _currentTheme;

  bool get isDarkThemeActive => _currentTheme == lightTheme ? false : true;

  void changeTheme() {
    if (_currentTheme == darkTheme) {
      _currentTheme = lightTheme;
      LocalPreferencesManager.instance.setStringValue("Theme", "Light");
    } else {
      _currentTheme = darkTheme;
      LocalPreferencesManager.instance.setStringValue("Theme", "Dark");
    }
    notifyListeners();
  }

  static ThemeData loadCurrentTheme() {
    if (LocalPreferencesManager.instance.getValue("Theme") == "Light") {
      return lightTheme;
    }
    return darkTheme;
  }
}
