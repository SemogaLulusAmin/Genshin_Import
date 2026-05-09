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
  final AuthViewModel _authViewModel = AuthViewModel.instance;

  Future<void> _handleRegister() async {
    if (_authViewModel.isLoading) {
      return;
    }

    if (!_isChecked) {
      _showMessage("Please agree to the terms first", Colors.red);
      return;
    }

    final success = await _authViewModel.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success == true) {
      _showMessage("Registration Success!", Colors.green);
    } else if (_authViewModel.nameError == null &&
        _authViewModel.emailError == null &&
        _authViewModel.passwordError == null) {
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
  void dispose() {
    _nameController.dispose();
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
              controller: _nameController,
              label: "USERNAME",
              errorText: _authViewModel.nameError,
              onChanged: (_) => _authViewModel.clearNameError(),
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: _emailController,
              label: "EMAIL",
              keyboardType: TextInputType.emailAddress,
              errorText: _authViewModel.emailError,
              onChanged: (_) => _authViewModel.clearEmailError(),
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: _passwordController,
              obscureText: true,
              label: "PASSWORD",
              errorText: _authViewModel.passwordError,
              onChanged: (_) => _authViewModel.clearPasswordError(),
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
                      activeColor:
                          AppColors.primary, // Sesuaikan dengan tema kamu
                      checkColor: isDark
                          ? AppColors.textPrimaryLight
                          : AppColors.textPrimaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: _authViewModel.isLoading
                          ? null
                          : (bool? value) {
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
                            color: isDark
                                ? AppColors.primary
                                : AppColors.secondary,
                          ),
                          // Tambahkan recognizer: TapGestureRecognizer() di sini jika ingin link bisa diklik
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.primary
                                : AppColors.secondary,
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
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isChecked ? 1.0 : (isDark ? 0.4 : 0.2),

              child: Material(
                color: Colors.transparent,

                child: InkWell(
                  onTap: _authViewModel.isLoading ? null : _handleRegister,

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

                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _authViewModel.isLoading
                          ? SizedBox(
                              key: const ValueKey("register-loading"),
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
                              key: const ValueKey("register-arrow"),
                              size: 28,
                              color: isDark
                                  ? AppColors.textPrimaryLight
                                  : AppColors.textPrimaryDark,
                            ),
                    ),
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
