import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/artifact_model.dart';

class ArtifactService {
  // static const String baseUrl = 'http://10.0.2.2:3000';
  static const String baseUrl = 'http://localhost:3000/artifact';

  Future<List<Artifact>> getArtifacts() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Artifact.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load artifacts');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
