import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/inventory_model.dart';

class InventoryCard extends StatelessWidget {
  final Inventory item;
  final VoidCallback? onTap;

  const InventoryCard({super.key, required this.item, this.onTap});

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final rarityGradient = _getRarityGradient(item.rarity);

    final rarity = _getRarityInt(item.rarity);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B1D24) : const Color(0xFFFBF9EE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
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
                        item.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),

                  /// QUANTITY BADGE
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "x${item.totalOwned}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: "HyWenhei",
                        ),
                      ),
                    ),
                  ),

                  /// ITEM TYPE BADGE
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.itemType.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          fontFamily: "HyWenhei",
                        ),
                      ),
                    ),
                  ),

                  /// RARITY STARS
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

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: "HyWenhei",
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),

                  const SizedBox(height: 2),

                  /// SUBTITLE
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}
