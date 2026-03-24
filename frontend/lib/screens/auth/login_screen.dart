// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Menggunakan resizeToAvoidBottomInset agar keyboard tidak merusak background
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // LAYER 1: Gambar Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                // KUNCI: Pilih gambar berdasarkan status isDark
                image: AssetImage(
                  isDark
                      ? 'images/Background_Dark.jpg' // Gambar untuk mode gelap
                      : 'images/Background_Light.jpg', // Gambar untuk mode terang
                ),
                fit: BoxFit.cover,

                // Opsional: Tetap gunakan colorFilter agar teks form tetap terbaca jelas
                colorFilter: ColorFilter.mode(
                  (isDark ? Colors.black : Colors.white).withOpacity(0.3),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),

          // LAYER 2: Overlay semi-transparan (Opsional, agar gambar tidak terlalu kontras)
          Container(color: Colors.black.withOpacity(isDark ? 0.3 : 0.0)),

          // LAYER 3: Container Form
          Center(
            child: SingleChildScrollView(
              // Agar aman di layar kecil
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    // Mengambil warna surface sesuai tema
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
                    mainAxisSize:
                        MainAxisSize.min, // Container akan menyesuaikan isi
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'images/Genshin_Import_logo.svg',
                        height: 30,
                        // Kamu juga bisa menambahkan colorFilter jika ingin
                        // mengubah warna SVG secara dinamis berdasarkan tema
                        colorFilter: ColorFilter.mode(
                          isDark ? Colors.white : AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Account Log In",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 32),

                      CustomTextField(
                        label: "Email",
                        placeholder: "example@gmail.com",
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Password",
                        placeholder: "at least 8 characters",
                        controller: _passwordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: 32),

                      CustomButton(
                        text: "Log In",
                        onPressed: () {
                          // Aksi Login
                        },
                      ),

                      const SizedBox(height: 24),

                      // PEMISAH "OR"
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "or you could",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                              thickness: 1,
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
                              color: isDark
                                  ? Colors.white10
                                  : Colors.grey.shade300,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.shade50,
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

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
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
                                fontWeight: FontWeight.w600,
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
