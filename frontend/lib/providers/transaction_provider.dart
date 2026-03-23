import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  final String baseUrl = ApiService().baseUrl;

  Future<String> buyWeapon(
    String userId,
    String weaponId,
    int quantity,
    String token,
  ) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/transactions/weapon"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userID': userId,
          'weaponID': weaponId,
          'stock': quantity,
        }),
      );

      _isProcessing = false;
      notifyListeners();

      if (response.statusCode == 201) {
        return "Pembelian Berhasil!";
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? "Gagal melakukan pembelian";
      }
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      if (e.toString().contains('Connection refused') || e.toString().contains('Failed host lookup')) {
        return "Gagal terhubung ke server (cek Port 3000)";
      }
      return "Terjadi kesalahan koneksi";
    }
  }
}
