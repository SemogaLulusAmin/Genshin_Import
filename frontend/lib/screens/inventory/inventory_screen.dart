import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

import '../../widgets/header/screen_header.dart';
import '../../widgets/card/weapon_card.dart';
import '../../widgets/card/artifact_card.dart';

import '../../models/weapon_model.dart';
import '../../models/artifact_model.dart';

import '../../services/inventory_weapon_service.dart';
import '../../services/inventory_artifact_service.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: "Inventory"),

              /// TAB BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: AppColors.primary,
                  labelColor: isDark
                      ? Colors.white
                      : AppColors.textPrimaryLight,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "HyWenhei",
                    fontSize: 15,
                  ),
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield_moon, size: 20),
                          SizedBox(width: 6),
                          Text("Weapons"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome_rounded, size: 20),
                          SizedBox(width: 6),
                          Text("Artifacts"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              /// TAB VIEW
              Expanded(
                child: TabBarView(
                  children: [
                    _buildWeaponsTab(isDark),
                    _buildArtifactsTab(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// WEAPON INVENTORY TAB
  Widget _buildWeaponsTab(bool isDark) {
    return FutureBuilder<List<Weapon>>(
      future: InventoryWeaponService().getInventory(),
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
              "No weapons in inventory",
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          );
        }

        final weapons = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          itemCount: weapons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            final weapon = weapons[index];

            return WeaponCard(
              weapon: weapon,
              onTap: () {
                // TODO: Detail inventory weapon
              },
            );
          },
        );
      },
    );
  }

  /// ARTIFACT INVENTORY TAB
  Widget _buildArtifactsTab(bool isDark) {
    return FutureBuilder<List<Artifact>>(
      future: InventoryArtifactService().getInventory(),
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
              "No artifacts in inventory",
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          );
        }

        final artifacts = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          itemCount: artifacts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            final artifact = artifacts[index];

            return ArtifactCard(
              artifact: artifact,
              onTap: () {
                // TODO: Detail inventory artifact
              },
            );
          },
        );
      },
    );
  }
}
