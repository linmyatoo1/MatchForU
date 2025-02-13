import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart'; // Import custom themes

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(bool isDarkMode) : _themeData = isDarkMode ? darkTheme : lightTheme;

  ThemeData get themeData => _themeData;

  void toggleTheme() async {
    _themeData = _themeData == lightTheme ? darkTheme : lightTheme;
    notifyListeners();

    // Save user preference in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeData == darkTheme);
  }
}
