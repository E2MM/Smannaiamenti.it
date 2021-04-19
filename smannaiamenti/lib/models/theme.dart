import 'package:flutter/material.dart';

class Theme with ChangeNotifier {
  static ThemeMode _themeMode = ThemeMode.system;

  ThemeMode themeMode() {
    return _themeMode;
  }

  bool isDarkMode({Brightness? platformBrightness}) {
    return _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
