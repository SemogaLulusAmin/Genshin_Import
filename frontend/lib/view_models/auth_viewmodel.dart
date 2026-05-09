import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel._internal();

  static final AuthViewModel instance = AuthViewModel._internal();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _isLoading = false;
  bool _isBootstrapping = false;
  String? _errorMessage;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  bool get isBootstrapping => _isBootstrapping;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> bootstrapSession() async {
    _isBootstrapping = true;
    _errorMessage = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null || token.isEmpty) {
      _currentUser = null;
      _isBootstrapping = false;
      notifyListeners();
      return;
    }

    try {
      _currentUser = await _userService.getCurrentUser();
    } catch (e) {
      await _clearPersistedSession();
      _currentUser = null;
      _errorMessage = e.toString();
    } finally {
      _isBootstrapping = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    clearErrorMessage();

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Email and password are required";
      notifyListeners();
      return false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _errorMessage = "Please enter a valid email address";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.login(email, password);

    _isLoading = false;
    if (result['success'] == true) {
      final userJson = result['user'];
      if (userJson is Map<String, dynamic>) {
        _currentUser = UserModel.fromJson(userJson);
      }
      notifyListeners();
      return true;
    }

    _errorMessage = result['message'];
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    clearErrorMessage();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = "Name, email, and password are required";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.register(name, email, password);

    _isLoading = false;
    if (result['success'] == true) {
      notifyListeners();
      return true;
    }

    _errorMessage = result['message'];
    notifyListeners();
    return false;
  }

  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // TODO: Verify Google Sign-In configuration end-to-end for each platform.
    final result = await _authService.loginWithGoogle();

    _isLoading = false;
    if (result['success'] == true) {
      final userJson = result['user'];
      if (userJson is Map<String, dynamic>) {
        _currentUser = UserModel.fromJson(userJson);
      }
      notifyListeners();
      return true;
    }

    _errorMessage = result['message'];
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _clearPersistedSession();
    _currentUser = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _clearPersistedSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
