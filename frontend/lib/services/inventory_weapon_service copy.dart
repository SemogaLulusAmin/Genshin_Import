import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weapon_model.dart';

class InventoryService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<Weapon>> getInventory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/userWeapon?status=purchased'),
        headers: {'Authorization': 'Bearer $token'},
      );

       if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Weapon.fromJson(data)).toList();
       } else {
        throw Exception('Failed to load weapon inventory');
       }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
