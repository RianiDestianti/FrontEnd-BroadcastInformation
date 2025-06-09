import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import '../constants/constant.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  SizedBox(height: AppConstants.spacingXL),
                  HeaderWidget(),
                  SizedBox(height: AppConstants.spacingXL),
                  UsernameField(),
                  SizedBox(height: AppConstants.spacingM),
                  PasswordField(),
                  SizedBox(height: AppConstants.spacingL),
                  SignInButton(),
                  SizedBox(height: AppConstants.spacingM),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Login', textAlign: TextAlign.center, style: SignInStyles.titleText),
        const SizedBox(height: AppConstants.spacingS),
        Text(
          'Halo! Update Informasi penting menanti Anda.',
          textAlign: TextAlign.center,
          style: SignInStyles.subtitleText,
        ),
      ],
    );
  }
}

class UsernameField extends StatelessWidget {
  const UsernameField({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_SignInPageState>()!;
    return InputField(
      label: 'NIS/NIP',
      controller: state._usernameController,
      hintText: 'Masukkan NIS/NIP anda',
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_SignInPageState>()!;
    return InputField(
      label: 'Password',
      controller: state._passwordController,
      hintText: 'Masukkan password anda',
      isPassword: true,
      obscureText: !state._isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          state._isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: SignInStyles.hintColor,
        ),
        onPressed: () => state.setState(() => state._isPasswordVisible = !state._isPasswordVisible),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SignInStyles.labelText),
        const SizedBox(height: AppConstants.spacingS),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: SignInStyles.hintText,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SignInStyles.inputPaddingHorizontal,
              vertical: SignInStyles.inputPaddingVertical,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
              borderSide: BorderSide(color: SignInStyles.disabledBorderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
              borderSide: const BorderSide(color: SignInStyles.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_SignInPageState>()!;
    return ElevatedButton(
      onPressed: () => _handleSignIn(context, state),
      style: ElevatedButton.styleFrom(
        backgroundColor: SignInStyles.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: SignInStyles.buttonPaddingVertical),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        elevation: 0,
      ),
      child: Text('Login', style: SignInStyles.buttonText),
    );
  }

  void _handleSignIn(BuildContext context, _SignInPageState state) {
    if (_validateInputs(context, state)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  bool _validateInputs(BuildContext context, _SignInPageState state) {
    if (state._usernameController.text.trim().isEmpty) {
      _showErrorSnackBar(context, 'Please enter your username');
      return false;
    }
    if (state._passwordController.text.trim().isEmpty) {
      _showErrorSnackBar(context, 'Please enter your password');
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SignInStyles.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}