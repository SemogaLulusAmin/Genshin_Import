import 'package:flutter/material.dart';
import 'package:frontend/view_models/auth_viewmodel.dart';
import '../../core/app_colors.dart';

class MoneyBadge extends StatelessWidget {
  const MoneyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthViewModel.instance,
      builder: (context, child) {
        final money = AuthViewModel.instance.currentUser?.money ?? 0;
        return Container(
          padding: const EdgeInsets.fromLTRB(4, 2, 12, 2),
          decoration: BoxDecoration(
            color: Color(0xC51D2A54),
            borderRadius: BorderRadius.circular(60),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/Item_Mora.webp',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 6),
              Text(
                money.toStringAsFixed(0),
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontFamily: "HyWenhei",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
