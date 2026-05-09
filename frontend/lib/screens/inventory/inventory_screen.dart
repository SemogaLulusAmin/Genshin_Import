import 'package:flutter/material.dart';
import '../../states/user_state.dart';
import '../../core/app_colors.dart';
import '../../widgets/header/screen_header.dart';
import '../../widgets/card/inventory_card.dart';
import '../../models/inventory_model.dart';
import '../../models/weapon_inventory_model.dart';
import '../../models/artifact_inventory_model.dart';
import '../../widgets/sheet/artifact_detail_sheet.dart';
import '../../widgets/sheet/weapon_detail_sheet.dart';
import '../../services/artifact_service.dart';
import '../../services/weapon_service.dart';
import '../../services/inventory_weapon_service.dart';
import '../../services/inventory_artifact_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String selectedFilter = "All";

  Future<List<Inventory>> _loadInventory() async {
    final weapons = await InventoryWeaponService().getInventory();

    final artifacts = await InventoryArtifactService().getInventory();

    final weaponItems = weapons
        .map(
          (w) => InventoryWeapon(
            weaponID: w.weaponID,
            name: w.name,
            type: w.type,
            rarity: w.rarity,
            totalOwned: w.totalOwned,
            imageUrl: w.imageUrl,
          ),
        )
        .toList();

    final artifactItems = artifacts
        .map(
          (a) => InventoryArtifact(
            artifactID: a.artifactID,
            name: a.name,
            setName: a.setName,
            maxRarity: a.maxRarity,
            totalOwned: a.totalOwned,
            imageUrl: a.imageUrl,
            price: a.price,
            pieceBonus2: a.pieceBonus2,
            pieceBonus4: a.pieceBonus4,
          ),
        )
        .toList();

    /// MERGE ALL
    final allItems = [...weaponItems, ...artifactItems];

    /// SORT BY RARITY
    allItems.sort((a, b) {
      return int.parse(b.rarity).compareTo(int.parse(a.rarity));
    });

    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenHeader(title: "Inventory"),

            /// FILTER CHIPS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  _buildFilterChip(
                    label: "All",
                    icon: Icons.grid_view_rounded,
                    isDark: isDark,
                  ),

                  const SizedBox(width: 8),

                  _buildFilterChip(
                    label: "Weapon",
                    icon: Icons.shield_moon,
                    isDark: isDark,
                  ),

                  const SizedBox(width: 8),

                  _buildFilterChip(
                    label: "Artifact",
                    icon: Icons.auto_awesome_rounded,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// INVENTORY GRID
            Expanded(
              child: ListenableBuilder(
                listenable: UserState.instance,
                builder: (context, _) {
                  final int refreshTrigger =
                      UserState.instance.inventoryTrigger;
                  return FutureBuilder<List<Inventory>>(
                    key: ValueKey(refreshTrigger),
                    future: _loadInventory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Inventory is empty",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              fontSize: 16,
                              fontFamily: "HyWenhei",
                            ),
                          ),
                        );
                      }

                      final allItems = snapshot.data!;

                      /// FILTER LOGIC
                      final filteredItems = selectedFilter == "All"
                          ? allItems
                          : allItems.where((item) {
                              return item.itemType == selectedFilter;
                            }).toList();

                      /// EMPTY FILTER RESULT
                      if (filteredItems.isEmpty) {
                        return Center(
                          child: Text(
                            "Inventory is Empty",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              fontSize: 16,
                              fontFamily: "HyWenhei",
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: filteredItems.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.69,
                            ),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return InventoryCard(
                            item: item,
                            onTap: () async {
                              if (item is InventoryArtifact) {
                                final artifact = await ArtifactService()
                                    .getArtifactById(item.artifactID);
                                if (artifact != null) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => ArtifactDetailSheet(
                                      artifact: artifact,
                                      enablePurchase: false,
                                    ),
                                  );
                                }
                              } else if (item is InventoryWeapon) {
                                final weapon = await WeaponService()
                                    .getWeaponById(item.weaponID);
                                if (weapon != null) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => WeaponDetailSheet(
                                      weapon: weapon,
                                      enablePurchase: false,
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final bool isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.black
                  : isDark
                  ? Colors.white70
                  : Colors.black87,
            ),

            const SizedBox(width: 6),

            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : isDark
                    ? Colors.white70
                    : Colors.black87,
                fontWeight: FontWeight.w600,
                fontFamily: "HyWenhei",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
