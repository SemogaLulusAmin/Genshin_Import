import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class ThemeManager extends ValueNotifier<bool> {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;

  ThemeManager._internal() : super(false) {
    _loadTheme(); 
  }

  void toggleTheme() async {
    value = !value; 
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', value);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getBool('is_dark_mode') ?? false;
  }
}