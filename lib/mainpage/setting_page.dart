import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
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
  String? userId;
  String? username;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    _getUserId(); //Get user ID first
  }

  // Fetch the user ID from backend
  Future<void> _getUserId() async {
    String userIdApi = "http://your-api-url.com/api/v1/profile/getUserId"; //

    try {
      Dio dio = Dio();
      Response response = await dio.get(userIdApi);

      if (response.statusCode == 200) {
        setState(() {
          userId = response.data['data']['userId']; //Store user ID
        });

        // data using user ID
        _fetchUserProfile();
      }
    } catch (e) {
      print("Error fetching user ID: $e");
    }
  }

  Future<void> _fetchUserProfile() async {
    if (userId == null) return;

    String profileApi = "http://your-api-url.com/api/v1/user/profile/$userId";

    try {
      Dio dio = Dio();
      Response response = await dio.get(profileApi);

      if (response.statusCode == 200) {
        var profileData = response.data['data']['profile'];

        setState(() {
          username = profileData['name'];
          profileImage = profileData['photo'];
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
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
                            : const AssetImage('images/default_avatar.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        username ?? "Loading...",
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
                        MaterialPageRoute(builder: (context) => EditProfile()));
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
