import 'package:flutter/material.dart';
import 'package:frontend/view_models/user_viewmodel.dart';
import '../../core/app_colors.dart';
import 'money_badge.dart';

class ScreenHeader extends StatelessWidget {
  final String title;

  const ScreenHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.surfaceLight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 🔹 TITLE
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontFamily: "HyWenhei",
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),

          // Money Badge
          if (!UserViewModel.instance.isAdmin) const MoneyBadge(),
        ],
      ),
    );
  }
}
