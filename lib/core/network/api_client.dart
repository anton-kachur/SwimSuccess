import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10)); // Set timeout to avoid infinite hanging
      return response;
    } catch (e) {
      // Return the actual technical error string instead of hardcoded text
      throw Exception(e.toString());
    }
  }
}
