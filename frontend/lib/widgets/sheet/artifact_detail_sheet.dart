import 'package:flutter/material.dart';
import '../../models/artifact_model.dart';
import '../../services/artifact_service.dart';
import 'package:provider/provider.dart';
import '../../states/user_state.dart';
import '../../core/app_colors.dart';

class ArtifactDetailSheet extends StatefulWidget {
  final Artifact artifact;
  final bool enablePurchase;
  const ArtifactDetailSheet({super.key, required this.artifact, this.enablePurchase = true});

  @override
  State<ArtifactDetailSheet> createState() => _ArtifactDetailSheetState();
}

class _ArtifactDetailSheetState extends State<ArtifactDetailSheet> {
  int quantity = 1;

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
    final artifact = widget.artifact;
    final gradient = _getRarityGradient(artifact.maxRarity);
    final rarity = _getRarityInt(artifact.maxRarity);
    final totalPrice = artifact.price * quantity;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.7,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// HANDLE
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
                      /// HEADER
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
                            /// IMAGE
                            Positioned(
                              top: 0,
                              bottom: 0,
                              right: -32,
                              child: Image.network(
                                artifact.imageUrl,
                                width: MediaQuery.of(context).size.width * 0.65,
                                fit: BoxFit.contain,
                              ),
                            ),

                            /// OVERLAY
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withValues(alpha: 0.2),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),

                            /// INFO KIRI (GANTI DARI WEAPON)
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Artifact Set",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontFamily: "HyWenhei",
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    artifact.setName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "HyWenhei",
                                    ),
                                  ),

                                  const SizedBox(height: 16),

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

                      /// INFO SECTION
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME
                            Text(
                              artifact.formattedName,
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

                            /// SET NAME (sub)
                            Text(
                              artifact.setName,
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

                            /// 2-PC BONUS
                            if (artifact.pieceBonus2 != null &&
                                artifact.pieceBonus2!.isNotEmpty) ...[
                              Text(
                                "2-Piece Bonus",
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
                              Text(
                                artifact.pieceBonus2!,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textPrimaryLight.withValues(
                                          alpha: 0.8,
                                        ),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            /// 4-PC BONUS
                            if (artifact.pieceBonus4 != null &&
                                artifact.pieceBonus4!.isNotEmpty) ...[
                              Text(
                                "4-Piece Bonus",
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
                              Text(
                                artifact.pieceBonus4!,
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
                            ],

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
                                  const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Stock : ${artifact.stock}',
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

              /// BOTTOM (SAMA PERSIS)
              if(widget.enablePurchase)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// QTY
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppColors.bgDark.withValues(alpha: 0.07),
                      ),
                      child: Row(
                        children: [
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
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
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
                          InkWell(
                            onTap: quantity < artifact.stock
                                ? () => setState(() => quantity++)
                                : null,
                            child: Container(
                              width: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: artifact.stock == 0
                          ? null
                          : () async {
                              try {
                                final success = await ArtifactService()
                                    .purchaseArtifact(
                                      artifact.artifactID,
                                      quantity,
                                    );

                                if (success) {
                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Purchase successful!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // Close the sheet
                                  context.read<UserState>().decreaseMoney(totalPrice.toInt());
                                  context.read<UserState>().triggerInventoryRefresh();
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

                          Image.asset(
                            'assets/images/Item_Mora.webp',
                            width: 26,
                            height: 26,
                          ),

                          const SizedBox(width: 4),

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
