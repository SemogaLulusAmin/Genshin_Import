import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    return SafeArea(
      top: false,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: navTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.1), width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              0,
              AppIcons.cart,
              AppIcons.cartActive,
              "Shop",
            ),
            // _buildNavItem(
            //   context,
            //   1,
            //   AppIcons.cart,
            //   AppIcons.cartActive,
            //   "Orders",
            // ),
            _buildNavItem(
              context,
              1,
              AppIcons.bag,
              AppIcons.bagActive,
              "Inventory",
            ),
            _buildNavItem(
              context,
              2,
              AppIcons.profile,
              AppIcons.profileActive,
              "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String outlineIcon,
    String filledIcon,
    String label,
  ) {
    final bool isSelected = currentIndex == index;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final navTheme = Theme.of(context).bottomNavigationBarTheme;

    // --- COLORS ---
    final Color activeIconColor =
        navTheme.selectedItemColor ?? AppColors.primary;

    final Color inactiveIconColor =
        (navTheme.unselectedItemColor ??
                (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight))
            .withOpacity(0.6);

    final Color activeTextColor = isDark
        ? Colors.white
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
          /// ICON
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

          const SizedBox(height: 8),

          /// LABEL
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
