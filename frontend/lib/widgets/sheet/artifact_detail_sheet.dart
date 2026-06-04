import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_button.dart';
import '../../models/artifact_model.dart';
import '../../services/artifact_service.dart';
import '../../view_models/user_viewmodel.dart';
import '../../core/app_colors.dart';
import '../../screens/shop/edit_artifact_screen.dart';
import '../quantity_selector.dart';

class ArtifactDetailSheet extends StatefulWidget {
  final Artifact artifact;
  final bool enablePurchase;
  const ArtifactDetailSheet({
    super.key,
    required this.artifact,
    this.enablePurchase = true,
  });

  @override
  State<ArtifactDetailSheet> createState() => _ArtifactDetailSheetState();
}

class _ArtifactDetailSheetState extends State<ArtifactDetailSheet> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    quantity = widget.artifact.stock > 0 ? 1 : 0;
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

  void _deleteArtifact() async {
    bool confirm =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text("Hapus Artifact?"),
            content: const Text("Data ini akan hilang selamanya bang."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text("BATAL"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text("HAPUS", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);

      try {
        final success = await ArtifactService().deleteArtifact(
          widget.artifact.artifactID,
        );

        UserViewModel.instance.triggerInventoryRefresh();

        if (success) {
          messenger.showSnackBar(
            const SnackBar(content: Text("Artifact berhasil dihapus!")),
          );
        }
      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final artifact = widget.artifact;
    final gradient = _getRarityGradient(artifact.maxRarity);
    final rarity = _getRarityInt(artifact.maxRarity);
    final totalPrice = artifact.price * quantity;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

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
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.broken_image,
                                      size: 100,
                                      color: Colors.white30,
                                    ),
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

                            /// INFO KIRI
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Artifact Set",
                                    style: TextStyle(
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

                            /// STOCK & EDIT BUTTON (ADMIN ONLY)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (widget.enablePurchase)
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      8,
                                      6,
                                      12,
                                      6,
                                    ),
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
                                          style: const TextStyle(
                                            fontFamily: "HyWenhei",
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),

                    if (UserViewModel.instance.isAdmin == false &&
                        widget.enablePurchase) ...[
                      QuantitySelector(
                        value: quantity,
                        onDecrement: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                        onIncrement:
                            quantity < artifact.stock &&
                                quantity * artifact.price <=
                                    UserViewModel.instance.money
                            ? () => setState(() => quantity++)
                            : null,
                        onValueChanged: (value) {
                          setState(() {
                            quantity = artifact.stock <= 0
                                ? 0
                                : value.clamp(1, artifact.stock).toInt();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        backgroundColor: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        borderRadius: 4,
                        iconTextGap: 4,
                        leadingText: 'Purchase',
                        text: '${quantity * artifact.price}',
                        leadingIcon: Image.asset(
                          'assets/images/Item_Mora.webp',
                          width: 26,
                          height: 26,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.monetization_on, size: 20),
                        ),
                        onPressed: artifact.stock == 0 && widget.enablePurchase
                            ? null
                            : () async {
                                try {
                                  final success = await ArtifactService()
                                      .purchaseArtifact(
                                        artifact.artifactID,
                                        quantity,
                                      );
                                  if (!context.mounted) return;
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Purchase successful!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    UserViewModel.instance.decreaseMoney(
                                      totalPrice.toInt(),
                                    );
                                    UserViewModel.instance
                                        .triggerInventoryRefresh();
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Purchase failed: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (UserViewModel.instance.isAdmin == true) ...[
                      CustomButton(
                        icon: const Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        text: 'Delete Artifact',
                        fontWeight: FontWeight.w700,
                        backgroundColor: const Color(0xFFE00707),
                        onPressed: _deleteArtifact,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        icon: const Icon(
                          Icons.edit_note,
                          color: Colors.white,
                          size: 20,
                        ),
                        text: 'Edit Artifact',
                        fontWeight: FontWeight.w700,
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArtifactEditScreen(artifact: artifact),
                            ),
                          );

                          if (result == true) {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            UserViewModel.instance.triggerInventoryRefresh();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
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
