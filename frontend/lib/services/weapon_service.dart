import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weapon_model.dart';

class WeaponService {
  // static const String baseUrl = 'http://10.0.2.2:3000';
  static const String baseUrl = 'http://localhost:3000';

  Future<List<Weapon>> getWeapons() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/weapon'));

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
}
