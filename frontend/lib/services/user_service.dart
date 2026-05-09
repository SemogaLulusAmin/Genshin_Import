import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/user_model.dart';

class UserService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      final String? token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        return {"success": false, "message": "No token found."};
      }

      final parts = token.split('.');
      if (parts.length != 3) {
        return {"success": false, "message": "Invalid JWT Token format."};
      }
      final String payload = parts[1];
      final String normalized = base64Url.normalize(payload);
      final String resp = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> decodedToken = json.decode(resp);

      final String? userID = decodedToken['id']?.toString(); 

      if (userID == null) {
        return {"success": false, "message": "Invalid Token Payload."};
      }

      final response = await http.get(
        Uri.parse("$baseUrl/auth/$userID"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        final userData = data['user'];
        
        if (userData != null) {
          var rawMoney = userData['money'];
          int freshMoney = 0;
          if (rawMoney != null) {
            freshMoney = num.parse(rawMoney.toString()).toInt();
          }

          await prefs.setString('money', freshMoney.toString());
          await prefs.setString('userID', userID); 

          return {
            "success": true,
            "user": userData,
            "money": freshMoney
          };
        }
      }

      
      return {"success": false, "message": "Server error: ${response.statusCode}"};

    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  static final StreamController<int> moneyStream = StreamController<int>.broadcast();

  // Fungsi untuk update manual tanpa hit API (Opsional tapi enak buat UX)
  static void updateLocalMoney(int newAmount) {
    moneyStream.add(newAmount);
  }

  Future<UserModel> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please login first.');
    }

    // TODO: Ganti endpoint sementara ini dengan endpoint backend yang final.
    // Contoh umum: /auth/me atau /users/me.
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);

      // TODO: Sesuaikan mapping ini jika backend mengembalikan payload berbeda.
      if (data is Map<String, dynamic> && data['user'] is Map<String, dynamic>) {
        return UserModel.fromJson(data['user'] as Map<String, dynamic>);
      }

      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }

      throw Exception('Unexpected user response format');
    }

    if (response.statusCode == 401) {
      throw Exception('Token is invalid or expired');
    }

    throw Exception('Failed to load current user');
  }
}
