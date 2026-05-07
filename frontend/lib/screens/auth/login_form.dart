import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/services/auth_service.dart';
import '../../widgets/custom_form_field.dart';
import 'package:frontend/states/auth_state.dart';

class LoginForm extends StatefulWidget {
  // 👈 Ubah ke StatefulWidget
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // 1. Definisikan Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Authservice authService = Authservice();
  bool _isFormValid = false;

  Future<void> _handleLogin() async {
    if (_isFormValid == false) {
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

    final result = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (result['success'] == true) {
      _showMessage("Login Success!", Colors.green);

      isLoggedIn.value = true;
    } else {
      _showMessage(result['message'], Colors.red);
    }
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
  }

  // Fungsi untuk mengecek apakah semua field sudah terisi
  void _validateForm() {
    setState(() {
      _isFormValid =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // 3. Jangan lupa dispose agar tidak memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Pastikan CustomFormField kamu menerima parameter 'controller'
        CustomFormField(label: "EMAIL", controller: _emailController),
        const SizedBox(height: 16),
        CustomFormField(
          obscureText: true,
          label: "PASSWORD",
          controller: _passwordController,
        ),

        const SizedBox(height: 20),

        // ... (Bagian Divider "or you could" tetap sama) ...
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? Colors.white12 : Colors.grey.shade300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "or you could",
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? Colors.white12 : Colors.grey.shade300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Google Sign In
        SizedBox(
          width: double.infinity,

          height: 52,

          child: OutlinedButton(
            onPressed: () {
              // TODO: Google Sign In
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark
                    ? AppColors.textSecondaryLight.withValues(alpha: 0.6)
                    : AppColors.border,

                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    "SIGN IN WITH GOOGLE",

                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 0.4,

                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight.withOpacity(0.6),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/google_logo.png', height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),

        // Next Button
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isFormValid ? 1.0 : 0.4,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isFormValid ? _handleLogin : null,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  borderRadius: BorderRadius.circular(16),
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
        ),
      ],
    );
  }
}
