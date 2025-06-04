import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF57B4BA);
  static const Color primaryLight = Color(0xFFE8F5F6);
  static const Color primaryUltraLight = Color(0xFFF0F9FA);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFF50C2C9);
}

class SplashConstants {
  static const animationDuration = Duration(milliseconds: 1500);
  static const rotationDuration = Duration(milliseconds: 5000);
  static const pulseDuration = Duration(milliseconds: 1500);
  static const textAnimationDuration = Duration(milliseconds: 1200);
  static const loadingDuration = Duration(milliseconds: 2000);
  static const navigationDelay = Duration(milliseconds: 6000);
  static const navigationTransitionDuration = Duration(milliseconds: 800);
  static const themeColor = Color(0xFF57B4BA);
  static const smknLogoDelay = Duration(milliseconds: 300);
  static const textAnimationDelay = Duration(milliseconds: 1200);
}

class AppTheme {
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textTertiary = Color(0xFF666666);
  static const Color backgroundPrimary = Colors.white;
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFF8F8F8);
  static const Color shadowColor = Color(0x0D000000);
  static const Color iconColor = Color(0xFF9E9E9E);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets cardBottomMargin = EdgeInsets.only(bottom: 12);
  static const double defaultSpacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double tinySpacing = 4.0;
  static const double cardRadius = 25.0;
  static const double badgeRadius = 24.0;
  static const double containerRadius = 12.0;
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
    color: textPrimary,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    color: textSecondary,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle cardTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    fontFamily: 'Poppins',
    color: textPrimary,
    height: 1.3,
  );
  
  static const TextStyle infoTextStyle = TextStyle(
    color: textTertiary,
    fontSize: 11,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
}

class AppConstants {
  static const Color primaryColor = Color(0xFF57B4BA);
  static const double horizontalPadding = 24.0;
  static const double spacingXL = 40.0;
  static const double spacingL = 32.0;
  static const double spacingM = 16.0;
  static const double spacingS = 8.0;
  static const double defaultBorderRadius = 8.0;
  static const double inputBorderRadius = 20.0;
  static const double buttonBorderRadius = 30.0;
  static MaterialColor createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}

class AppThemeChange {
  static const Color primaryColor = Color(0xFF57B4BA);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;
  static const Color hintColor = Colors.black54;
  static const Color borderColor = Colors.grey;
  
  static TextStyle get headingStyle => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static TextStyle get subheadingStyle => GoogleFonts.poppins(
    fontSize: 16,
    color: hintColor,
  );
  
  static TextStyle get labelStyle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
  
  static TextStyle get buttonStyle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

class AppThemeProfile {
  static const Color primaryColor = Color(0xFF57B4BA);
  static const double horizontalPadding = 24.0;
  static const double borderRadius = 16.0;
  static const double defaultSpacing = 16.0;
}