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

  Future<UserModel> getUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
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
