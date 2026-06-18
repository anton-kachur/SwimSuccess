import '../../../core/network/api_client.dart';

class PaceRepository {
  final ApiClient _apiClient = ApiClient();
  final String _url = 'https://jsonplaceholder.typicode.com/posts';

  // Send pace results to the server
  Future<bool> uploadPaceSeconds(int seconds) async {
    final response = await _apiClient.post(_url, {'pace_seconds': seconds});
    return response.statusCode == 201 || response.statusCode == 200;
  }
}
