import 'dart:convert';
import 'package:http/http.dart' as http;

class Authservice {
  final String _baseUrl = "http://localhost:3000";

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "token": data['token'], "user": data['user']};
      } else {
        return {"success": false, "message": data['message'] ?? "Login Failed"};
      }
    } catch (e) {
      return {"success": false, "message": "Failed to login: $e"};
    }
  }
}
