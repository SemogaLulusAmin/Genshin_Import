import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // 1. Buat FocusNode untuk memantau status 'Selected'
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Re-render saat status focus berubah
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color activeLabelColor = _focusNode.hasFocus
        ? AppColors.primary
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight);

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode, // 3. Pasang FocusNode-nya
      obscureText: widget.isPassword,
      style: TextStyle(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: widget.label,

        // Warna label saat diam (di tengah)
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          fontSize: 15,
        ),

        // 4. KUNCI: Warna label saat melayang (Floating)
        floatingLabelStyle: TextStyle(
          color:
              activeLabelColor, // Menggunakan warna dinamis hasil deteksi FocusNode
          fontWeight: _focusNode.hasFocus ? FontWeight.w600 : FontWeight.w500,
          fontSize: 15,
        ),

        hintText: widget.placeholder.toLowerCase(),
        hintStyle: TextStyle(
          fontSize: 15,
          color:
              (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight)
                  .withOpacity(0.4),
        ),

        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.fieldBackground,
        contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 8),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        alignLabelWithHint: true,
      ),
    );
  }
}
