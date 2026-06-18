import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/user_model.dart';

/// Repository subsystem specialized in downloading and isolating user collection datasets.
/// 
/// Serves as the concrete data layer access point for the User List feature, ensuring 
/// presentation controllers never interact directly with underlying network endpoints.
class UserRepository {
  // Hardcoded endpoint configuration mapping target directory payloads
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/users';

  /// Fetches the remote array of user entities and translates them into typed structures.
  /// 
  /// Dispatches an asynchronous HTTP GET transaction to [_baseUrl]. 
  /// Returns a clean [List<UserModel>] if communication completes successfully.
  /// Throws an [Exception] if remote gates return systemic faults or transport fails.
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      // Validate successful connection thresholds before executing data extraction
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        
        // Transform the collection stream by mapping dynamic configurations into static types
        return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Catch socket drops or network layer errors and forward the raw string message
      throw Exception(e.toString());
    }
  }
}

