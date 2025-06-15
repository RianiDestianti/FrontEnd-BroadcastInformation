import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// calendar
class AppColors {
  static const Color primary = Color(0xFF57B4BA);
  static const Color primaryLight = Color(0xFFE8F5F6);
  static const Color primaryUltraLight = Color(0xFFF0F9FA);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFF50C2C9);
}

// splash
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

// profile
class AppTheme {
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textTertiary = Color(0xFF666666);
  static const Color backgroundPrimary = Colors.white;
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFF8F8F8);
  static const Color shadowColor = Color(0x0D000000);
  static const Color iconColor = Color(0xFF9E9E9E);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: 20,
  );
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

// login
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

// profile
class AppThemeProfile {
  static const Color primaryColor = Color(0xFF57B4BA);
  static const double horizontalPadding = 24.0;
  static const double borderRadius = 16.0;
  static const double defaultSpacing = 16.0;
}

// profile
class ProfileStyles {
  static const double avatarRadius = 55.0;
  static const double innerAvatarRadius = 50.0;
  static const double cardPadding = 20.0;
  static const double dialogPadding = 24.0;
  static const double logoSize = 60.0;
  static final TextStyle titleStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle nameStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle labelStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey[600],
  );
  static final TextStyle valueStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  );
  static final BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(0, 2),
  );
}

// splash
class SplashStyles {
  static const Color themeColor = Color(0xFF57B4BA);
  static const double logoSize = 90.0;
  static const double circleSize = 280.0;
  static const double dotSize = 10.0;
  static const double loadingDotSize = 10.0;
  static const double backgroundLogoSizeFactor = 1.5;
  static const double backgroundLogoOpacity = 0.08;
  static const double shadowOpacity = 0.25;
  static const double borderOpacity = 0.15;

  static const TextStyle titleStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: 1.2,
  );
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    color: Colors.black54,
  );
  static const TextStyle footerStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );
  static const TextStyle versionStyle = TextStyle(
    color: Colors.black38,
    fontSize: 12,
  );
}

// login
class SignInStyles {
  static const Color primaryColor = AppConstants.primaryColor;
  static const Color hintColor = Colors.grey;
  static const Color disabledBorderColor = Color(
    0xFFEEEEEE,
  ); 
  static const Color errorColor = Colors.red;
  static const double titleFontSize = 28.0;
  static const double subtitleFontSize = 16.0;
  static const double labelFontSize = 16.0;
  static const double buttonFontSize = 16.0;
  static const double buttonPaddingVertical = 12.0;
  static const double inputPaddingHorizontal = 20.0;
  static const double inputPaddingVertical = 16.0;

  static final TextStyle titleText = GoogleFonts.poppins(
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle subtitleText = GoogleFonts.poppins(
    fontSize: subtitleFontSize,
    color: Colors.black54,
  );
  static final TextStyle labelText = GoogleFonts.poppins(
    fontSize: labelFontSize,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle buttonText = GoogleFonts.poppins(
    fontSize: buttonFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static final TextStyle hintText = GoogleFonts.poppins(
    color: Colors.grey[600],
  );
}

// popup
class PopupStyles {
  static const Color background = Colors.white;
  static const Color shadow = Colors.black12;
  static const Color iconColor = Colors.black54;
  static const Color bulletColor = Colors.black87;
  static const Color infoIconColor = Colors.grey;
  static const double maxHeightFactor = 0.8;
  static const double maxWidthFactor = 0.9;
  static const double borderRadius = 20.0;
  static const double tagRadius = 16.0;
  static const double imageHeight = 150.0;
  static const double paddingSmall = 4.0;
  static const double paddingMedium = 8.0;
  static const double paddingLarge = 12.0;
  static const double paddingXLarge = 16.0;
  static const double paddingXXLarge = 20.0;
  static const double spacingSmall = 6.0;
  static const double spacingMedium = 8.0;
  static const double spacingLarge = 10.0;
  static const double spacingXLarge = 12.0;
  static const double spacingXXLarge = 16.0;
  static const double spacingXXXLarge = 24.0;
  static const double tagFontSize = 13.0;
  static const double titleFontSize = 18.0;
  static const double contentFontSize = 14.0;
  static const double sectionTitleFontSize = 14.0;
  static const double iconSizeSmall = 18.0;
  static const double bulletSize = 4.0;
  static const double closeButtonPadding = 8.0;
  static const double contentLineHeight = 1.5;

  static final TextStyle tag = GoogleFonts.poppins(
    fontSize: tagFontSize,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  static final TextStyle title = GoogleFonts.poppins(
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle content = GoogleFonts.poppins(
    fontSize: contentFontSize,
    height: contentLineHeight,
  );
  static final TextStyle sectionTitle = GoogleFonts.poppins(
    fontSize: sectionTitleFontSize,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle conclusion = GoogleFonts.poppins(
    fontSize: contentFontSize,
    fontStyle: FontStyle.italic,
  );

  static const BoxShadow closeButtonShadow = BoxShadow(
    color: shadow,
    blurRadius: 4,
    offset: Offset(0, 2),
  );
}

// home
class HomeStyles {
  static const Color white = Colors.white;
  static const Color textDark = Colors.black87;
  static const MaterialColor textGrey = Colors.grey;
  static const Color blue = Colors.blue;
  static const Color shadow = Colors.black;
  static const Color red = Colors.red;
  static const double paddingSmall = 4.0;
  static const double paddingMedium = 8.0;
  static const double paddingLarge = 12.0;
  static const double paddingXLarge = 16.0;
  static const double paddingXXLarge = 20.0;
  static const double paddingXXXLarge = 24.0;
  static const double paddingXXXXLarge = 30.0;
  static const double paddingXXXXXLarge = 40.0;
  static const double spacingSmall = 3.0;
  static const double spacingMedium = 4.0;
  static const double spacingLarge = 6.0;
  static const double spacingXLarge = 8.0;
  static const double spacingXXLarge = 12.0;
  static const double spacingXXXLarge = 16.0;
  static const double spacingXXXXLarge = 20.0;
  static const double spacingXXXXXLarge = 24.0;
  static const double spacingXXXXXXLarge = 30.0;
  static const double borderRadiusSmall = 6.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  static const double borderRadiusXXLarge = 20.0;
  static const double borderRadiusXXXLarge = 26.0;
  static const double fontSizeXSmall = 11.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 13.0;
  static const double fontSizeLarge = 14.0;
  static const double fontSizeXLarge = 16.0;
  static const double fontSizeXXLarge = 18.0;
  static const double fontSizeXXXLarge = 22.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 18.0;
  static const double iconSizeLarge = 22.0;
  static const double iconSizeXLarge = 26.0;
  static const double iconSizeXXLarge = 64.0;
  static const double bannerHeight = 180.0;
  static const double categoryHeight = 110.0;
  static const double searchBarHeight = 52.0;
  static const double categoryCircleSize = 64.0;
  static const double indicatorHeight = 8.0;
  static const double indicatorWidthActive = 24.0;
  static const double indicatorWidthInactive = 8.0;
  static const double borderWidth = 2.5;
  static const double lineHeight = 1.4;

  static final TextStyle welcome = GoogleFonts.poppins(
    fontSize: fontSizeXXXLarge,
    fontWeight: FontWeight.bold,
    color: textDark,
  );
  static final TextStyle date = GoogleFonts.poppins(
    fontSize: fontSizeLarge,
    color: textGrey[600],
  );
  static final TextStyle searchHint = GoogleFonts.poppins(
    fontSize: fontSizeLarge,
    color: textGrey[500],
  );
  static final TextStyle sectionTitle = GoogleFonts.poppins(
    fontSize: fontSizeXXLarge,
    fontWeight: FontWeight.bold,
    color: textDark,
  );
  static final TextStyle bannerTag = GoogleFonts.poppins(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w500,
    color: white,
  );
  static final TextStyle bannerTitle = GoogleFonts.poppins(
    fontSize: fontSizeXLarge,
    fontWeight: FontWeight.bold,
    color: white,
  );
  static final TextStyle bannerSubtitle = GoogleFonts.poppins(
    fontSize: fontSizeSmall,
    color: white,
  );
  static final TextStyle categoryName = GoogleFonts.poppins(
    fontSize: fontSizeXSmall,
    fontWeight: FontWeight.w500,
    color: textDark,
  );
  static final TextStyle categoryNameSelected = categoryName.copyWith(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static final TextStyle filterLabel = GoogleFonts.poppins(
    fontSize: fontSizeMedium,
    color: textGrey[600],
  );
  static final TextStyle filterTag = GoogleFonts.poppins(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w500,
    color: white,
  );
  static final TextStyle clearFilter = GoogleFonts.poppins(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w500,
    color: textGrey[800],
  );
  static final TextStyle announcementTag = GoogleFonts.poppins(
    fontSize: fontSizeXSmall,
    fontWeight: FontWeight.w500,
    color: white,
  );
  static final TextStyle announcementTime = GoogleFonts.poppins(
    fontSize: fontSizeSmall,
    color: textGrey[500],
  );
  static final TextStyle announcementTitle = GoogleFonts.poppins(
    fontSize: fontSizeXLarge,
    fontWeight: FontWeight.bold,
    color: textDark,
  );
  static final TextStyle announcementDescription = GoogleFonts.poppins(
    fontSize: fontSizeLarge,
    color: textGrey[600],
    height: lineHeight,
  );
  static final TextStyle urgentLabel = GoogleFonts.poppins(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w600,
    color: red,
  );
  static final TextStyle emptyTitle = GoogleFonts.poppins(
    fontSize: fontSizeXLarge,
    fontWeight: FontWeight.w500,
    color: textGrey[600],
  );
  static final TextStyle emptySubtitle = GoogleFonts.poppins(
    fontSize: fontSizeLarge,
    color: textGrey[500],
  );
}
