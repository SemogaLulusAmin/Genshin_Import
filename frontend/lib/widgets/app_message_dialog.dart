import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

enum AppMessageType { info, success, error }

class AppMessageDialog extends StatelessWidget {
  const AppMessageDialog({
    super.key,
    this.title,
    required this.message,
    this.confirmText = 'OK',
    this.type = AppMessageType.info,
    this.icon,
    this.iconColor,
  });

  final String? title;
  final String message;
  final String confirmText;
  final AppMessageType type;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final accentColor = iconColor ?? _accentColor;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon ?? _defaultIcon, color: accentColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title ?? _defaultTitle,
              style: TextStyle(
                color: textColor,
                fontFamily: 'HyWenhei',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(color: secondaryTextColor, fontSize: 14, height: 1.45),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimaryDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              confirmText,
              style: const TextStyle(
                fontFamily: 'HyWenhei',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData get _defaultIcon {
    switch (type) {
      case AppMessageType.success:
        return Icons.check_circle_outline_rounded;
      case AppMessageType.error:
        return Icons.error_outline_rounded;
      case AppMessageType.info:
        return Icons.info_outline_rounded;
    }
  }

  Color get _accentColor {
    switch (type) {
      case AppMessageType.success:
        return Colors.green;
      case AppMessageType.error:
        return Colors.red;
      case AppMessageType.info:
        return AppColors.primary;
    }
  }

  String get _defaultTitle {
    switch (type) {
      case AppMessageType.success:
        return 'Success';
      case AppMessageType.error:
        return 'Error';
      case AppMessageType.info:
        return 'Information';
    }
  }
}

Future<void> showAppMessageDialog({
  required BuildContext context,
  String? title,
  required String message,
  String confirmText = 'OK',
  AppMessageType type = AppMessageType.info,
  IconData? icon,
  Color? iconColor,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AppMessageDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        type: type,
        icon: icon,
        iconColor: iconColor,
      );
    },
  );
}

Future<void> showAppSuccessDialog({
  required BuildContext context,
  String? title,
  required String message,
  String confirmText = 'OK',
}) {
  return showAppMessageDialog(
    context: context,
    title: title,
    message: message,
    confirmText: confirmText,
    type: AppMessageType.success,
  );
}

Future<void> showAppErrorDialog({
  required BuildContext context,
  String? title,
  required String message,
  String confirmText = 'OK',
}) {
  return showAppMessageDialog(
    context: context,
    title: title,
    message: message,
    confirmText: confirmText,
    type: AppMessageType.error,
  );
}
