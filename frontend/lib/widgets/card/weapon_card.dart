import 'package:flutter/material.dart';
import '../../models/weapon_model.dart';
import '../../core/app_colors.dart';
import '../../widgets/sheet/weapon_detail_sheet.dart';

class WeaponCard extends StatelessWidget {
  final Weapon weapon;
  final VoidCallback? onTap;

  const WeaponCard({super.key, required this.weapon, this.onTap});

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
    final rarityGradient = _getRarityGradient(weapon.rarity);
    final rarity = _getRarityInt(weapon.rarity);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => WeaponDetailSheet(weapon: weapon),
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1B1D24) : Color(0xFFFBF9EE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Panel
            Expanded(
              flex: 5,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                      gradient: LinearGradient(
                        colors: [rarityGradient[0], rarityGradient[1]],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        weapon.imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),

                  // Stock Indicator
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "X${weapon.stock}",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "HyWenhei",
                        ),
                      ),
                    ),
                  ),

                  // Rarity Stars
                  Positioned(
                    bottom: -10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        rarity,
                        (index) => Icon(
                          Icons.star,
                          size: 24,
                          color: const Color(0xFFFFCD38),
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Mid Content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weapon.name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: "HyWenhei",
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    weapon.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "HyWenhei",
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textPrimaryDark.withValues(alpha: 0.6)
                          : AppColors.textPrimaryLight.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            /// PRICE PANEL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1F2C3F) : Color(0xFF3D4E69),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Item_Mora.webp',
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    weapon.price.toStringAsFixed(0),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: "HyWenhei",
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
