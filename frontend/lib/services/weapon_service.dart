import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/weapon_model.dart';

class WeaponService extends ApiService {
  Future<List<WeaponModel>> getAllWeapons() async {
    final response = await http.get(
      Uri.parse("$baseUrl/weapons"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => WeaponModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal memuat data senjata");
    }
  }
}
