import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/header/screen_header.dart';
import '../../widgets/card/weapon_card.dart';
import '../../models/weapon_model.dart';
import '../../services/weapon_service.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // DefaultTabController membungkus Scaffold agar state tab dikelola otomatis
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: "Shop"),

              /// TAB BAR SELECTION
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
                          Text("Artefacts"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              /// 🔥 TAB BAR VIEW (Konten yang berubah-ubah)
              Expanded(
                child: TabBarView(
                  children: [
                    // --- TAB 1: WEAPONS (Existing Logic) ---
                    _buildWeaponsTab(isDark),

                    // --- TAB 2: ARTEFACTS (Placeholder) ---
                    _buildArtefactsTab(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// FUNGSI UNTUK MERENDER HALAMAN WEAPONS
  Widget _buildWeaponsTab(bool isDark) {
    return FutureBuilder<List<Weapon>>(
      future: WeaponService().getWeapons(),
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
          return const Center(child: Text("No weapons found"));
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
                // Navigasi detail
              },
            );
          },
        );
      },
    );
  }

  /// FUNGSI UNTUK MERENDER HALAMAN ARTEFACTS (Placeholder)
  Widget _buildArtefactsTab(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Artefacts Coming Soon",
            style: TextStyle(
              fontSize: 18,
              fontFamily: "HyWenhei",
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
