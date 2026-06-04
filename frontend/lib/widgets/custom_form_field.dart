import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class CustomFormField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CustomFormField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hintText,
              errorText: widget.errorText,

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
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),

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
              suffixIcon: widget.obscureText
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
