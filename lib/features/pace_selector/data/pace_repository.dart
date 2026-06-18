import '../../../core/network/api_client.dart';

/// Repository class responsible for handling data operations related to the swimmer's pace.
/// 
/// This class acts as a data layer abstraction, isolating the presentation layer
/// (Providers/Blocs) from direct knowledge of api endpoints and raw network payloads.
class PaceRepository {
  // Decentralized api client instance used to execute standard HTTP drivers
  final ApiClient _apiClient = ApiClient();
  
  // Explicit endpoint target for syncing selected swimming parameters
  final String _url = 'https://jsonplaceholder.typicode.com/posts';

  /// Dispatches the calculated pace time metrics to the remote REST server.
  /// 
  /// Converts the raw [seconds] parameter into a structured network payload.
  /// Returns `true` if the server returns a successful execution flag (`200` or `201`), 
  /// otherwise returns `false`.
  Future<bool> uploadPaceSeconds(int seconds) async {
    // Forward payload payload structure wrapping raw inputs into domain specific keys
    final response = await _apiClient.post(_url, {'pace_seconds': seconds});
    
    // Evaluate status thresholds to verify proper database registration on server side
    return response.statusCode == 201 || response.statusCode == 200;
  }
}
