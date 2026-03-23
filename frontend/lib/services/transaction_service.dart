import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class TransactionService extends ApiService {
  Future<bool> postWeaponTransaction(
    String userId,
    String weaponId,
    int qty,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/transactions/weapon"),
      headers: headersWithToken(token),
      body: jsonEncode({'userID': userId, 'weaponID': weaponId, 'stock': qty}),
    );

    return response.statusCode == 201;
  }

  Future<bool> postArtifactTransaction(
    String userId,
    String artifactId,
    int qty,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/transactions/artifact"),
      headers: headersWithToken(token),
      body: jsonEncode({
        'userID': userId,
        'artifactID': artifactId,
        'stock': qty,
      }),
    );

    return response.statusCode == 201;
  }
}
