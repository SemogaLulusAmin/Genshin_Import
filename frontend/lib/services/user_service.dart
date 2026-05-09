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

        if (userData is Map<String, dynamic>) {
          userData['id'] ??= userID;
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

      
      return {
        "success": false,
        "message": "Server error: ${response.statusCode}",
      };

    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  Future<UserModel> getCurrentUser() async {
    final result = await getUserData();
    if (result['success'] == true && result['user'] is Map<String, dynamic>) {
      return UserModel.fromJson(result['user'] as Map<String, dynamic>);
    }

    throw Exception(result['message']?.toString() ?? 'Failed to load user');
  }
}
