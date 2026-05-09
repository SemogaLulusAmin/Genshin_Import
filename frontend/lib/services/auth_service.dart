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
        await prefs.setString('jwt_token', data['token']);
        await prefs.setString('user_data', jsonEncode(data['user']));
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

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userDataString = prefs.getString('user_data');

      if (userDataString != null) {
        final userData = json.decode(userDataString);
        return {"success": true, "user": userData};
      }

      // Fallback to API call if no stored data
      final String? token = prefs.getString('jwt_token');
      if (token == null) {
        return null;
      }

      final response = await http.get(
        Uri.parse("$_baseUrl/me"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await prefs.setString('user_data', jsonEncode(data));
        return {"success": true, "user": data};
      } else {
        return {"success": false, "message": "Failed to get user info"};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }

  Future<bool> isAdmin() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        return false;
      }

      final parts = token.split('.');
      if (parts.length != 3) {
        return false;
      }

      final String payload = parts[1];
      final String normalized = base64Url.normalize(payload);
      final String decodedPayload = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> decodedToken = json.decode(decodedPayload);

      /// Support both `role` and `roles` claims.
      dynamic roleValue = decodedToken['role'] ?? decodedToken['roles'];
      if (roleValue == null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? storedUser = prefs.getString('user_data');
        if (storedUser != null) {
          final Map<String, dynamic> storedJson = json.decode(storedUser);
          roleValue = storedJson['role'] ?? storedJson['roles'];
        }
      }

      if (roleValue == null) {
        return false;
      }

      if (roleValue is String) {
        return roleValue.toLowerCase().contains('admin');
      }

      if (roleValue is Iterable) {
        return roleValue
            .map((item) => item?.toString().toLowerCase())
            .any((role) => role == 'admin');
      }

      return false;
    } catch (e) {
      return false;
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

