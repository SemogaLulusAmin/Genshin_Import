import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class AppMessageDialog extends StatelessWidget {
  const AppMessageDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'OK',
    this.icon,
    this.iconColor,
  });

  final String title;
  final String message;
  final String confirmText;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

Future<void> showAppMessageDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'OK',
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
        icon: icon,
        iconColor: iconColor,
      );
    },
  );
}
