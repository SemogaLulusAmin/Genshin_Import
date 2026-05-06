import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/artifact_model.dart';

class InventoryService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<Artifact>> getInventory() async {
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
        return jsonResponse.map((data) => Artifact.fromJson(data)).toList();
       } else {
        throw Exception('Failed to load weapon inventory');
       }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
