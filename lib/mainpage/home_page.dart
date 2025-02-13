import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sample list of users (can be fetched from an API)
  final List<UserProfile> users = [
    UserProfile(
      id: 1,
      name: "Jessica Parker",
      age: 23,
      imageUrl:
          "https://cdn.pixabay.com/photo/2024/12/28/03/45/girl-9295191_1280.jpg",
    ),
    UserProfile(
      id: 2,
      name: "Sophia Lee",
      age: 25,
      imageUrl:
          "https://cdn.pixabay.com/photo/2022/09/14/01/12/portrait-7453154_1280.jpg",
    ),
    UserProfile(
      id: 3,
      name: "Emily Davis",
      age: 22,
      imageUrl:
          "https://cdn.pixabay.com/photo/2022/01/18/15/40/vietnam-6947337_1280.jpg",
    ),
    UserProfile(
      id: 4,
      name: "Olivia Brown",
      age: 26,
      imageUrl:
          "https://cdn.pixabay.com/photo/2020/09/21/13/38/woman-5590119_1280.jpg",
    ),
  ];

  int currentIndex = 0;

  void _nextProfile() {
    setState(() {
      if (currentIndex < users.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // Reset to the first profile
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProfile currentUser = users[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Match For U",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(currentUser.imageUrl),
                        fit: BoxFit.fitHeight,
                      ),
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
      ),
    );
  }
}

class UserProfile {
  final int id;
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
