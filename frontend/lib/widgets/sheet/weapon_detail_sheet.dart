import 'package:flutter/material.dart';
import '../../models/weapon_model.dart';
import '../../core/app_colors.dart';
import '../../services/weapon_service.dart';
<<<<<<< HEAD
import '../../services/auth_service.dart';
import '../../states/user_state.dart';
import '../../screens/admin/admin_weapon_form_screen.dart';
=======
import '../../view_models/user_viewmodel.dart';
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9

class WeaponDetailSheet extends StatefulWidget {
  final Weapon weapon;
  final bool enablePurchase;

  const WeaponDetailSheet({super.key, required this.weapon, this.enablePurchase = true});

  @override
  State<WeaponDetailSheet> createState() => _WeaponDetailSheetState();
}

class _WeaponDetailSheetState extends State<WeaponDetailSheet> {
  late Weapon _weapon;
  int quantity = 1;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _weapon = widget.weapon;
    _loadAdminState();
  }

  Future<void> _loadAdminState() async {
    final isAdmin = await AuthService().isAdmin();
    if (mounted) {
      setState(() => _isAdmin = isAdmin);
    }
  }

  List<Color> _getRarityGradient(String rarity) {
    switch (rarity) {
      case '5':
        return [const Color(0xFF665150), const Color(0xFFE5AD4E)];
      case '4':
        return [const Color(0xFF5A5285), const Color(0xFFBD7DD7)];
      case '3':
        return [const Color(0xFF525274), const Color(0xFF54BFD5)];
      default:
        return [Colors.grey, Colors.grey.shade300];
    }
  }

  int _getRarityInt(String rarity) {
    return int.tryParse(rarity) ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final weapon = _weapon;
    final gradient = _getRarityGradient(weapon.rarity);
    final rarity = _getRarityInt(weapon.rarity);
    final totalPrice = weapon.price * quantity;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.7,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            children: [
              /// HANDLE
              const SizedBox(height: 10),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 10),

              /// CONTENT
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Image + Stats Overlay
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Weapon Image
                            Positioned(
                              top: 0,
                              bottom: 0,
                              right: -32,
                              child: Image.network(
                                weapon.imageUrl,
                                width: MediaQuery.of(context).size.width * 0.7,
                                fit: BoxFit.contain,
                              ),
                            ),

                            // Overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.2),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),

                            // Weapon Stats
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sub Stat",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontFamily: "HyWenhei",
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    weapon.subStat,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          14, // sedikit dibesarkan biar lebih impact
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "HyWenhei",
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  Text(
                                    "Base ATK",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontFamily: "HyWenhei",
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    weapon.baseAttack,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          28, // sedikit dibesarkan biar lebih impact
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "HyWenhei",
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  /// ⭐ RARITY
                                  Row(
                                    children: List.generate(
                                      rarity,
                                      (_) => const Icon(
                                        Icons.star,
                                        color: Color(0xFFFFCD38),
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 🔽 INFO SECTION
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME
                            Text(
                              weapon.name,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                fontFamily: "HyWenhei",
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// TYPE
                            Text(
                              weapon.type,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textPrimaryLight.withValues(
                                        alpha: 0.6,
                                      ),
                                fontSize: 14,
                                fontFamily: "HyWenhei",
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// PASSIVE TITLE
                            if (weapon.passiveName.isNotEmpty) ...[
                              Text(
                                weapon.passiveName,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: "HyWenhei",
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],

                            /// DESCRIPTION
                            Text(
                              weapon.passiveDesc.isNotEmpty
                                  ? weapon.passiveDesc
                                  : "No description available.",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textPrimaryLight.withValues(
                                        alpha: 0.8,
                                      ),
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// STOCK
                            if(widget.enablePurchase)
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Stock : ${weapon.stock}',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                      fontFamily: "HyWenhei",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if(widget.enablePurchase)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                decoration: const BoxDecoration(color: Colors.transparent),
                // 1. Ganti Row menjadi Column
                child: Column(
                  // Optional: Agar konten rata kiri (start) atau tengah (center)
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// QTY
                    Container(
                      height: 44, // Tentukan tinggi agar seragam
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppColors.bgDark.withValues(alpha: 0.07),
                      ),
                      child: Row(
                        children: [
                          /// BUTTON MINUS
                          InkWell(
                            onTap: quantity > 1
                                ? () => setState(() => quantity--)
                                : null,
                            child: Container(
                              width: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 24,
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                          ),

                          /// TEXT QTY
                          Expanded(
                            child: Center(
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "HyWenhei",
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                          ),

                          /// BUTTON PLUS
                          InkWell(
                            onTap: quantity < weapon.stock
                                ? () => setState(() => quantity++)
                                : null,
                            child: Container(
                              width: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                // Radius hanya di sisi kanan
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 24,
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: weapon.stock == 0
                          ? null
                          : () async {
                              try {
                                final success = await WeaponService()
                                    .purchaseWeapon(weapon.weaponID, quantity);

                                if (success) {
                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Purchase successful!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // Close the sheet
                                  UserViewModel.instance.decreaseMoney(totalPrice.toInt());
                                  UserViewModel.instance.triggerInventoryRefresh();
                                  if (context.mounted) Navigator.of(context).pop();
                                }
                              } catch (e) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Purchase failed: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Purchase ",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimaryLight
                                  : AppColors.textPrimaryDark,
                              fontFamily: "HyWenhei",
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),

                          /// 💰 ICON MATA UANG
                          Image.asset(
                            'assets/images/Item_Mora.webp',
                            width: 26,
                            height: 26,
                          ),

                          const SizedBox(width: 4),

                          /// 💵 TOTAL PRICE
                          Text(
                            totalPrice.toStringAsFixed(0),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimaryLight
                                  : AppColors.textPrimaryDark,
                              fontFamily: "HyWenhei",
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_isAdmin) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final updated = await Navigator.of(context).push<bool?>(
                            MaterialPageRoute(
                              builder: (_) => AdminWeaponFormScreen(weapon: weapon),
                            ),
                          );
                          if (updated == true) {
                            try {
                              final refreshed = await WeaponService().getWeaponById(weapon.weaponID);
                              if (refreshed != null && mounted) {
                                setState(() => _weapon = refreshed);
                              }
                            } catch (_) {
                              if (mounted) setState(() {});
                            }
                          }
                        },
                        child: const Text('Edit Weapon'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Delete Weapon'),
                              content: const Text(
                                  'Are you sure you want to delete this weapon?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed != true) return;

                          try {
                            final success = await WeaponService().deleteWeapon(weapon.weaponID);
                            if (success) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Weapon deleted'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Delete failed: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Delete Weapon'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
