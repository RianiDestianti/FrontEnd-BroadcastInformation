import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/profile.dart';
import 'screens/changepassword.dart';
import 'screens/save.dart';
import 'screens/calendar.dart';
import 'screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(context),
      home: const SplashScreen(),
      routes: _buildAppRoutes(),
    );
  }

  ThemeData _buildAppTheme(BuildContext context) {
    final themeColor = const Color(0xFF57B4BA);
    return ThemeData(
      primarySwatch: MaterialColor(themeColor.value, <int, Color>{
        50: themeColor.withOpacity(0.1),
        100: themeColor.withOpacity(0.2),
        200: themeColor.withOpacity(0.3),
        300: themeColor.withOpacity(0.4),
        400: themeColor.withOpacity(0.5),
        500: themeColor.withOpacity(0.6),
        600: themeColor.withOpacity(0.7),
        700: themeColor.withOpacity(0.8),
        800: themeColor.withOpacity(0.9),
        900: themeColor.withOpacity(1.0),
      }),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      '/home': (context) => const HomePage(),
      '/login': (context) => const SignInPage(),
      '/profile': (context) => const ProfilePage(),
      '/save': (context) => const SaveScreen(),
      '/change-password': (context) => const ChangePasswordScreen(),
      '/calendar': (context) => CalendarPage(),
    };
  }
}
