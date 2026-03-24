// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../core/app_colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller tambahan untuk Register
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // LAYER 1: Gambar Background (Sama dengan Login)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isDark
                      ? 'images/Background_Dark.jpg'
                      : 'images/Background_Light.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  (isDark ? Colors.black : Colors.white).withOpacity(0.3),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),

          // LAYER 2: Overlay
          Container(color: Colors.black.withOpacity(isDark ? 0.3 : 0.0)),

          // LAYER 3: Container Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDark
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'images/Genshin_Import_logo.svg',
                        height: 30,
                        colorFilter: ColorFilter.mode(
                          isDark ? Colors.white : AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Register Account", // Judul dibedakan
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // INPUT 1: Full Name
                      CustomTextField(
                        label: "Username",
                        placeholder: "enter your username",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),

                      // INPUT 2: Email
                      CustomTextField(
                        label: "Email",
                        placeholder: "example@gmail.com",
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),

                      // INPUT 3: Password
                      CustomTextField(
                        label: "Password",
                        placeholder: "at least 8 characters",
                        controller: _passwordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: 32),

                      // Tombol Register
                      CustomButton(
                        text: "Sign Up",
                        onPressed: () {
                          // Aksi Register
                        },
                      ),

                      const SizedBox(height: 24),

                      // Footer: Navigasi Balik ke Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Kembali ke Login
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Log In",
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
        ],
      ),
    );
  }
}
