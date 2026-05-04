import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/screens/auth/register_form.dart';
import 'login_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).size.height * 0.08,
            20,
            24,
          ),

          child: Column(
            children: [
              // Logo SVG
              SvgPicture.asset(
                'images/Genshin_Import_logo.svg',
                height: 48,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  BlendMode.srcIn,
                ),
              ),

              const SizedBox(height: 32),

              /// 🔄 TAB SWITCHER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUnderlineTab(
                    icon: Icons.login_rounded,
                    text: "Sign-in",
                    isActive: isLogin,
                    onTap: () => setState(() => isLogin = true),
                  ),
                  const SizedBox(width: 32),
                  _buildUnderlineTab(
                    icon: Icons.app_registration_outlined,
                    text: "Register",
                    isActive: !isLogin,
                    onTap: () => setState(() => isLogin = false),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// 🧾 TITLE
              Text(
                isLogin ? "Welcome Back" : "Create Account",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "HyWenhei",
                ),
              ),

              const SizedBox(height: 6),

              /// 🧾 SUBTITLE
              Text(
                isLogin
                    ? "Sign-in to your account to continue"
                    : "Please fill this form to register",
                style: const TextStyle(color: AppColors.textSecondaryLight),
              ),

              const SizedBox(height: 24),

              /// 🔥 FORM (flexible + scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: isLogin
                        ? const LoginForm(key: ValueKey("login"))
                        : const RegisterForm(key: ValueKey("register")),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 CUSTOM TAB
  Widget _buildUnderlineTab({
    required IconData icon,
    required String text,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON (muncul kalau aktif)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isActive
                    ? Row(
                        key: const ValueKey("icon"),
                        children: [
                          Icon(
                            icon,
                            size: 18,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                          const SizedBox(width: 6),
                        ],
                      )
                    : const SizedBox(key: ValueKey("no-icon")),
              ),

              /// TEXT
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight)
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// UNDERLINE
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isActive ? 50 : 0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
