// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/services/auth_service.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../core/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Authservice authService = Authservice();

  // State untuk Checkbox
  bool _isTermsAgreed = false;
  bool _isNewsletterAgreed = false;

  final _usernameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  Future<void> _handleRegister() async {
    if (!_usernameKey.currentState!.validate() ||
        !_emailKey.currentState!.validate() ||
        !_passwordKey.currentState!.validate()) {
      return;
    }

    if (!_isTermsAgreed) {
      _showMessage("You must agree to the Terms and Conditions", Colors.red);
      return;
    }

    final result = await authService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (result['success'] == true) {
      _showMessage("Registration Success!", Colors.green);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'images/Genshin_Import_logo.svg',
                    height: 52,
                    colorFilter: ColorFilter.mode(
                      isDark ? Colors.white : AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Create account",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Form(
                    key: _usernameKey,
                    child: CustomTextField(
                      label: "Username",
                      placeholder: "enter your username",
                      controller: _nameController,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Form(
                    key: _emailKey,
                    child: CustomTextField(
                      label: "Email",
                      placeholder: "example@gmail.com",
                      controller: _emailController,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Form(
                    key: _passwordKey,
                    child: CustomTextField(
                      label: "Password",
                      placeholder: "at least 8 characters",
                      controller: _passwordController,
                      isPassword: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CHECKBOX 1: Terms & Conditions (Required)
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _isTermsAgreed,
                          activeColor: AppColors.primary,
                          side: BorderSide(
                            color: isDark
                                ? Colors.white30
                                : Colors.grey.shade500,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              4,
                            ), // Semakin besar angka, semakin bulat
                          ),
                          onChanged: (value) =>
                              setState(() => _isTermsAgreed = value!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "I agree to the Terms of Service and Privacy Policy",
                          style: TextStyle(color: textSecondary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // CHECKBOX 2: Newsletter (Optional)
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _isNewsletterAgreed,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              4,
                            ), // Semakin besar angka, semakin bulat
                          ),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white30
                                : Colors.grey.shade500,
                            width: 1.5,
                          ),
                          onChanged: (value) =>
                              setState(() => _isNewsletterAgreed = value!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Keep me updated with special offers and news",
                          style: TextStyle(color: textSecondary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Main Button dengan Validasi
                  CustomButton(
                    text: "Sign Up",
                    onPressed: () {
                      _handleRegister();
                    },
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: textSecondary, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Log in here",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
