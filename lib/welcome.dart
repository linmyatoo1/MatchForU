import 'package:flutter/material.dart';
import 'package:match_for_u/mainpage/home_page.dart';
import 'package:match_for_u/mainpage/favorie_page.dart';
import 'package:match_for_u/mainpage/chat_page.dart';
import 'package:match_for_u/mainpage/setting_page.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    FavoritePage(),
    ChatPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
        return true;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: _pages[_selectedIndex], // Displays selected page
        bottomNavigationBar: Container(
          width: double.infinity, // Makes the bar full width
          decoration: BoxDecoration(
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 243, 103, 103).withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.favorite, 1),
              _buildNavItem(Icons.chat_sharp, 2),
              _buildNavItem(Icons.settings, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
          size: isSelected ? 34 : 30,
        ),
      ),
    );
  }
}
