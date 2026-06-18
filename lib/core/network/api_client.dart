import 'dart:convert';
import 'package:http/http.dart' as http;

/// A centralized network utility class handling base HTTP operations.
/// 
/// This wrapper abstracts repetitive networking boilerplate, enforces common 
/// request headers, and centralizes error handling across different app features.
class ApiClient {
  
  /// Executes a secure asynchronous HTTP POST transaction.
  /// 
  /// Accepts a target remote [url] endpoint and a raw [body] payload map.
  /// Enforces a strict 10-second timeout window to prevent UI-blocking and hangs.
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    try {
      // Execute the standard network post request via the http package
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10)); // Safeguard against infinite waiting on slow setups
      
      return response;
    } catch (e) {
      // Catch socket exceptions, network dropouts, or timeout boundaries
      // and re-throw them cleanly to let repositories parse the message
      throw Exception(e.toString());
    }
  }
}

