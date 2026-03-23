import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/artifact_model.dart';
import '../services/api_service.dart';

class ArtifactProvider with ChangeNotifier {
  List<ArtifactModel> _artifacts = [];
  bool _isLoading = false;

  List<ArtifactModel> get artifacts => _artifacts;
  bool get isLoading => _isLoading;

  final String baseUrl = ApiService().baseUrl;

  Future<void> fetchArtifacts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$baseUrl/artifacts"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _artifacts = data.map((item) => ArtifactModel.fromJson(item)).toList();
      }
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('Failed host lookup')) {
        print("Gagal terhubung ke server (cek Port 3000)");
      } else {
        print("Error fetching artifacts: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
