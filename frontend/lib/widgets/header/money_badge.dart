import 'package:flutter/material.dart';
import 'package:frontend/view_models/user_viewmodel.dart';
import '../../core/app_colors.dart';

class MoneyBadge extends StatefulWidget {
  const MoneyBadge({super.key});

  @override
  State<MoneyBadge> createState() => _MoneyBadgeState();
}

class _MoneyBadgeState extends State<MoneyBadge> {
  final UserViewModel _userViewModel = UserViewModel.instance;

  @override
  void initState() {
    super.initState();
    _loadMoney();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadMoney() async {
    await _userViewModel.loadCachedMoney();
    await _userViewModel.refreshMoney(showLoading: false);
  }

  Future<void> _refreshMoney({bool showLoading = true}) async {
    await _userViewModel.refreshMoney(showLoading: showLoading);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _refreshMoney(showLoading: true),
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 2, 12, 2),
        decoration: BoxDecoration(
          color: const Color(0xC51D2A54),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: AppColors.primary.withOpacity(0.8)),
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
            ListenableBuilder(
              listenable: _userViewModel,
              builder: (context, _) => _userViewModel.isMoneyLoading
                  ? const SizedBox(
                      width: 20,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _userViewModel.money.toString(),
                      style: TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontFamily: "HyWenhei",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
