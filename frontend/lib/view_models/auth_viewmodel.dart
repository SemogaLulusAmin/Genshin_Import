import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel._internal();

  static final AuthViewModel instance = AuthViewModel._internal();

  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  Future<void> refresh() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles') ?? '';
    final newIsAdmin = roles.toLowerCase().contains('admin');
    if (newIsAdmin != _isAdmin) {
      _isAdmin = newIsAdmin;
      notifyListeners();
    }
  }

  void setAdmin(bool value) {
    if (value != _isAdmin) {
      _isAdmin = value;
      notifyListeners();
    }
  }
}
