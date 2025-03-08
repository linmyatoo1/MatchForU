import 'package:flutter/material.dart';
import 'package:match_for_u/models/view_users.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = UserService();
  List<UserProfile> users = [];
  bool isLoading = true;
  String? error;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedUsers = await _userService.fetchUsers();

      setState(() {
        users = fetchedUsers;
        isLoading = false;
        currentIndex = 0;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _nextProfile() {
    setState(() {
      if (currentIndex < users.length - 1) {
        currentIndex++;
      } else {
        // If we're at the end, reload users or reset to beginning
        if (users.isNotEmpty) {
          currentIndex = 0;
        } else {
          _loadUsers(); // Reload if list is empty
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match For U",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $error',
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : users.isEmpty
                  ? const Center(child: Text('No profiles available'))
                  : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    UserProfile currentUser = users[currentIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onPanEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    // Swiped Right (Liked)
                    _nextProfile();
                  } else if (details.velocity.pixelsPerSecond.dx < 0) {
                    // Swiped Left (Disliked)
                    _nextProfile();
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(currentUser.imageUrl),
                      fit: BoxFit.cover,
                      )
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser.name,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "${currentUser.age} y",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 40),
              onPressed: _nextProfile, // Dislike action
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.pink, size: 40),
              onPressed: _nextProfile, // Like action
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class UserProfile {
  final dynamic id;
  final String name;
  final int age;
  final String imageUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
  });
}
