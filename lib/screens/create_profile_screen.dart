import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:match_for_u/authen/login.dart';
import 'package:match_for_u/constants.dart';
import 'package:match_for_u/models/token.dart';
import 'dart:async';

class CreateProfileScreen extends StatefulWidget {
  final int age;
  final String gender;
  final String interest;

  const CreateProfileScreen({
    Key? key,
    required this.age,
    required this.gender,
    required this.interest,
  }) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> submitProfileData() async {
    try {
      // Validate form inputs first
      if (_imageFile == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a profile photo")),
        );
        return;
      }

      final token = await StorageService.getToken();

      if (token == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication token not found")),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Create multipart request
      var uri = Uri.parse("$baseUrl/users/profile");
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      // Add text fields
      request.fields['name'] = _nameController.text;
      request.fields['age'] = widget.age.toString();
      request.fields['bio'] = _bioController.text;
      request.fields['gender'] = widget.gender.toLowerCase();
      request.fields['interest'] = widget.interest.toLowerCase();

      // Add image with field name 'image' to match backend expectation
      if (_imageFile != null) {
        var file = await http.MultipartFile.fromPath(
          'image', // Changed back to 'image' to match backend req.files.image
          _imageFile!.path,
        );
        request.files.add(file);
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (!mounted) return;
      Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await StorageService.clearToken();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile created successfully")),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false,
        );
      } else {
        final responseData = jsonDecode(response.body);
        // Special handling for profile already exists error
        if (response.statusCode == 400 &&
            responseData["message"]?.contains("Profile already exist") ==
                true) {
          // Clear token
          await StorageService.clearToken();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Account created. Please login to access your profile.")),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                     "Failed to create profile")),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Your Profile!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.pink, width: 2),
                      ),
                      child: _imageFile != null
                          ? ClipOval(
                              child: Image.file(
                                File(_imageFile!.path),
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.camera_alt,
                                  color: Colors.pink, size: 40),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isEmpty ||
                      _bioController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill in all fields")),
                    );
                    return;
                  }
                  submitProfileData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
