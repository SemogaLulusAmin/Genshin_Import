import 'dart:convert';
import 'dart:typed_data' as typed_data;
import 'package:frontend/core/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../models/artifact_model.dart';

class ArtifactService {
  static String get serverUrl => ApiConfig.baseUrl;
  static String get apiBaseUrl => '$serverUrl/artifact';

  Future<String> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');
    if (token == null) throw Exception('No token found. Please login first.');
    return token;
  }

  Future<List<Artifact>> getArtifacts() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(apiBaseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        
        return jsonResponse.map((data) {
          if (data['image_url'] != null && !data['image_url'].startsWith('http')) {
            data['image_url'] = '$serverUrl${data['image_url']}';
          }
          return Artifact.fromJson(data);
        }).toList();
      } else {
        throw Exception('Failed to load artifacts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Artifact?> getArtifactById(String artifactId) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$apiBaseUrl/$artifactId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['image_url'] != null && !data['image_url'].startsWith('http')) {
          data['image_url'] = '$serverUrl${data['image_url']}';
        }
        return Artifact.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load artifact');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> createArtifact(Map<String, String> fields, XFile imageFile) async {
    try {
      final token = await _getToken();
      var request = http.MultipartRequest('POST', Uri.parse(apiBaseUrl));
      request.headers['Authorization'] = 'Bearer $token';
      
      request.fields.addAll(fields);

      final typed_data.Uint8List bytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image', 
          bytes,
          filename: imageFile.name,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create artifact');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> purchaseArtifact(String artifactId, int quantity) async {
      try {
        final token = await _getToken();
        final response = await http.post(
          Uri.parse('$serverUrl/userArtifact/buy/$artifactId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({'quantity': quantity}),
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          final error = json.decode(response.body);
          throw Exception(error['message'] ?? 'Failed to purchase artifact');
        }
      } catch (e) {
        throw Exception('Network error: $e');
      }
    }

    Future<bool> updateArtifact(String artifactID, Map<String, String> fields, {XFile? imageFile}) async {
    final token = await _getToken();
    var request = http.MultipartRequest('PUT', Uri.parse('$apiBaseUrl/$artifactID'));
    request.headers['Authorization'] = 'Bearer $token';
    
    request.fields.addAll(fields);

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: imageFile.name));
    }

    var response = await http.Response.fromStream(await request.send());
    return response.statusCode == 200;
  }

  Future<bool> deleteArtifact(String artifactID) async {
    try {
      final token = await _getToken();
      
      final response = await http.delete(
        Uri.parse('$apiBaseUrl/$artifactID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete artifact');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
