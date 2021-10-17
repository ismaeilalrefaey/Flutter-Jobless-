//@dart=2.9
import 'package:flutter/material.dart';

class ChangeTheme with ChangeNotifier {
  static bool _isDark = false;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get themeMode => _isDark;

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
