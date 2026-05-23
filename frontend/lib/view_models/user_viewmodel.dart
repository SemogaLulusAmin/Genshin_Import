import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel._internal();
  static final UserViewModel instance = UserViewModel._internal();

  final UserService _userService = UserService();

  int _money = 0;
  String _role = 'user'; 
  int _inventoryRefreshKey = 0;
  bool _isMoneyLoading = false;
  int _profileRefreshKey = 0;

  String _username = '';
  bool _isEditProfileLoading = false;
  String? _editProfileError;

  int get money => _money;
  String get role => _role;
  bool get isAdmin => _role.toLowerCase() == 'admin';
  int get inventoryRefreshKey => _inventoryRefreshKey;
  bool get isMoneyLoading => _isMoneyLoading;
  int get profileRefreshKey => _profileRefreshKey;
  String get username => _username;

  void setRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }

  void setMoney(num amount) {
    _money = amount.toInt();
    notifyListeners();
  }

  void setUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  Future<void> refreshMoney({bool showLoading = true}) async {
    if (_isMoneyLoading) return;

    if (showLoading) {
      _isMoneyLoading = true;
      notifyListeners();
    }

    try {
      final result = await _userService.getUserData();
      if (result['success'] == true) {
        if (result['money'] != null) {
          _money = (num.tryParse(result['money'].toString()) ?? 0).toInt();
        }
        if (result['roles'] != null) {
          _role = result['roles'].toString();
        }
      }
    } catch (e) {
      debugPrint("Error refreshing money: $e");
    } finally {
      _isMoneyLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCachedMoney() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedMoney = num.tryParse(prefs.getString('money') ?? '0') ?? 0;
    _money = cachedMoney.toInt();
    notifyListeners();
  }

  void decreaseMoney(num amount) {
    final value = amount.toInt();
    if (_money < value) return;
    _money -= value;
    notifyListeners();
  }

  Future<void> refreshUsername() async {
    try {
      final result = await _userService.getUserData();
      
      if (result['success'] == true && result['username'] != null) {
        _username = result['username'].toString();
      }
    } catch (e) {
      debugPrint("Error refreshing username: $e");
    } finally {
      notifyListeners(); 
    }
  }

  void triggerInventoryRefresh() {
    _inventoryRefreshKey++;
    notifyListeners();
  }

  void triggerProfileRefresh() {
    _profileRefreshKey++;
    notifyListeners();
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('money');
    _money = 0;
    _role = 'user';
    _inventoryRefreshKey = 0;
    _isMoneyLoading = false;
    notifyListeners();
  }

  Future<bool> editProfile(String newUsername) async {
    _isEditProfileLoading = true;
    _editProfileError = null;
    notifyListeners(); 

    try {
      
      final result = await UserService().editProfile(newUsername);

      if (result['success'] == true) {

        _username = newUsername;
        
        if (result['user'] != null && result['user']['money'] != null) {
          _money = num.parse(result['user']['money'].toString()).toInt();
        }

        _isEditProfileLoading = false;
        notifyListeners(); 
        return true;
      } else {
        
        _editProfileError = result['message'] ?? "Failed to update username";
        _isEditProfileLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _editProfileError = "An error occured: $e";
      _isEditProfileLoading = false;
      notifyListeners();
      return false;
    }
  }
}