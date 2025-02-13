import 'package:flutter/material.dart';

class PrivacyAndPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Privacy Policy 🛡️",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "1. Introduction",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Match For U respects your privacy and is committed to protecting your personal data. This Privacy Policy outlines how we collect, use, and safeguard your information.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "2. Information We Collect",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildPolicyItem(
                  "📌 Personal Information – When you sign up, we collect your name and email."),
              _buildPolicyItem(
                  "📌 Profile Data – This includes your bio, photos, and interests."),
              _buildPolicyItem(
                  "📌 Usage Data – We track app activity to improve user experience."),
              SizedBox(height: 16),
              Text(
                "3. How We Use Your Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildPolicyItem("✅ To verify your university affiliation."),
              _buildPolicyItem(
                  "✅ To personalize your experience and match you with others."),
              _buildPolicyItem("✅ To ensure a safe and respectful community."),
              SizedBox(height: 16),
              Text(
                "4. Sharing Your Data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "We do not sell your data. However, we may share necessary information with trusted partners for security, analytics, and app functionality.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "5. Your Rights",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildPolicyItem(
                  "🔒 You can request to delete your data at any time."),
              _buildPolicyItem("🔒 You can update your profile information."),
              SizedBox(height: 16),
              Text(
                "6. Contact Us",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "If you have any questions about our Privacy Policy, please contact us at [Your Email/Support].",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Center(
                child: Text(
                  "📍 Developed by Clock Chaser\n📩 Contact: 6631503066@lamduan.mfu.ac.th",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
