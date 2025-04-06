import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:match_for_u/models/token.dart';
import 'package:match_for_u/constants.dart';

class MatchService {
  // Based on your router setup, these are the correct endpoints
  static const String matchUrl = '$baseUrl/users/match'; // For getting matches
  static const String likeUrl = '$baseUrl/users/like'; // For liking users
  static const String rejectUrl =
      '$baseUrl/users/reject'; // For rejecting users

  // Like a user
  Future<Map<String, dynamic>> likeUser(String userId) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Create payload for liking a user
      final Map<String, dynamic> payload = {'likedUserId': userId};

      print('Sending like request to: $likeUrl');
      print('Payload: $payload');

      final response = await http.post(
        Uri.parse(likeUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication expired. Please login again.');
      } else {
        throw Exception('Failed to like user: ${response.body}');
      }
    } catch (e) {
      print('Error in likeUser: $e');
      throw Exception('Error liking user: $e');
    }
  }

  // Reject a user
  Future<Map<String, dynamic>> rejectUser(String userId) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Create payload for rejecting a user
      final Map<String, dynamic> payload = {'rejectedUserId': userId};

      print('Sending reject request to: $rejectUrl');
      print('Payload: $payload');

      final response = await http.post(
        Uri.parse(rejectUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication expired. Please login again.');
      } else {
        throw Exception('Failed to reject user: ${response.body}');
      }
    } catch (e) {
      print('Error in rejectUser: $e');
      throw Exception('Error rejecting user: $e');
    }
  }

  // Get all matches
  Future<List<MatchProfile>> getMatches() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('Fetching matches from: $matchUrl');

      final response = await http.get(
        Uri.parse(matchUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Get matches response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<MatchProfile> matchProfiles = [];

        if (data['matches'] != null && data['matches'] is List) {
          // Get current user ID for comparison
          final userProfile = await StorageService.getUserProfile();
          final currentUserId = userProfile?['_id'];

          for (var match in data['matches']) {
            try {
              // Determine which user is the match (not the current user)
              final user1 = match['user1'];
              final user2 = match['user2'];

              final matchedUser = user1['_id'] != currentUserId ? user1 : user2;

              if (matchedUser != null && matchedUser['profile'] != null) {
                final profile = matchedUser['profile'];

                matchProfiles.add(MatchProfile(
                  id: matchedUser['_id'],
                  name: profile['name'] ?? 'Unknown',
                  imageUrl:
                      profile['photo'] ?? 'https://via.placeholder.com/150',
                  matchedAt: match['matchedAt'] != null
                      ? DateTime.parse(match['matchedAt'])
                      : DateTime.now(),
                ));
              }
            } catch (e) {
              print('Error processing match: $e');
              // Continue to next match if there's an error with this one
              continue;
            }
          }
        }
        return matchProfiles;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication expired. Please login again.');
      } else {
        throw Exception('Failed to get matches: ${response.body}');
      }
    } catch (e) {
      print('Error in getMatches: $e');
      throw Exception('Error getting matches: $e');
    }
  }
}

class MatchProfile {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime matchedAt;

  MatchProfile({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.matchedAt,
  });
}
