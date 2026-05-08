import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  final String baseUrl = 'http://localhost:3000';

  Future<Map<String, dynamic>> getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      final String? token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        return {"success": false, "message": "No token found."};
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
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
}
