import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_colors.dart';

class MoneyBadge extends StatelessWidget {
  const MoneyBadge({super.key});

  Future<int> _getMoney() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('money') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<int>(
      future: _getMoney(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        final money = snapshot.data ?? 0;

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
                money.toString(),
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
