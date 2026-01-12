import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart' show ChangeNotifierProvider;
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = ChangeNotifierProvider((ref) => ThemeProvider());

class ThemeProvider extends ChangeNotifier {
  static const String _keyIsDark = 'isDark';
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeProvider() {
    _loadFromPrefs();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners(); 
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDark, _isDark);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_keyIsDark) ?? false;
    notifyListeners();
  }
}