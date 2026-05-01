import 'dart:convert';
import 'package:http/http.dart' as http;

class Authservice {
  final String _loginUrl = "http://10.0.2.2:3000/login";

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
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
