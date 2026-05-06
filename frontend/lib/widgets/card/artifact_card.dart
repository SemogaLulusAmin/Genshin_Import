import 'package:flutter/material.dart';
import '../../models/artifact_model.dart';
import '../../core/app_colors.dart';
import '../../widgets/sheet/artifact_detail_sheet.dart';

class ArtifactCard extends StatelessWidget {
  final Artifact artifact;
  final VoidCallback? onTap;

  const ArtifactCard({super.key, required this.artifact, this.onTap});

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
    final rarityGradient = _getRarityGradient(artifact.maxRarity);
    final rarityCount = _getRarityInt(artifact.maxRarity);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ArtifactDetailSheet(artifact: artifact),
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B1D24) : const Color(0xFFFBF9EE),
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
                        artifact.imageUrl,
                        fit: BoxFit.contain,
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
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "X${artifact.stock}",
                        style: const TextStyle(
                          color: Colors.white,
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
                        rarityCount,
                        (index) => Icon(
                          Icons.star,
                          size: 24,
                          color: const Color(0xFFFFCD38),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
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
                    artifact.formattedName,
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
                    artifact.setName, // Menggunakan Set Name sebagai sub-info
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize:
                          11, // Sedikit lebih kecil karena set name biasanya panjang
                      fontFamily: "HyWenhei",
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.6),
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
                color: isDark
                    ? const Color(0xFF1F2C3F)
                    : const Color(0xFF3D4E69),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Item_Mora.webp',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    artifact.price.toStringAsFixed(0),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: "HyWenhei",
                      color: Colors.white,
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
