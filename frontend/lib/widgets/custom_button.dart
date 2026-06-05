import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String? leadingText;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Icon? icon;
  final double fontSize;
  final double iconTextGap;
  final FontWeight fontWeight;
  final double iconSize;
  final Color? backgroundColor;
  final Color foregroundColor;
  final Widget? leadingIcon;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.leadingText,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fontSize = 15,
    this.iconTextGap = 8,
    this.fontWeight = FontWeight.w600,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.textPrimaryDark,
    this.iconSize = 20,
    this.leadingIcon,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,

          foregroundColor: foregroundColor,

          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: foregroundColor,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingText != null) ...[
                      Text(
                        leadingText!,
                        style: TextStyle(
                          fontFamily: "HyWenhei",
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                        ),
                      ),
                      SizedBox(width: iconTextGap),
                    ],
                    if (leadingIcon != null) ...[
                      leadingIcon!,
                      SizedBox(width: iconTextGap),
                    ],
                    if (icon != null) ...[icon!, SizedBox(width: iconTextGap)],
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: "HyWenhei",
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
