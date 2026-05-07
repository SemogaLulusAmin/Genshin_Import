import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class Userservice {
  String get _baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000/users";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:3000/users";
    } else {
      return "http://localhost:3000/users";
    }
  }

  // TODO : Wait for API get profile user to fetch user data from database
  // Future<User> fetchUserProfile(String token) async {
  //   final response = await http.get(
  //     Uri.parse('$_baseUrl/profile'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     return User.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load user profile');
  //   }
  // }

  // TODO : Wait for API get user to fetch user data from database
  // Future<User> getUser(String userId) async {
  //   final response = await http.get(Uri.parse('$_baseUrl/$userId'));

  //   if (response.statusCode == 200) {
  //     return User.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load user');
  //   }
  // }

  // Future<List<User>> getAllUsers() async {
  //   final response = await http.get(Uri.parse(_baseUrl));

  //   if (response.statusCode == 200) {
  //     List<dynamic> usersJson = jsonDecode(response.body);
  //     return usersJson.map((json) => User.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }
}
