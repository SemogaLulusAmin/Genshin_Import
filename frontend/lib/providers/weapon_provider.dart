import 'package:flutter/material.dart';
import '../models/weapon_model.dart';
import '../services/api_service.dart';

class WeaponProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<WeaponModel> _weapons = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<WeaponModel> get weapons => _weapons;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeapons() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _weapons = await _apiService.getAllWeapons();
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('Failed host lookup')) {
        _errorMessage = "Gagal terhubung ke server (cek Port 3000)";
      } else {
        _errorMessage = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
