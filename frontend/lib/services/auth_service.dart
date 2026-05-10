import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  String get _baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000/auth";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:3000/auth";
    } else {
      return "http://localhost:3000/auth";
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = _decodeJsonBody(response.body);
        final token = data['token']?.toString();

        if (token == null || token.isEmpty) {
          return {"success": false, "message": "Login response is invalid"};
        }

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        final user = data['user'];
        if (user is Map<String, dynamic>) {
          user['email'] ??= email;
        }

        return {"success": true, "token": token, "user": user};
      } else if (response.statusCode == 401) {
        return {"success": false, "message": "Wrong password"};
      } else if (response.statusCode == 404) {
        return {"success": false, "message": "User not found"};
      } else {
        final data = _decodeJsonBody(response.body);

        return {
          "success": false,
          "message": data['message']?.toString() ?? "Login Failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Failed to login. Please check your connection.",
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      final data = _decodeJsonBody(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": data['message']?.toString() ?? "Registration Success",
        };
      } else {
        return {
          "success": false,
          "message": data['message']?.toString() ?? "Registration Failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Failed to register. Please check your connection.",
      };
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    // TODO: Implementasikan ulang Google Sign-In setelah konfigurasi client ID
    // dan endpoint backend final sudah siap untuk semua platform.
    return {
      "success": false,
      "message":
          "Google Sign-In belum dikonfigurasi untuk arsitektur MVVM ini.",
    };
  }

  Map<String, dynamic> _decodeJsonBody(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{};
  }
}
