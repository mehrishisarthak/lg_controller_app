import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyIsDark = 'isDark';


  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDark, isDark);
  }

  static Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDark) ?? false;
  }
  
}