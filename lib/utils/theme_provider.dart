import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Dark theme colors
  static const Color darkPrimaryColor = Color.fromARGB(255, 243, 109, 201);
  static const Color darkBackgroundColor = Color.fromARGB(255, 24, 22, 47);
  static const Color darkBackgroundGradientStart = Color.fromARGB(
    255,
    37,
    38,
    66,
  );
  static const Color darkBackgroundGradientEnd = Color.fromARGB(
    255,
    24,
    22,
    47,
  );

  // Light theme colors
  static const Color lightPrimaryColor = Color.fromARGB(255, 243, 109, 201);
  static const Color lightBackgroundColor = Color.fromARGB(255, 250, 250, 255);
  static const Color lightBackgroundGradientStart = Color.fromARGB(
    255,
    240,
    240,
    255,
  );
  static const Color lightBackgroundGradientEnd = Color.fromARGB(
    255,
    250,
    250,
    255,
  );

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Dark theme
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.grey),
    ),
  );

  // Light theme
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Color.fromARGB(255, 37, 38, 66)),
      titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 37, 38, 66),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Color.fromARGB(255, 37, 38, 66),
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Color.fromARGB(255, 37, 38, 66),
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Color.fromARGB(255, 37, 38, 66),
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(color: Color.fromARGB(255, 37, 38, 66)),
      bodyMedium: TextStyle(color: Color.fromARGB(255, 100, 100, 120)),
    ),
  );

  // Get background gradient based on current theme
  List<Color> get backgroundGradient =>
      _isDarkMode
          ? [darkBackgroundGradientStart, darkBackgroundGradientEnd]
          : [lightBackgroundGradientStart, lightBackgroundGradientEnd];
}
