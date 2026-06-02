import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/view_models/auth_viewmodel.dart';
import 'package:frontend/widgets/app_message_dialog.dart';
import '../../widgets/custom_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthViewModel _authViewModel = AuthViewModel.instance;

  Future<void> _handleLogin() async {
    if (_authViewModel.isLoading) {
      return;
    }

    final success = await _authViewModel.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success == true) {
      _showMessage("Login Success!", Colors.green);
    } else if (_authViewModel.emailError == null &&
        _authViewModel.passwordError == null) {
      final message = _authViewModel.errorMessage ?? "Login Failed";

      if (message == "User not found" || message == "Wrong password") {
        await _showLoginErrorDialog(message);
      } else {
        _showMessage(message, Colors.red);
      }
    }

    _authViewModel.clearErrorMessage();
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> _showLoginErrorDialog(String message) {
    return showAppMessageDialog(
      context: context,
      title: 'Login Failed',
      message: message,
      confirmText: 'Oke',
      icon: Icons.error_outline_outlined,
      iconColor: Colors.red,
    );
    // return showDialog<void>(
    //   context: context,
    //   builder: (context) {
    //     final isDark = Theme.of(context).brightness == Brightness.dark;

    //     return AlertDialog(
    //       backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
    //       title: const Text("Login Failed"),
    //       content: Text(message),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           child: const Text("Oke"),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _authViewModel,
      builder: (context, child) {
        return Column(
          children: [
            CustomFormField(
              label: "EMAIL",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _authViewModel.emailError,
              onChanged: (_) => _authViewModel.clearEmailError(),
            ),
            const SizedBox(height: 16),
            CustomFormField(
              obscureText: true,
              label: "PASSWORD",
              controller: _passwordController,
              errorText: _authViewModel.passwordError,
              onChanged: (_) => _authViewModel.clearPasswordError(),
            ),

            const SizedBox(height: 20),

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

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _authViewModel.isLoading
                    ? null
                    : () async {
                        final success = await _authViewModel.loginWithGoogle();
                        if (!context.mounted) return;

                        if (success) {
                          _showMessage("Google Login Success!", Colors.green);
                        } else {
                          _showMessage(
                            _authViewModel.errorMessage ??
                                "Google Login Failed",
                            Colors.red,
                          );
                        }
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
                              : AppColors.textPrimaryLight.withValues(
                                  alpha: 0.6,
                                ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),

            GestureDetector(
              onTap: _authViewModel.isLoading ? null : _handleLogin,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _authViewModel.isLoading
                      ? SizedBox(
                          key: const ValueKey("login-loading"),
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.6,
                            color: isDark
                                ? AppColors.textPrimaryLight
                                : AppColors.textPrimaryDark,
                          ),
                        )
                      : Icon(
                          Icons.arrow_forward_rounded,
                          key: const ValueKey("login-arrow"),
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
      },
    );
  }
}
