import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:match_for_u/mainpage/setting_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _selectedDate;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController.text = "";
    _bioController.text = "";
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 160,
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text("Choose from Gallery",
                    style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text("Take a Photo",
                    style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    // Store input values in variables
    String username = _usernameController.text.trim();
    String bio = _bioController.text.trim();
    String? dateOfBirth = _selectedDate;
    File? profileImage = _imageFile;

    // Validate inputs
    if (username.isEmpty || bio.isEmpty || dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    // API URL
    String apiUrl = "http://your-api-url.com/api/v1/user/updateProfile";

    try {
      // Prepare FormData
      FormData formData = FormData.fromMap({
        "username": username,
        "bio": bio,
        "date_of_birth": dateOfBirth,
        "profile_image": profileImage != null
            ? await MultipartFile.fromFile(profileImage.path,
                filename: profileImage.path.split('/').last)
            : null, // Send null if no image selected
      });

      Dio dio = Dio();
      Response response = await dio.post(apiUrl, data: formData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider
                        : const AssetImage('images/linmyatoo.jpeg'),
                  ),
                  GestureDetector(
                    onTap: _showImagePickerDialog,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Theme.of(context).primaryColor,
                      child:
                          const Icon(Icons.edit, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildTextField("Username", _usernameController),
              const SizedBox(height: 30),
              _buildTextField("Bio", _bioController),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDate ?? "Choose birthday date",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProfile, // Calls function to send data
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: Text(
                    "Save",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
