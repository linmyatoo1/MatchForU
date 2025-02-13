import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.pinkAccent, // Custom primary color
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    headlineLarge: TextStyle(color: Colors.black),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.pinkAccent, // Button color
    textTheme: ButtonTextTheme.primary,
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.pinkAccent, // Custom dark mode primary color
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.pinkAccent, // Dark Mode Button Color
    textTheme: ButtonTextTheme.primary,
  ),
);
