import 'package:flutter/material.dart';

class AppTheme {
  // الألوان من ملف الـ Design اللي بعته
  static const Color primaryColor = Color(0xFF7D562D);
  static const Color primaryContainer = Color(0xFFD4A373);
  static const Color backgroundColor = Color(0xFFFDF9F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFF50453B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        onPrimaryContainer: Color(0xFF5B3912),
        surface: backgroundColor,
        background: backgroundColor,
      ),
      // إعداد الخط (تأكد من إضافة IBM Plex Sans في pubspec.yaml)
      fontFamily: 'IBM Plex Sans', 
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'IBM Plex Sans',
        ),
      ),
    );
  }
}