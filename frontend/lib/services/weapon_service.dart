import 'dart:convert';
import 'dart:typed_data' as typed_data;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // Pakai XFile biar universal
import '../models/weapon_model.dart';

class WeaponService {
  // Samakan dengan Artifact, localhost untuk Web, 10.0.2.2 untuk Emulator Android
  static const String serverUrl = 'http://localhost:3000';
  static const String apiBaseUrl = '$serverUrl/weapon';

  // Helper ambil token biar nggak ngetik ulang
  Future<String> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');
    if (token == null) throw Exception('No token found. Please login first.');
    return token;
  }

  /// --- GET ALL WEAPONS ---
  Future<List<Weapon>> getWeapons() async {
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
          // FIX IMAGE URL: Tambahkan domain server sebelum masuk ke Model
          if (data['image_url'] != null && !data['image_url'].startsWith('http')) {
            data['image_url'] = '$serverUrl${data['image_url']}';
          }
          return Weapon.fromJson(data);
        }).toList();
      } else {
        throw Exception('Failed to load weapons');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// --- GET WEAPON BY ID ---
  Future<Weapon?> getWeaponById(String weaponId) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$apiBaseUrl/$weaponId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // FIX IMAGE URL
        if (data['image_url'] != null && !data['image_url'].startsWith('http')) {
          data['image_url'] = '$serverUrl${data['image_url']}';
        }
        return Weapon.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load weapon');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// --- CREATE A NEW WEAPON (ADMIN ONLY) ---
  /// Pakai XFile dan fromBytes biar Support Web & Mobile
  Future<bool> createWeapon(Map<String, String> fields, XFile imageFile) async {
    try {
      final token = await _getToken();

      var request = http.MultipartRequest('POST', Uri.parse(apiBaseUrl));
      request.headers['Authorization'] = 'Bearer $token';

      // Masukkan field teks (name, type, rarity, dll)
      request.fields.addAll(fields);

      // Baca gambar sebagai bytes (Penting buat Flutter Web!)
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
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create weapon');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// --- PURCHASE WEAPON ---
  Future<bool> purchaseWeapon(String weaponId, int quantity) async {
    try {
      final token = await _getToken();

      final response = await http.post(
        Uri.parse('$serverUrl/userWeapon/buy/$weaponId'), // Pastikan endpoint ini bener di backend
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
}