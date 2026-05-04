import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,

        filled: true,
        fillColor: isDark
            ? AppColors.fieldBackgroundDark
            : AppColors.fieldBackground,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1),
        ),

        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary, // warna saat aktif
            width: 2,
          ),
        ),

        /// Optional styling
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.textPrimaryDark.withValues(alpha: 0.8)
              : AppColors.textPrimaryLight.withValues(alpha: 0.6),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        floatingLabelStyle: TextStyle(
          color: isDark
              ? AppColors.textPrimaryDark.withValues(alpha: 0.8)
              : AppColors.textPrimaryLight.withValues(alpha: 0.6),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
