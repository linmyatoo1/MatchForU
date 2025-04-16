import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:match_for_u/models/token.dart';
import 'package:match_for_u/constants.dart';
import 'package:match_for_u/models/user_profile.dart';

class UserService {
  static const String Url = '$baseUrl/users/recommend';

  Future<List<UserProfile>> fetchUsers() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse(Url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);

        // Check if the structure matches the backend response
        if (decodedBody['status'] == 'success' && decodedBody['data'] != null) {
          final List<dynamic> usersData = decodedBody['data']['randomUsers'] ?? [];

          return usersData.map((userData) => UserProfile(
            id: userData['userId'] ?? 0,
            name: userData['name'] ?? 'Unknown',
            age: userData['age'] ?? 0,
            imageUrl: userData['photo'] ?? 'https://via.placeholder.com/150',
            bio: userData['bio'], // Added bio field
          )).toList();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication expired. Please login again.');
      } else {
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}