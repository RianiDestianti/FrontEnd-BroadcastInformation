import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaterialApp(home: ChangePasswordScreen()));
}

class AppTheme {
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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility(bool isCurrentPassword) {
    setState(() {
      if (isCurrentPassword) {
        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
      } else {
        _isNewPasswordVisible = !_isNewPasswordVisible;
      }
    });
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        onDone: () => Navigator.of(context)..pop()..pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(onBack: () => Navigator.pop(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const ScreenHeader(),
                const SizedBox(height: 40),
                CustomTextField(
                  label: 'Username',
                  controller: _usernameController,
                  hintText: 'Elara Zafira',
                  validator: (value) => value?.isEmpty == true ? 'Username is required' : null,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Current Password',
                  controller: _currentPasswordController,
                  hintText: 'Enter your current password',
                  isPassword: true,
                  isVisible: _isCurrentPasswordVisible,
                  onToggleVisibility: () => _togglePasswordVisibility(true),
                  validator: (value) => value?.isEmpty == true ? 'Current password is required' : null,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  hintText: 'Enter your new password',
                  isPassword: true,
                  isVisible: _isNewPasswordVisible,
                  onToggleVisibility: () => _togglePasswordVisibility(false),
                  validator: (value) {
                    if (value?.isEmpty == true) return 'New password is required';
                    if (value!.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Change Password',
                  isLoading: _isLoading,
                  onPressed: _handleChangePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  const CustomAppBar({Key? key, required this.onBack}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
        onPressed: onBack,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create New Password', style: AppTheme.headingStyle),
        const SizedBox(height: 8),
        Text(
          'Your new password must be different from previous used password',
          style: AppTheme.subheadingStyle,
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isVisible = false,
    this.onToggleVisibility,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isVisible,
          style: GoogleFonts.poppins(),
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: AppTheme.hintColor),
            border: _buildBorder(AppTheme.borderColor),
            enabledBorder: _buildBorder(Colors.grey.shade300),
            focusedBorder: _buildBorder(AppTheme.primaryColor),
            errorBorder: _buildBorder(Colors.red),
            focusedErrorBorder: _buildBorder(Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            filled: true,
            fillColor: AppTheme.backgroundColor,
            suffixIcon: isPassword ? _buildSuffixIcon() : null,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color),
    );
  }

  Widget? _buildSuffixIcon() {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
        color: AppTheme.borderColor,
      ),
      onPressed: onToggleVisibility,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: AppTheme.backgroundColor)
            : Text(text, style: AppTheme.buttonStyle),
      ),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final VoidCallback onDone;
  const SuccessDialog({Key? key, required this.onDone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(height: 24),
            _buildMessage(),
            const SizedBox(height: 24),
            CustomButton(text: 'Done', onPressed: onDone),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_rounded,
        color: AppTheme.primaryColor,
        size: 75,
      ),
    );
  }

  Widget _buildMessage() {
    return Column(
      children: [
        Text(
          'Success!',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your password has been changed successfully',
          textAlign: TextAlign.center,
          style: AppTheme.subheadingStyle,
        ),
      ],
    );
  }
}