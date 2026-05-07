import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/services/auth_service.dart';
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
  bool isChecked = false;
  final Authservice authService = Authservice();

  Future<void> _handleRegister() async {
    if (isChecked == false) {
      return;
    }

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showMessage("Please fill all fields", Colors.red);
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
    return Column(
      children: [
        CustomFormField(controller: _nameController, label: "USERNAME"),
        const SizedBox(height: 16),
        CustomFormField(controller: _emailController, label: "EMAIL"),
        const SizedBox(height: 16),
        CustomFormField(
          controller: _passwordController,
          obscureText: true,
          label: "PASSWORD",
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
                  value: isChecked,
                  activeColor: AppColors.primary, // Sesuaikan dengan tema kamu
                  checkColor: isDark
                      ? AppColors.textPrimaryLight
                      : AppColors.textPrimaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
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
                        color: isDark ? AppColors.primary : AppColors.secondary,
                      ),
                      // Tambahkan recognizer: TapGestureRecognizer() di sini jika ingin link bisa diklik
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.primary : AppColors.secondary,
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
        GestureDetector(
          onTap: isChecked
              ? () {
                  _handleRegister();
                }
              : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isChecked ? 1.0 : (isDark ? 0.4 : 0.2),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                borderRadius: BorderRadius.circular(12),
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
      ],
    );
  }
}
