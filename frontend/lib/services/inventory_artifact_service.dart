import 'dart:convert';
import 'package:frontend/core/api_config.dart';
import 'package:frontend/models/artifact_inventory_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventoryArtifactService {
  static String get baseUrl => ApiConfig.baseUrl;

  Future<List<InventoryArtifact>> getInventory() async { 
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/userArtifact?status=purchased'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => InventoryArtifact.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load artifact inventory');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
