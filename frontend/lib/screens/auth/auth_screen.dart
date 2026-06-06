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
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

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
              SvgPicture.asset(
                'assets/images/Genshin_Import_logo.svg',
                height: 48,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  BlendMode.srcIn,
                ),
              ),

              const SizedBox(height: 32),

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

              Text(
                isLogin ? "Welcome Back" : "Create Account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "HyWenhei",
                  color: textColor,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                isLogin
                    ? "Sign-in to your account to continue"
                    : "Please fill this form to register",
                style: TextStyle(color: secondaryTextColor),
              ),

              const SizedBox(height: 24),

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

  Widget _buildUnderlineTab({
    required IconData icon,
    required String text,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isActive
                    ? Row(
                        key: const ValueKey("icon"),
                        children: [
                          Icon(icon, size: 18, color: textColor),
                          const SizedBox(width: 6),
                        ],
                      )
                    : const SizedBox(key: ValueKey("no-icon")),
              ),

              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? textColor : secondaryTextColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

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
