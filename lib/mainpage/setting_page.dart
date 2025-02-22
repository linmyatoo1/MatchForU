import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:match_for_u/models/token.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:match_for_u/settingpage/about_us.dart';
import 'package:match_for_u/settingpage/change_password.dart';
import 'package:match_for_u/settingpage/delete_account.dart';
import 'package:match_for_u/authen/login.dart';
import 'package:match_for_u/settingpage/privacy_and_policy.dart';
import 'package:match_for_u/welcome.dart';
import 'package:match_for_u/settingpage/edit_profile.dart';
import 'package:match_for_u/models/theme_provider.dart';
import 'package:match_for_u/models/theme.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool pushNotifications = true;
  String? name;
  String? profileImage;
  String? token;
  int? age;
  String? userBio;
  Map<String, dynamic>? profileData;
  
  @override
  void initState() {
    super.initState();
    _getUserToken(); //Get user ID first
  }

  // Fetch the user ID from backend
  Future<void> _getUserToken() async {
    
    try {
      token = await StorageService.getToken();
      print('Token: $token');

      if (token == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication token not found")),
      );
      return;
    }
    _fetchUserProfile();
    
    } catch (e) {
      print("Error fetching user ID: $e");
    }
  }

 Future<void> _fetchUserProfile() async {
  String profileApi = "http://127.0.0.1:3000/api/v1/users/profile";

  try {
    var uri = Uri.parse(profileApi);
    var request = http.MultipartRequest('GET', uri);

    // Add headers
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json", // Add this header to ensure JSON response
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);      

    // Debug output
    print("Status Code: ${response.statusCode}");
    print("Response headers: ${response.headers}");
    print("Raw response: ${response.body}");

    if (response.statusCode == 200) {
      // Only try to parse if we get a 200 status
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      profileData = jsonResponse['data']['profile'];
      
      setState(() {
        name = profileData!['name'];
        profileImage = profileData!['photo'];
        userBio = profileData!['bio'];
        age = profileData!['age'];
      });
    } else {
      print("Error status code: ${response.statusCode}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load profile: Status ${response.statusCode}")),
        );
      }
    }
  } catch (e) {
    print("Error fetching profile: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load profile: ${e.toString()}")),
      );
    }
  }
}
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Welcome()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: profileImage != null
                            ? NetworkImage(profileImage!)
                            : const AssetImage('images/linmyatoo.jpeg')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        name ?? "Loading...",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    "Edit profile",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfile(
                          initialName: name,
                          initialPhoto: profileImage,
                          initialAge: profileData!['age'],
                          initialBio: profileData!['bio'],
                        ),),);
                  },
                ),
                ListTile(
                  title: Text(
                    "Change password",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Push notifications',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Switch(
                    value: pushNotifications,
                    onChanged: (value) {
                      setState(() => pushNotifications = value);
                    },
                    activeColor: Colors.pink,
                  ),
                ),
                ListTile(
                  title: Text(
                    'Dark mode',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Switch(
                    value: themeProvider.themeData == darkTheme,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: Colors.pink,
                  ),
                ),
                const SizedBox(height: 10, child: Divider(color: Colors.pink)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'More',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ),
                ListTile(
                  title: Text(
                    'About us',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutUs()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Privacy policy',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyAndPolicy()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Delete account',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeleteAccount()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: Text(
                      'Log out',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.pink),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
