import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF4A90D9);
  static const Color darkBlue = Color(0xFF2C5F8A);
  static const Color skyBlue = Color(0xFFE8F4FD);
  static const Color lightSkyBlue = Color(0xFFD4ECF9);
  static const Color green = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color orange = Color(0xFFFF9800);
  static const Color lightOrange = Color(0xFFFFF3E0);
  static const Color pink = Color(0xFFE91E63);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color purple = Color(0xFF9C27B0);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color white = Colors.white;
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color gray = Color(0xFFBDBDBD);
  static const Color darkGray = Color(0xFF757575);
  static const Color black = Color(0xFF333333);

  static const Color logoPurple = Color(0xFF9C27B0);
  static const Color logoBlue = Color(0xFF2196F3);
  static const Color logoPink = Color(0xFFE91E63);
  static const Color logoYellow = Color(0xFFFF9800);

  static const Color inputBg = Color(0xFFF0F0F0);
  static const Color bottomNavBg = Color(0xFF4CAF50);
  static const Color cardBg = Colors.white;
  static const Color lockedGray = Color(0xFFBDBDBD);

  static const Color gradTop = Color(0xFF3ABFF9);
  static const Color gradMid = Color(0xFF96F1E1);
  static const Color gradBottom = Color(0xFF41C5F7);

  static List<Color> primaryGradient = [const Color(0xFF2C5F8A), const Color(0xFF4A90D9)];
  static List<Color> levelGradient = [gradTop, gradMid, gradBottom];
}

class AppTheme {
  static ThemeData get theme {
    final textTheme = GoogleFonts.juaTextTheme();
    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
        secondary: AppColors.green,
        surface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.jua(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }
}
