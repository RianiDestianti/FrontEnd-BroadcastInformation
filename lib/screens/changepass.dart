import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constant.dart';

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
      backgroundColor: AppThemeChange.backgroundColor,
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
                  label: 'NIS/NIP',
                  controller: _usernameController,
                  hintText: 'Elara Zafira (12345)',
                  validator: (value) => value?.isEmpty == true ? 'NIS/NIP wajib diisi' : null,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Kata Sandi Saat Ini',
                  controller: _currentPasswordController,
                  hintText: 'Masukkan kata sandi saat ini',
                  isPassword: true,
                  isVisible: _isCurrentPasswordVisible,
                  onToggleVisibility: () => _togglePasswordVisibility(true),
                  validator: (value) => value?.isEmpty == true ? 'Kata sandi saat ini wajib diisi' : null,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Kata Sandi Baru',
                  controller: _newPasswordController,
                  hintText: 'Masukkan kata sandi baru Anda',
                  isPassword: true,
                  isVisible: _isNewPasswordVisible,
                  onToggleVisibility: () => _togglePasswordVisibility(false),
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Kata sandi baru wajib diisi';
                    if (value!.length < 6) return 'Password minimal terdiri dari 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Ubah Password',
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
      backgroundColor: AppThemeChange.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppThemeChange.textColor),
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
        Text('Buat Kata Sandi Baru', style: AppThemeChange.headingStyle),
        const SizedBox(height: 8),
        Text(
          'Kata sandi baru Anda harus berbeda dari kata sandi yang sebelumnya digunakan.',
          style: AppThemeChange.subheadingStyle,
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
        Text(label, style: AppThemeChange.labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isVisible,
          style: GoogleFonts.poppins(),
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: AppThemeChange.hintColor),
            border: _buildBorder(AppThemeChange.borderColor),
            enabledBorder: _buildBorder(Colors.grey.shade300),
            focusedBorder: _buildBorder(AppThemeChange.primaryColor),
            errorBorder: _buildBorder(Colors.red),
            focusedErrorBorder: _buildBorder(Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            filled: true,
            fillColor: AppThemeChange.backgroundColor,
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
        color: AppThemeChange.borderColor,
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
          backgroundColor: AppThemeChange.primaryColor,
          foregroundColor: AppThemeChange.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: AppThemeChange.backgroundColor)
            : Text(text, style: AppThemeChange.buttonStyle),
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
          color: AppThemeChange.backgroundColor,
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
            CustomButton(text: 'Selesai', onPressed: onDone),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemeChange.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_rounded,
        color: AppThemeChange.primaryColor,
        size: 75,
      ),
    );
  }

  Widget _buildMessage() {
    return Column(
      children: [
        Text(
          'Berhasil!',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppThemeChange.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kata sandi Anda berhasil diubah.',
          textAlign: TextAlign.center,
          style: AppThemeChange.subheadingStyle,
        ),
      ],
    );
  }
}