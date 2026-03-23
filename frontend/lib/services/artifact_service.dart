import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/artifact_model.dart';

class ArtifactService extends ApiService {
  Future<List<ArtifactModel>> getAllArtifacts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/artifacts"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ArtifactModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal memuat data artefak");
    }
  }
}
