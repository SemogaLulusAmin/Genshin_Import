import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_colors.dart';

class MoneyBadge extends StatefulWidget {
  const MoneyBadge({super.key});

  @override
  State<MoneyBadge> createState() => _MoneyBadgeState();

  static _MoneyBadgeState? _instance;
  
  static Future<void> refresh() async {
    await _instance?._refreshMoney();
  }
}

class _MoneyBadgeState extends State<MoneyBadge> {
  int _money = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    MoneyBadge._instance = this;
    _loadMoney();
  }

  @override
  void dispose() {
    if (MoneyBadge._instance == this) {
      MoneyBadge._instance = null;
    }
    super.dispose();
  }

  Future<void> _loadMoney() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final String moneyStr = prefs.getString('money') ?? '0';
    final int cachedMoney = num.tryParse(moneyStr)?.toInt() ?? 0;

    if (mounted) {
      setState(() {
        _money = cachedMoney;
      });
    }

    _refreshMoney(showLoading: false); 
  }

  Future<void> _refreshMoney({bool showLoading = true}) async {
    if (_isLoading) return; 
    
    if (showLoading) setState(() => _isLoading = true);

    try {
      final userService = UserService();
      final result = await userService.getUserData();

      if (mounted) {
        setState(() {
          if (result['success'] == true) {
            _money = result['money'] ?? _money; 
          }
          _isLoading = false;
        });
      }

    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5, 
                  color: Colors.white,
                ),
              )
            else
              Text(
                _money.toString(),
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontFamily: "HyWenhei",
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}