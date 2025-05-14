import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

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
      home: const SignInPage(),
    );
  }

  ThemeData _buildAppTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: AppTheme.createMaterialColor(AppTheme.themeColor),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SignInLayout.horizontalPadding,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  SizedBox(height: SignInLayout.verticalSpacingLarge),
                  SignInHeader(),
                  SizedBox(height: SignInLayout.verticalSpacingLarge),
                  UsernameField(),
                  SizedBox(height: SignInLayout.verticalSpacingMedium),
                  PasswordField(),
                  ForgotPasswordButton(),
                  SizedBox(height: SignInLayout.verticalSpacingSmall),
                  SignInButton(),
                  SizedBox(height: SignInLayout.verticalSpacingMedium),
                  GoogleSignInButton(),
                  SizedBox(height: SignInLayout.verticalSpacingMedium),
                  SignUpPrompt(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInHeader extends StatelessWidget {
  const SignInHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sign In',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: SignInLayout.verticalSpacingSmall),
        Text(
          'Hi! Welcome back, you\'ve been missed',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}

class UsernameField extends StatelessWidget {
  const UsernameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: SignInLayout.verticalSpacingSmall),
        TextField(
          decoration: InputDecorationStyles.standard('Enter your username'),
        ),
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: SignInLayout.verticalSpacingSmall),
        TextField(
          obscureText: true,
          decoration: InputDecorationStyles.standard('Enter your password'),
        ),
      ],
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'forgot password?',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToHome(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.themeColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SignInLayout.buttonBorderRadius),
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
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Image.asset('assets/google.png', height: 24, width: 24),
      label: Text(
        'Sign in with Google',
        style: GoogleFonts.poppins(color: Colors.black),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SignInLayout.buttonBorderRadius),
        ),
      ),
    );
  }
}

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            style: GoogleFonts.poppins(color: AppTheme.themeColor),
          ),
        ),
      ],
    );
  }
}

class AppTheme {
  static const Color themeColor = Color(0xFF57B4BA);
  static const double defaultBorderRadius = 8.0;
  static MaterialColor createMaterialColor(Color color) {
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

class SignInLayout {
  static const double horizontalPadding = 24.0;
  static const double verticalSpacingLarge = 40.0;
  static const double verticalSpacingMedium = 16.0;
  static const double verticalSpacingSmall = 8.0;
  static const double inputBorderRadius = 20.0;
  static const double buttonBorderRadius = 30.0;
}

class InputDecorationStyles {
  static InputDecoration standard(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SignInLayout.inputBorderRadius),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
