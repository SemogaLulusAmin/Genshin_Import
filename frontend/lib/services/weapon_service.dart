import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weapon_model.dart';

class WeaponService {
  static const String baseUrl = 'http://localhost:3000/weapon';

  Future<List<Weapon>> getWeapons() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Weapon.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load weapons');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Weapon?> getWeaponById(String weaponId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/$weaponId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Weapon.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load weapon');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> purchaseWeapon(String weaponId, int quantity) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/userWeapon/buy/$weaponId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to purchase weapon: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

<<<<<<< HEAD
  Future<bool> createWeapon(Map<String, dynamic> weaponData, {String? imagePath}) async {
=======
  Future<bool> createWeapon(Map<String, dynamic> weaponData, String imagePath) async {
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

<<<<<<< HEAD
      if (imagePath != null && imagePath.isNotEmpty) {
        final request = http.MultipartRequest('POST', Uri.parse(baseUrl));
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(weaponData.map((key, value) => MapEntry(key, value?.toString() ?? '')));
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
        body: json.encode(weaponData),
      );

      return response.statusCode == 200;
=======
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      weaponData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add image file
      if (imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to create weapon: $responseData');
      }
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

<<<<<<< HEAD
  Future<bool> updateWeapon(String weaponId, Map<String, dynamic> weaponData, {String? imagePath}) async {
=======
  Future<bool> updateWeapon(String weaponId, Map<String, dynamic> weaponData, String? imagePath) async {
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

<<<<<<< HEAD
      if (imagePath != null && imagePath.isNotEmpty) {
        final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$weaponId'));
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(weaponData.map((key, value) => MapEntry(key, value?.toString() ?? '')));
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        return response.statusCode == 200;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/$weaponId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(weaponData),
      );

      return response.statusCode == 200;
=======
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$weaponId'));
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      weaponData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add image file if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update weapon: $responseData');
      }
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteWeapon(String weaponId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No token found. Please login first.');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/$weaponId'),
        headers: {'Authorization': 'Bearer $token'},
      );

<<<<<<< HEAD
      return response.statusCode == 200;
=======
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete weapon: ${response.body}');
      }
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
