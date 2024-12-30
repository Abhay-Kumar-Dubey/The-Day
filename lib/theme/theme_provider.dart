import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends StateNotifier<ThemeData> {
  ThemeProvider() : super(ThemeData.light()) {
    _loadTheme(); // Load the saved theme on initialization
  }

  static const String _themeKey = 'isDarkTheme';

  void toggleTheme() async {
    // Toggle between light and dark themes
    state = state == ThemeData.light() ? ThemeData.dark() : ThemeData.light();
    // Save the current theme
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, state == ThemeData.dark());
  }

  Future<void> _loadTheme() async {
    // Load the saved theme from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool(_themeKey) ?? false;
    state = isDarkTheme ? ThemeData.dark() : ThemeData.light();
  }
}

// Provider declaration
final themeProvider = StateNotifierProvider<ThemeProvider, ThemeData>(
  (ref) => ThemeProvider(),
);
