import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:match_for_u/constants.dart';
import 'package:match_for_u/models/token.dart'; // Import StorageService

class ActivityAPI {
  static String Url = '$baseUrl/activity';

  // Function to send activity data to backend
  static Future<bool> createActivity(Map<String, dynamic> activityData) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        print('No auth token found');
        return false;
      }

      final response = await http.post(
        Uri.parse(Url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(activityData),
      );

      if (response.statusCode == 201) {
        print('Activity created successfully');
        return true;
      } else {
        print(
            'Failed to create activity: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating activity: $e');
      return false;
    }
  }

  // Function to fetch activities from backend
  static Future<List<Map<String, dynamic>>> getActivities() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        print('No auth token found');
        return [];
      }

      final response = await http.get(
        Uri.parse(Url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success' &&
            responseBody['data'] != null) {
          List<dynamic> activities = responseBody['data']['activities'];
          // Transform backend format to match your frontend model
          return activities
              .map((activity) => {
                    'name': activity['activityName'] ?? '',
                    'description': activity['location'] ?? '',
                    'time': activity['time'] ?? '',
                    'currentParticipants':
                        1, // Default as this isn't in your backend yet
                    'maxParticipants': activity['number'] ?? 1,
                  })
              .toList();
        }
      }
      print(
          'Failed to fetch activities: ${response.statusCode} - ${response.body}');
      return [];
    } catch (e) {
      print('Error fetching activities: $e');
      return [];
    }
  }
}
