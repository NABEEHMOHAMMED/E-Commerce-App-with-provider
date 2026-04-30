import 'package:flutter/material.dart';

class AppTheme {
  // Light theme 
  static const Color bgLight = Colors.white;
  static const Color bgLightSurface = Color(0xFFF8F9FA);
  static const Color textLightPrimary = Color(0xFF1E1E2C);
  static const Color textLightMuted = Color(0xFF8A8A9E);
  static const Color orangeAccent = Color(0xFFFF5722);
  static const Color blueAccent = Color(0xFF2979FF);
  static const Color navInactive = Color(0xFF9E9E9E);

  // Dark background colors 
  static const Color bgDark = Color(0xFF0A0A1A);
  static const Color bgCard = Color(0xFF12122A);
  static const Color bgSurface = Color(0xFF1A1A35);

  // Neon accent colors
  static const Color neonPurple = Color(0xFF7B2FBE);
  static const Color neonBlue = Color(0xFF4A90E2);
  static const Color neonPink = Color(0xFFE91E8C);
  static const Color neonYellow = Color(0xFFFFC107);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color neonRed = Color(0xFFFF5252);
  static const Color neonCyan = Color(0xFF00BCD4);

  // Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7B2FBE), Color(0xFF4A90E2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFE91E8C), Color(0xFFFF5252)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient yellowGradient = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0A0A1A), Color(0xFF12122A), Color(0xFF1A0A35)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0D0);
  static const Color textMuted = Color(0xFF6B6B9B);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgDark,
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: neonPurple,
          secondary: neonBlue,
          surface: bgCard,
        ),
      );
}
