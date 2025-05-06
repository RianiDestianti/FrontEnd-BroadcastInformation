import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const Color themeColor = Color(0xFF57B4BA);
  static const double defaultBorderRadius = 8.0;
  
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(context),
      home: const SignInPage(),
    );
  }
  
  ThemeData _buildAppTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: _createMaterialColor(themeColor),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
  
  MaterialColor _createMaterialColor(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}

class SignInPage extends StatelessWidget {
  static const Color themeColor = MyApp.themeColor;
  static const double horizontalPadding = 24.0;
  static const double verticalSpacingLarge = 40.0;
  static const double verticalSpacingMedium = 16.0;
  static const double verticalSpacingSmall = 8.0;
  static const double inputBorderRadius = 20.0;
  static const double buttonBorderRadius = 30.0;
  
  const SignInPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: verticalSpacingLarge),
                  _buildHeader(),
                  const SizedBox(height: verticalSpacingLarge),
                  _buildUsernameField(),
                  const SizedBox(height: verticalSpacingMedium),
                  _buildPasswordField(),
                  _buildForgotPasswordButton(),
                  const SizedBox(height: verticalSpacingSmall),
                  _buildSignInButton(context),
                  const SizedBox(height: verticalSpacingMedium),
                  _buildGoogleSignInButton(),
                  const SizedBox(height: verticalSpacingMedium),
                  _buildSignUpPrompt(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Sign In',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: verticalSpacingSmall),
        Text(
          'Hi! Welcome back, you\'ve been missed',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
  
  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: verticalSpacingSmall),
        TextField(
          decoration: _buildInputDecoration('Enter your username'),
        ),
      ],
    );
  }
  
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: verticalSpacingSmall),
        TextField(
          obscureText: true,
          decoration: _buildInputDecoration('Enter your password'),
        ),
      ],
    );
  }
  
  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
  
  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'forgot password?',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToHome(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: themeColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
      child: Text(
        'Sign In',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  
  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
  
  Widget _buildGoogleSignInButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Image.asset(
        'assets/google.jpg',
        height: 24,
        width: 24,
      ),
      label: Text(
        'Sign in with Google',
        style: GoogleFonts.poppins(color: Colors.black),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
    );
  }
  
  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have account?',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Sign Up',
            style: GoogleFonts.poppins(color: themeColor),
          ),
        ),
      ],
    );
  }
}