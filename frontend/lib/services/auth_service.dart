import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authservice {
  // final String _baseUrl = Platform.isAndroid
  //     ? "http://10.0.2.2:3000/auth"
  //     : "http://localhost:3000/auth";

  final String _baseUrl = "http://localhost:3000/auth";

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = json.decode(response.body);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', data['token']);
      await prefs.setString('username', data['user']['username']);
      await prefs.setString('email', data['user']['money']);
      await prefs.setString('email', data['user']['roles']);

      if (response.statusCode == 200) {
        return {"success": true, "token": data['token'], "user": data['user']};
      } else if (response.statusCode == 401) {
        return {
          "success": false,
          "message": "message: ${data['message'] ?? "Wrong password"}",
        };
      } else if (response.statusCode == 404) {
        return {
          "success": false,
          "message": "message: ${data['message'] ?? "User not found"}",
        };
      } else {
        return {
          "success": false,
          "message": "message: ${data['message'] ?? "Login Failed"}",
        };
      }
    } catch (e) {
      return {"success": false, "message": "message: $e"};
    }
  }
}
