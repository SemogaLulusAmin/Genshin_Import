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
  bool _isAdmin = false;
  String? _errorMessage;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  bool get isBootstrapping => _isBootstrapping;
  bool get isAdmin => _isAdmin;
  String? get errorMessage => _errorMessage;
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
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
      _isAdmin = false;
      _isBootstrapping = false;
      notifyListeners();
      return;
    }

    try {
      _isAdmin = await _authService.isAdmin();
      _currentUser = await _userService.getCurrentUser();
      UserViewModel.instance.setMoney(_currentUser?.money ?? 0);
    } catch (e) {
      await _clearPersistedSession();
      _currentUser = null;
      _isAdmin = false;
      _errorMessage = e.toString();
    } finally {
      _isBootstrapping = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _clearAuthErrors();

    final trimmedEmail = email.trim();
    final isValid = _validateLoginFields(trimmedEmail, password);
    if (!isValid) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.login(trimmedEmail, password);

    _isLoading = false;
    if (result['success'] == true) {
      _currentUser = await _resolveUserFromResult(result);
      if (_currentUser == null) {
        _errorMessage = "Failed to load user session";
        notifyListeners();
        return false;
      }
      _isAdmin = await _authService.isAdmin();
      UserViewModel.instance.setMoney(_currentUser?.money ?? 0);
      notifyListeners();
      return true;
    }

    _errorMessage = result['message'];
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _clearAuthErrors();

    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final isValid = _validateRegisterFields(trimmedName, trimmedEmail, password);
    if (!isValid) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.register(
      trimmedName,
      trimmedEmail,
      password,
    );

    if (result['success'] != true) {
      _isLoading = false;
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }

    final loginResult = await _authService.login(trimmedEmail, password);

    _isLoading = false;
    if (loginResult['success'] == true) {
      _currentUser = await _resolveUserFromResult(loginResult);
      if (_currentUser == null) {
        _errorMessage = "Failed to load user session";
        notifyListeners();
        return false;
      }
      UserViewModel.instance.setMoney(_currentUser?.money ?? 0);
      notifyListeners();
      return true;
    }

    _errorMessage = loginResult['message'] ?? "Auto-login failed";
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
      _currentUser = await _resolveUserFromResult(result);
      if (_currentUser == null) {
        _errorMessage = "Failed to load user session";
        notifyListeners();
        return false;
      }
      UserViewModel.instance.setMoney(_currentUser?.money ?? 0);
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
    await UserViewModel.instance.reset();
    _currentUser = null;
    _isAdmin = false;
    _errorMessage = null;
    _clearAuthErrors();
    _isLoading = false;
    notifyListeners();
  }

  void clearErrorMessage() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  void clearNameError() {
    if (_nameError == null) return;

    _nameError = null;
    notifyListeners();
  }

  void clearEmailError() {
    if (_emailError == null) return;

    _emailError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    if (_passwordError == null) return;

    _passwordError = null;
    notifyListeners();
  }

  bool _validateLoginFields(String email, String password) {
    _nameError = null;
    _emailError = null;
    _passwordError = null;

    if (email.isEmpty) {
      _emailError = "Email is required";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      _emailError = "Please enter a valid email address";
    }

    if (password.isEmpty) {
      _passwordError = "Password is required";
    }

    return _emailError == null && _passwordError == null;
  }

  bool _validateRegisterFields(String name, String email, String password) {
    _nameError = null;
    _emailError = null;
    _passwordError = null;

    if (name.isEmpty) {
      _nameError = "Username is required";
    }

    if (email.isEmpty) {
      _emailError = "Email is required";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      _emailError = "Please enter a valid email address";
    }

    if (password.isEmpty) {
      _passwordError = "Password is required";
    }

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null;
  }

  Future<UserModel?> _resolveUserFromResult(Map<String, dynamic> result) async {
    final userJson = result['user'];
    if (userJson is Map<String, dynamic>) {
      return UserModel.fromJson(userJson);
    }

    try {
      return await _userService.getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  void _clearAuthErrors() {
    _errorMessage = null;
    _nameError = null;
    _emailError = null;
    _passwordError = null;
  }

  Future<void> _clearPersistedSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
