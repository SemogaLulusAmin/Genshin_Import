import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel._internal();

  static final UserViewModel instance = UserViewModel._internal();

  final UserService _userService = UserService();

  int _money = 0;
  int _inventoryRefreshKey = 0;
  bool _isMoneyLoading = false;

  int get money => _money;
  int get inventoryRefreshKey => _inventoryRefreshKey;
  bool get isMoneyLoading => _isMoneyLoading;

  Future<void> loadCachedMoney() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedMoney = num.tryParse(prefs.getString('money') ?? '0') ?? 0;
    _money = cachedMoney.toInt();
    notifyListeners();
  }

  Future<void> refreshMoney({bool showLoading = true}) async {
    if (_isMoneyLoading) return;

    if (showLoading) {
      _isMoneyLoading = true;
      notifyListeners();
    }

    final result = await _userService.getUserData();

    if (result['success'] == true && result['money'] != null) {
      _money = (num.tryParse(result['money'].toString()) ?? 0).toInt();
    }

    _isMoneyLoading = false;
    notifyListeners();
  }

  void setMoney(num amount) {
    _money = amount.toInt();
    notifyListeners();
  }

  void decreaseMoney(num amount) {
    final value = amount.toInt();
    if (_money < value) return;

    _money -= value;
    notifyListeners();
  }

  void triggerInventoryRefresh() {
    _inventoryRefreshKey++;
    notifyListeners();
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('money');
    await prefs.remove('userID');

    _money = 0;
    _inventoryRefreshKey = 0;
    _isMoneyLoading = false;
    notifyListeners();
  }
}
