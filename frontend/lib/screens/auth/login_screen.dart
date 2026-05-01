// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'register_screen.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Authservice authService = Authservice();

  bool _isLoading = false;
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  Future<void> _handleLogin() async {
    print(
      "Attempting login with email: ${_emailController.text} and password: ${_passwordController.text}",
    );

    if (!_emailKey.currentState!.validate()) return;
    if (!_passwordKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final result = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      _showMessage("Login Berhasil! Token: ${result['token']}", Colors.green);
    } else {
      _showMessage(result['message'], Colors.red);
    }
  }

  Future<void> _handleRegister() async {}

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 1. Set background full mengikuti tema surface
      backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
      resizeToAvoidBottomInset: true, // Biar pas ngetik tidak ketutup keyboard
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
                    height: 48,
                    colorFilter: ColorFilter.mode(
                      isDark ? Colors.white : AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Welcome Text
                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Log in to your account to continue",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 16,
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
                  const SizedBox(height: 16),
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
                          style: TextStyle(color: Colors.grey),
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

                    height: 52, // Sesuaikan dengan tinggi CustomButton kamu

                    child: OutlinedButton(
                      onPressed: () {
                        // Aksi Sign In Google
                      },

                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? Colors.white10 : Colors.grey.shade300,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        backgroundColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.white.withOpacity(0.5),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          // Pastikan kamu punya logo google di assets
                          Image.asset('images/google_logo.png', height: 20),

                          const SizedBox(width: 12),

                          Text(
                            "Sign in with Google",

                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : Colors.grey.shade600,

                              fontWeight: FontWeight.w500,

                              fontSize: 16,
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
                          "Register",
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
