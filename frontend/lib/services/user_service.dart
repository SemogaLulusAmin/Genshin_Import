import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/user_model.dart';

class UserService {
  String get _baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000/users";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:3000/users";
    } else {
      return "http://localhost:3000/users";
    }
  }

  Future<User> getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        throw Exception("No token found. Please log in again.");
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final String? userID = decodedToken['id']?.toString();

      if (userID == null) {
        throw Exception("Invalid Token Payload.");
      }

      final response = await http.get(
        Uri.parse("$_baseUrl/auth/$userID"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Asumsi response BE: { "user": { "money": "50000.00", ... } }
        final userData = data['user'];

        if (userData != null) {
          // Parse JSON ke User object (money dikonversi di dalam factory .fromJson)
          User user = User.fromJson(userData);

          // Simpan ke cache biar UI bisa akses cepet
          await prefs.setString('money', user.money.toString());
          await prefs.setString(
            'userID',
            user.id,
          ); // Simpan ID-nya juga sekalian

          return user;
        } else {
          throw Exception("User data is empty.");
        }
      }

      throw Exception("Server error: ${response.statusCode}");
    } catch (e) {
      print('UserService Error: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  static final StreamController<int> moneyStream =
      StreamController<int>.broadcast();

  // Fungsi untuk update manual tanpa hit API (Opsional tapi enak buat UX)
  static void updateLocalMoney(int newAmount) {
    moneyStream.add(newAmount);
  }
}
