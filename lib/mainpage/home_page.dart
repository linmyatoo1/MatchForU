import 'package:flutter/material.dart';
import 'package:match_for_u/models/user_profile.dart';
import 'package:match_for_u/service/match_service.dart';
import 'package:match_for_u/service/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = UserService();
  final MatchService _matchService = MatchService();
  List<UserProfile> users = [];
  bool isLoading = true;
  String? error;
  int currentIndex = 0;
  bool isProcessingAction = false;

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

  Future<void> _likeUser() async {
    if (isProcessingAction || users.isEmpty) return;

    setState(() {
      isProcessingAction = true;
    });

    try {
      final userId = users[currentIndex].id.toString();
      print('Liking user with ID: $userId');

      await _matchService.likeUser(userId);

      // Show a snackbar on successful like
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You liked ${users[currentIndex].name}!'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );

      _nextProfile();
    } catch (e) {
      print('Error during like operation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong!'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isProcessingAction = false;
      });
    }
  }

  Future<void> _dislikeUser() async {
    if (isProcessingAction || users.isEmpty) return;

    setState(() {
      isProcessingAction = true;
    });

    try {
      final userId = users[currentIndex].id.toString();
      await _matchService.rejectUser(userId);

      _nextProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong!!!'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isProcessingAction = true;
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
          _loadUsers(); // Reload to get new profiles
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
    if (users.isEmpty)
      return const Center(child: Text('No profiles available'));

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
                    _likeUser();
                  } else if (details.velocity.pixelsPerSecond.dx < 0) {
                    // Swiped Left (Disliked)
                    _dislikeUser();
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
                      )),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.black.withOpacity(0.5),
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
                          if (currentUser.bio != null &&
                              currentUser.bio!.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                currentUser.bio!,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
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
              if (isProcessingAction)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
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
              onPressed: _dislikeUser,
              tooltip: 'Dislike',
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.pink, size: 40),
              onPressed: _likeUser,
              tooltip: 'Like',
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
