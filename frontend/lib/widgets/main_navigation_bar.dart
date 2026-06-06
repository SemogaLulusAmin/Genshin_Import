import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/view_models/user_viewmodel.dart';

import '../core/app_icons.dart';
import '../core/app_colors.dart';

class MainNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navTheme = Theme.of(context).bottomNavigationBarTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: navTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.border.withValues(alpha: 0.8),
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              index: 0,
              outlineIcon: AppIcons.cart,
              filledIcon: AppIcons.cartActive,
              label: "Shop",
            ),
            if (UserViewModel.instance.isAdmin == false)
              _buildNavItem(
                context: context,
                index: 1,
                outlineIcon: AppIcons.bag,
                filledIcon: AppIcons.bagActive,
                label: "Inventory",
              ),
            if (UserViewModel.instance.isAdmin == true)
              _buildNavItem(
                context: context,
                index: 1,
                outlineIconData: Icons.add,
                filledIconData: Icons.add_outlined,
                label: "Create",
              ),
            _buildNavItem(
              context: context,
              index: 2,
              outlineIcon: AppIcons.profile,
              filledIcon: AppIcons.profileActive,
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    String? outlineIcon,
    String? filledIcon,
    IconData? outlineIconData,
    IconData? filledIconData,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final navTheme = Theme.of(context).bottomNavigationBarTheme;

    final Color activeIconColor =
        navTheme.selectedItemColor ?? AppColors.primary;

    final Color inactiveIconColor =
        (navTheme.unselectedItemColor ??
                (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight))
            .withValues(alpha: 0.6);

    final Color activeTextColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    final Color inactiveTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final Color iconColor = isSelected ? activeIconColor : inactiveIconColor;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (outlineIcon != null && filledIcon != null)
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.7 : 1.4,
              curve: Curves.easeOutBack,
              child: SvgPicture.asset(
                isSelected ? filledIcon : outlineIcon,
                width: 25,
                height: 25,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),

          if (outlineIconData != null && filledIconData != null)
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.7 : 1.4,
              curve: Curves.easeOutBack,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: Center(
                  child: Icon(
                    isSelected ? filledIconData : outlineIconData,
                    size: 22,
                    color: isSelected ? AppColors.textPrimaryDark : iconColor,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),

          AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isSelected ? 1.2 : 1.1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
