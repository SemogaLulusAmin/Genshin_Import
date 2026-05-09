import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  // Singleton pattern
  static final UserState instance = UserState._internal();
  UserState._internal();

  int _money = 0;
  int _inventoryTrigger = 0;

  int get money => _money;
  int get inventoryTrigger => _inventoryTrigger;

  void setMoney(int amount) {
    _money = amount;
    notifyListeners();
  }

  void decreaseMoney(int amount) {
    if (_money >= amount) {
      _money -= amount;
      notifyListeners();
    }
  }

  void triggerInventoryRefresh() {
    _inventoryTrigger++;
    notifyListeners();
  }
}
