import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weapon_model.dart';
import '../models/artifact_model.dart';
import '../models/user_inventory_model.dart';

class InventoryService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<UserInventoryItem>> getInventory() async {
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
        final List data = json.decode(response.body);

        return data.map((jsonItem) {
          final parsed = UserInventoryItem.fromJson(jsonItem);

          /// 🔥 CONVERT dynamic → real model
          if (parsed.type == 'weapon') {
            return UserInventoryItem(
              id: parsed.id,
              quantity: parsed.quantity,
              type: parsed.type,
              item: Weapon.fromJson(parsed.item),
            );
          } else {
            return UserInventoryItem(
              id: parsed.id,
              quantity: parsed.quantity,
              type: parsed.type,
              item: Artifact.fromJson(parsed.item),
            );
          }
        }).toList();
      } else {
        throw Exception('Failed to load inventory');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
