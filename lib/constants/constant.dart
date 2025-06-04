import 'package:flutter/material.dart';

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

