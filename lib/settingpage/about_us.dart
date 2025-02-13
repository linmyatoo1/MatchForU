import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("About Us"),
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
                  "Welcome to Match For U ❤️",
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
                "The exclusive dating app for students of Mae Fah Luan University! We know that university life is about more than just lectures and assignments—it’s also about making meaningful connections, finding friends, and maybe even meeting that special someone.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Text(
                "Why Choose Us?",
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              _buildFeatureItem(
                context,
                "✅ For Students, By Students – Connect with verified university students only.",
              ),
              _buildFeatureItem(
                context,
                "✅ Safe & Secure – Your privacy is our top priority.",
              ),
              _buildFeatureItem(
                context,
                "✅ Easy & Fun – Swipe, match, and chat with like-minded peers.",
              ),
              _buildFeatureItem(
                context,
                "✅ More Than Dating – Find friends, study buddies, or event partners.",
              ),
              SizedBox(height: 16),
              Text(
                "Our Mission",
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Our goal is to create a positive and engaging platform where students can form genuine connections—whether it's for dating, friendship, or networking. University life is short, so why not make the most of it?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 24),
              Center(
                child: Text(
                  "📍 Developed by [Clock Chaser]\n📩 Contact us at [6631503066@lamduan.mfu.ac.th]",
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.pinkAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: Theme.of(context).textTheme.bodyMedium),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
