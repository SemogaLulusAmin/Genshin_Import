// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'register_screen.dart';
import '../../services/auth_service.dart';
import '../../states/auth_state.dart';
import '../../widgets/header/money_badge.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Authservice authService = Authservice();

  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  Future<void> _handleLogin() async {
    if (!_emailKey.currentState!.validate() ||
        !_passwordKey.currentState!.validate()) {
      return;
    }

    final result = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (result['success'] == true) {
      _showMessage("Login Success!", Colors.green);

      isLoggedIn.value = true;
      
      // Wait for MoneyBadge to be created, then refresh it
      Future.delayed(const Duration(milliseconds: 500), () {
        MoneyBadge.refresh();
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo SVG
                  SvgPicture.asset(
                    'images/Genshin_Import_logo.svg',
                    height: 52,
                    colorFilter: ColorFilter.mode(
                      isDark ? Colors.white : AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Welcome Text
                  Text(
                    "Welcome back",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Log in to your account to continue",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Form(
                    key: _emailKey,
                    child:
                        // Form Fields
                        CustomTextField(
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

                  const SizedBox(height: 32),

                  // Main Button
                  CustomButton(text: "Log In", onPressed: _handleLogin),

                  const SizedBox(height: 24),

                  // Divider OR
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
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: isDark ? Colors.white12 : Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // TOMBOL GOOGLE
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
                              ? AppColors.textSecondaryLight
                              : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// 🔹 TEXT (CENTER BENERAN)
                          Center(
                            child: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight.withOpacity(
                                        0.6,
                                      ),
                              ),
                            ),
                          ),

                          /// 🔹 ICON (KIRI)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/google_logo.png',
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Footer Nav
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up here",
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
