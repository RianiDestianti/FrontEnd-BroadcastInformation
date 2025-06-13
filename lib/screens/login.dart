import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import '../constants/constant.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<LoginResponse> login(String id, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'login': id, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        final responseData = jsonDecode(response.body);
        return LoginResponse(
          success: false,
          message: responseData['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      print('Login error: $e');
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          await prefs.clear();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/auth/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }
      }
      return null;
    } catch (e) {
      print('Profile error: $e');
      return null;
    }
  }

  static Future<void> saveLoginData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', loginResponse.token ?? '');
    await prefs.setString('user_type', loginResponse.userType ?? '');
    await prefs.setInt('user_id', loginResponse.user?.id ?? 0);
    await prefs.setString('username', loginResponse.user?.username ?? '');

    if (loginResponse.guru != null) {
      await prefs.setString('nama', loginResponse.guru!.nama);
      await prefs.setInt('profile_id', loginResponse.guru!.id);
    } else if (loginResponse.siswa != null) {
      await prefs.setString('nama', loginResponse.siswa!.nama);
      await prefs.setInt('profile_id', loginResponse.siswa!.id);
    }
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final User? user;
  final String? userType;
  final Guru? guru;
  final Siswa? siswa;
  final String? token;
  final String? tokenType;

  LoginResponse({
    required this.success,
    required this.message,
    this.user,
    this.userType,
    this.guru,
    this.siswa,
    this.token,
    this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user:
          data != null && data['user'] != null
              ? User.fromJson(data['user'])
              : null,
      userType: data != null ? data['user_type'] : null,
      guru:
          data != null && data['guru'] != null
              ? Guru.fromJson(data['guru'])
              : null,
      siswa:
          data != null && data['siswa'] != null
              ? Siswa.fromJson(data['siswa'])
              : null,
      token: data != null ? data['token'] : null,
      tokenType: data != null ? data['token_type'] : null,
    );
  }
}

class Siswa {
  final int id;
  final String username;
  final String nama;

  Siswa({required this.id, required this.username, required this.nama});

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'],
      username: json['username'],
      nama: json['nama'],
    );
  }
}

class Guru {
  final int id;
  final String username;
  final String nama;

  Guru({required this.id, required this.username, required this.nama});

  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(id: json['id'], username: json['username'], nama: json['nama']);
  }
}

class User {
  final int id;
  final String username;
  final String role;
  final String createdAt;

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'].toString(),
      role: json['role'].toString(),
      createdAt: json['created_at'],
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

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
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppConstants.spacingXL),
                  const HeaderWidget(),
                  const SizedBox(height: AppConstants.spacingXL * 1.5),
                  const UsernameField(),
                  const SizedBox(height: AppConstants.spacingM),
                  const PasswordField(),
                  const SizedBox(height: AppConstants.spacingL * 1.5),
                  SignInButton(isLoading: _isLoading),
                  const SizedBox(height: AppConstants.spacingXL),
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
        // Logo section with divider
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/smkn.png', 
              height: 70, 
              width: 70,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: AppConstants.spacingM),
            Container(
              height: 60,
              width: 2,
              color: Colors.grey.shade400,
            ),
            const SizedBox(width: AppConstants.spacingM),
            Image.asset(
              'assets/logo.png', 
              height: 70, 
              width: 70,
              fit: BoxFit.contain,
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingL),
        Text(
          'Login',
          textAlign: TextAlign.center,
          style: SignInStyles.titleText,
        ),
        const SizedBox(height: AppConstants.spacingS),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Halo! Update Informasi penting menanti Anda.',
            textAlign: TextAlign.center,
            style: SignInStyles.subtitleText,
          ),
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
        onPressed:
            () => state.setState(
              () => state._isPasswordVisible = !state._isPasswordVisible,
            ),
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
              borderRadius: BorderRadius.circular(
                AppConstants.inputBorderRadius,
              ),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.inputBorderRadius,
              ),
              borderSide: BorderSide(
                color: SignInStyles.disabledBorderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.inputBorderRadius,
              ),
              borderSide: const BorderSide(
                color: SignInStyles.primaryColor,
                width: 2,
              ),
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
  final bool isLoading;

  const SignInButton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_SignInPageState>()!;
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6, // Mengecilkan lebar tombol
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _handleSignIn(context, state),
          style: ElevatedButton.styleFrom(
            backgroundColor: SignInStyles.primaryColor,
            padding: const EdgeInsets.symmetric(
              vertical: 12.0, // Mengurangi padding vertikal
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
            ),
            elevation: 2,
          ),
          child:
              isLoading
                  ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text('Login', style: SignInStyles.buttonText),
        ),
      ),
    );
  }

  void _handleSignIn(BuildContext context, _SignInPageState state) async {
    if (!_validateInputs(context, state)) return;

    state.setState(() {
      state._isLoading = true;
    });

    final loginResponse = await AuthService.login(
      state._usernameController.text.trim(),
      state._passwordController.text.trim(),
    );

    state.setState(() {
      state._isLoading = false;
    });

    if (loginResponse.success) {
      await AuthService.saveLoginData(loginResponse);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      _showErrorSnackBar(context, loginResponse.message);
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