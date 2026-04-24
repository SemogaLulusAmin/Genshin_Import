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
    return Container(
      height: 70, // Tinggi navbar
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, AppIcons.swordOutlined, AppIcons.swordFilled),
          _buildNavItem(1, AppIcons.backpackOutlined, AppIcons.backpackFilled),
          _buildNavItem(2, AppIcons.boxOutlined, AppIcons.boxFilled),
          _buildNavItem(3, AppIcons.userOutlined, AppIcons.userFilled),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String outlineIcon, String filledIcon) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Agar kolom tidak memakan ruang berlebih
        children: [
          // EFEK SCALE: Membesar saat isSelected
          AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isSelected ? 1.2 : 1.0, // Membesar 20% saat terpilih
            curve:
                Curves.easeOutBack, // Memberikan sedikit efek membal (bounce)
            child: SvgPicture.asset(
              isSelected ? filledIcon : outlineIcon,
              width: 24,
              height: 24,
            ),
          ),

          const SizedBox(height: 8),

          // Indikator Box Panjang (Tetap ada)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 3,
            width: isSelected ? 16 : 0, // Sedikit lebih pendek agar seimbang
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
