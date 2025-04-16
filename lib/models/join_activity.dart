import 'package:http/http.dart' as http;
import 'package:match_for_u/constants.dart';
import 'package:match_for_u/models/token.dart';

class ActivityAPI {
  static const String baseActivityUrl = "$baseUrl/activity";

  static Future<void> joinActivity(String activityId) async {
    print(activityId);
    final url = Uri.parse('$baseActivityUrl/join/$activityId');
    print(url);

    // const storage = FlutterSecureStorage();
    final token = await StorageService.getToken();
    print(token);

    if (token == null) {
      throw Exception('Auth token is missing. Please log in again.');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 || response.statusCode != 201) {
      throw Exception('Failed to join activity: ${response.body}');
    }
  }
}
