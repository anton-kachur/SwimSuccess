import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/user_model.dart';

class UserRepository {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/users';

  // Fetch all users from remote REST API
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        // Map raw data list into strongly typed UserModel objects
        return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
