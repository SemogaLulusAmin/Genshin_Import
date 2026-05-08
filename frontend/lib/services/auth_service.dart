import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        final data = json.decode(response.body);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
        await prefs.setString('username', data['user']['username']);
        await prefs.setString('roles', data['user']['roles']);
        await prefs.setDouble('money', (data['user']['money'] ?? 0.0));

        return {"success": true, "token": data['token'], "user": data['user']};
      } else if (response.statusCode == 401) {
        return {"success": false, "message": "Wrong password"};
      } else if (response.statusCode == 404) {
        return {"success": false, "message": "User not found"};
      } else {
        final data = json.decode(response.body);

        return {"success": false, "message": data['message'] ?? "Login Failed"};
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

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "message": data['message']};
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Registration Failed",
        };
      }
    } catch (e) {
      return {"success": false, "message": "$e"};
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            "CLIENT_ID_DARI_GOOGLE_CLOUD_CONSOLE.apps.googleusercontent.com",
        scopes: ['email'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return {"success": false, "message": "Google Sign-In canceled"};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        return {
          "success": false,
          "message": "Failed to get ID token from Google",
        };
      }

      final response = await http.post(
        Uri.parse("$_baseUrl/google"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
        await prefs.setString('username', data['user']['username']);
        await prefs.setString('roles', data['user']['roles']);
        await prefs.setDouble('money', (data['user']['money'] ?? 0.0));

        return {"success": true, "token": data['token'], "user": data['user']};
      } else {
        final data = json.decode(response.body);
        return {
          "success": false,
          "message": data['message'] ?? "Google Sign-In Failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Failed to login via Google. Please check your connection.",
      };
    }
  }
}
