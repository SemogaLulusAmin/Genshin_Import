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
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            style: TextStyle(fontSize: 14, color: textColor),
            decoration: InputDecoration(
              // labelText: widget.label,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: secondaryTextColor.withValues(alpha: 0.7),
                fontSize: 14,
              ),
              errorText: widget.errorText,
              errorStyle: const TextStyle(fontSize: 12),

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
                color: secondaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              floatingLabelStyle: TextStyle(
                color: secondaryTextColor,
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
                          color: secondaryTextColor,
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
