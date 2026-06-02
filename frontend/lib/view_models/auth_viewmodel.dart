import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/view_models/user_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel._internal();
  static final AuthViewModel instance = AuthViewModel._internal();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _isLoading = false;
  bool _isBootstrapping = false;
  String? _errorMessage;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  UserModel? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  bool get isBootstrapping => _isBootstrapping;
  String? get errorMessage => _errorMessage;
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // --- UI State Management Methods ---
  void clearNameError() {
    if (_nameError != null) {
      _nameError = null;
      notifyListeners();
    }
  }

  void clearEmailError() {
    if (_emailError != null) {
      _emailError = null;
      notifyListeners();
    }
  }

  void clearPasswordError() {
    if (_passwordError != null) {
      _passwordError = null;
      notifyListeners();
    }
  }

  void clearErrorMessage() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // --- Session Management ---
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
      if (_currentUser != null) {
        _syncUserDataToView();
      }
    } catch (e) {
      await _clearPersistedSession();
      _currentUser = null;
    } finally {
      _isBootstrapping = false;
      notifyListeners();
    }
  }

  // --- Login & Registration ---
  Future<bool> login(String email, String password) async {
    _clearAuthErrors();
    final trimmedEmail = email.trim();
    if (!_validateLoginFields(trimmedEmail, password)) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(trimmedEmail, password);
    _isLoading = false;

    if (result['success'] == true) {
      _currentUser = await _resolveUserFromResult(result);
      if (_currentUser != null) {
        _syncUserDataToView();
        notifyListeners();
        return true;
      }
    }
    _errorMessage = result['message'];
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _clearAuthErrors();
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    if (!_validateRegisterFields(trimmedName, trimmedEmail, password)) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(
      trimmedName,
      trimmedEmail,
      password,
    );
    if (result['success'] != true) {
      if (result['message'] !=
          'Failed to register. Please check your connection.') {
        _isLoading = false;
        _errorMessage =
            'This email is already registered. Please use a different email or log in to your account.';
        notifyListeners();
        return false;
      }
      _isLoading = false;
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }

    // Auto-login after registration
    final loginResult = await _authService.login(trimmedEmail, password);
    _isLoading = false;
    if (loginResult['success'] == true) {
      _currentUser = await _resolveUserFromResult(loginResult);
      if (_currentUser != null) {
        _syncUserDataToView();
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // --- RESTORED: Google Login ---
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.loginWithGoogle();
    _isLoading = false;

    if (result['success'] == true) {
      _currentUser = await _resolveUserFromResult(result);
      if (_currentUser != null) {
        _syncUserDataToView();
        notifyListeners();
        return true;
      }
    }

    _errorMessage = result['message'] ?? "Google login failed";
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _clearPersistedSession();
    await UserViewModel.instance.reset();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  // --- Internal Helpers ---

  /// Helper to push user role and money into the UserViewModel
  void _syncUserDataToView() {
    if (_currentUser == null) return;
    UserViewModel.instance.setMoney(_currentUser!.money);
    UserViewModel.instance.setRole(_currentUser!.roles);
  }

  Future<UserModel?> _resolveUserFromResult(Map<String, dynamic> result) async {
    final userJson = result['user'];
    if (userJson is Map<String, dynamic>) return UserModel.fromJson(userJson);
    try {
      return await _userService.getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  bool _validateLoginFields(String email, String password) {
    if (email.isEmpty)
      _emailError = "Email is required";
    else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email))
      _emailError = "Invalid email";
    if (password.isEmpty) _passwordError = "Password is required";
    return _emailError == null && _passwordError == null;
  }

  bool _validateRegisterFields(String name, String email, String password) {
    if (name.isEmpty) _nameError = "Username is required";
    if (email.isEmpty) _emailError = "Email is required";
    if (password.isEmpty) _passwordError = "Password is required";
    return _nameError == null && _emailError == null && _passwordError == null;
  }

  void _clearAuthErrors() {
    _errorMessage = _nameError = _emailError = _passwordError = null;
  }

  Future<void> _clearPersistedSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
