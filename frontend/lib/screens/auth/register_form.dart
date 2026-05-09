import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/view_models/auth_viewmodel.dart';
import '../../widgets/custom_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false;
  bool _isFormValid = false;
  final AuthViewModel _authViewModel = AuthViewModel.instance;

  Future<void> _handleRegister() async {
    if (_isChecked == false || _isFormValid == false) {
      return;
    }

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showMessage("Please fill all fields", Colors.red);
      return;
    }

    final email = _emailController.text.trim();
    final atIndex = email.indexOf('@');
    final dotIndex = email.lastIndexOf('.');

    if (atIndex <= 0 ||
        dotIndex <= atIndex + 1 ||
        dotIndex >= email.length - 1) {
      _showMessage("Invalid Email Format", Colors.red);
      return;
    }

    final success = await _authViewModel.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (success == true) {
      _showMessage("Registration Success! Logging in...", Colors.green);

      final loginSuccess = await _authViewModel.login(
        _emailController.text,
        _passwordController.text,
      );

      if (loginSuccess != true) {
        _showMessage(
          "Auto-login failed: ${_authViewModel.errorMessage ?? "Login Failed"}",
          Colors.red,
        );
      }
    } else {
      _showMessage(
        _authViewModel.errorMessage ?? "Registration Failed",
        Colors.red,
      );
    }
    _authViewModel.clearErrorMessage();
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  void initState() {
    super.initState();
    // 2. Pasang listener pada kedua controller
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _nameController.addListener(_validateForm);
  }

  // Fungsi untuk mengecek apakah semua field sudah terisi
  void _validateForm() {
    setState(() {
      _isFormValid =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _nameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        CustomFormField(controller: _nameController, label: "USERNAME"),
        const SizedBox(height: 16),
        CustomFormField(controller: _emailController, label: "EMAIL"),
        const SizedBox(height: 16),
        CustomFormField(
          controller: _passwordController,
          obscureText: true,
          label: "PASSWORD",
        ),
        const SizedBox(height: 16),

        // Checkbox disini
        Row(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Agar teks panjang tetap sejajar atas dengan checkbox
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: _isChecked,
                  activeColor: AppColors.primary, // Sesuaikan dengan tema kamu
                  checkColor: isDark
                      ? AppColors.textPrimaryLight
                      : AppColors.textPrimaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: "I agree to the ",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: "Rubik",
                  ),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.primary : AppColors.secondary,
                      ),
                      // Tambahkan recognizer: TapGestureRecognizer() di sini jika ingin link bisa diklik
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Submit Button
        GestureDetector(
          onTap: _isFormValid && _isChecked
              ? () {
                  _handleRegister();
                }
              : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isFormValid && _isChecked ? 1.0 : (isDark ? 0.4 : 0.2),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 28,
                color: isDark
                    ? AppColors.textPrimaryLight
                    : AppColors.textPrimaryDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
