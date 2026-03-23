import 'dart:io';

class ApiService {
  String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:3000/api";
      } else {
        return "http://127.0.0.1:3000/api";
      }
    } catch (e) {
      return "http://localhost:3000/api"; // Fallback for Web
    }
  }

  Map<String, String> get headers => {'Content-Type': 'application/json'};

  Map<String, String> headersWithToken(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
