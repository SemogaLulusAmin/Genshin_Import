import 'dart:convert';
import 'package:frontend/core/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  String get _baseUrl => '${ApiConfig.baseUrl}/auth';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'CLIENT_GOOGLE_ID.apps.googleusercontent.com',
    scopes: ['email', 'profile', 'openid'],
  );

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = _decodeJsonBody(response.body);
        final token = data['token']?.toString();

        if (token == null || token.isEmpty) {
          return {"success": false, "message": "Login response is invalid"};
        }

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        final user = data['user'];
        if (user is Map<String, dynamic>) {
          user['email'] ??= email;
        }

        return {"success": true, "token": token, "user": user};
      } else if (response.statusCode == 401) {
        return {"success": false, "message": "Wrong password"};
      } else if (response.statusCode == 404) {
        return {"success": false, "message": "User not found"};
      } else {
        final data = _decodeJsonBody(response.body);

        return {
          "success": false,
          "message": data['message']?.toString() ?? "Login Failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Failed to login. Please check your connection.",
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      final data = _decodeJsonBody(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": data['message']?.toString() ?? "Registration Success",
        };
      } else {
        return {
          "success": false,
          "message": data['message']?.toString() ?? "Registration Failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Failed to register. Please check your connection.",
      };
    }
  }

  Future<Map<String, dynamic>> loginToBackend(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'accessToken': accessToken}),
      );

      if (response.statusCode == 200) {
        // Gunakan helper _decodeJsonBody supaya konsisten
        final data = _decodeJsonBody(response.body);
        final token = data['token']?.toString();

        if (token == null || token.isEmpty) {
          return {
            "success": false,
            "message":
                "Google sign-in worked, but the server response was incomplete. Please try again.",
          };
        }

        // SIMPAN KE STORAGE (Pakai key 'jwt_token' biar sama!)
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        final user = data['user'];
        // User dari Google biasanya sudah bawa email dari backend kita tadi

        return {"success": true, "token": token, "user": user};
      } else {
        // Handle error kalau token Google ditolak backend
        final data = _decodeJsonBody(response.body);
        return {
          "success": false,
          "message": _readableGoogleBackendMessage(data['message']),
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message":
            "We could not connect to the server after Google sign-in. Please check your internet connection and try again.",
      };
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {
          "success": false,
          "message": "Google sign-in was canceled. Please try again.",
        };
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        return {
          "success": false,
          "message":
              "Google did not return the required sign-in credentials. Please try again.",
        };
      }

      // Panggil fungsi kirim ke backend
      return await loginToBackend(accessToken);
    } catch (e) {
      return {"success": false, "message": _readableGoogleSignInError(e)};
    }
  }

  String _readableGoogleBackendMessage(dynamic message) {
    final rawMessage = message?.toString().trim();
    if (rawMessage == null || rawMessage.isEmpty) {
      return "Google sign-in failed on the server. Please try again.";
    }

    final lowerMessage = rawMessage.toLowerCase();
    if (lowerMessage.contains('invalid') ||
        lowerMessage.contains('token') ||
        lowerMessage.contains('unauthorized')) {
      return "Your Google session could not be verified. Please sign in with Google again.";
    }

    if (lowerMessage.contains('network') ||
        lowerMessage.contains('connection') ||
        lowerMessage.contains('timeout')) {
      return "We could not reach the server. Please check your internet connection and try again.";
    }

    return rawMessage;
  }

  String _readableGoogleSignInError(Object error) {
    final rawError = error.toString().toLowerCase();

    if (rawError.contains('network') ||
        rawError.contains('socket') ||
        rawError.contains('timeout')) {
      return "We could not reach Google. Please check your internet connection and try again.";
    }

    if (rawError.contains('sign_in_canceled') ||
        rawError.contains('canceled') ||
        rawError.contains('cancelled')) {
      return "Google sign-in was canceled. Please try again.";
    }

    if (rawError.contains('sign_in_failed') ||
        rawError.contains('developer_error') ||
        rawError.contains('api_exception: 10') ||
        rawError.contains('client')) {
      return "Google sign-in is not configured correctly. Please contact support.";
    }

    if (rawError.contains('popup') || rawError.contains('browser')) {
      return "Google sign-in could not open properly. Please try again.";
    }

    return "Google sign-in failed. Please try again in a moment.";
  }

  Map<String, dynamic> _decodeJsonBody(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{};
  }
}
