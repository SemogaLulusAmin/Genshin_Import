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

  Future<Artifact?> getArtifactById(String artifactId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/$artifactId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Artifact.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load artifact');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> purchaseArtifact(String artifactId, int quantity) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/userArtifact/buy/$artifactId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to purchase artifact: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> createArtifact(Map<String, dynamic> artifactData, {String? imagePath}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      if (imagePath != null && imagePath.isNotEmpty) {
        final request = http.MultipartRequest('POST', Uri.parse(baseUrl));
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(artifactData.map((key, value) => MapEntry(key, value?.toString() ?? '')));
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        return response.statusCode == 200;
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(artifactData),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateArtifact(String artifactId, Map<String, dynamic> artifactData, {String? imagePath}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      if (imagePath != null && imagePath.isNotEmpty) {
        final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$artifactId'));
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(artifactData.map((key, value) => MapEntry(key, value?.toString() ?? '')));
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        return response.statusCode == 200;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/$artifactId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(artifactData),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteArtifact(String artifactId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/$artifactId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
