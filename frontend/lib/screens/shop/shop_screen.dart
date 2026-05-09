import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/header/screen_header.dart';
import '../../widgets/card/weapon_card.dart';
import '../../widgets/card/artifact_card.dart';
import '../../models/weapon_model.dart';
import '../../models/artifact_model.dart';
import '../../services/weapon_service.dart';
import '../../services/artifact_service.dart';
import '../../view_models/auth_viewmodel.dart';
import '../../widgets/sheet/weapon_detail_sheet.dart';
import '../../widgets/sheet/artifact_detail_sheet.dart';
import '../admin/admin_weapon_form_screen.dart';
import '../admin/admin_artifact_form_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin {
  late Future<List<Weapon>> _weaponsFuture;
  late Future<List<Artifact>> _artifactsFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _reloadData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _reloadData() {
    _weaponsFuture = WeaponService().getWeapons();
    _artifactsFuture = ArtifactService().getArtifacts();
  }

  Future<void> _refresh() async {
    setState(() {
      _reloadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: AuthViewModel.instance,
      builder: (context, child) {
        final authViewModel = AuthViewModel.instance;
        final currentTab = _tabController.index;
        final isAdmin = authViewModel.isAdmin;

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
          body: child,
          floatingActionButton: isAdmin
              ? FloatingActionButton.extended(
                  icon: const Icon(Icons.add),
                  label: Text(currentTab == 0 ? 'New Weapon' : 'New Artifact'),
                  onPressed: () async {
                    if (currentTab == 0) {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminWeaponFormScreen(),
                        ),
                      );
                    } else {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminArtifactFormScreen(),
                        ),
                      );
                    }
                    if (mounted) {
                      _refresh();
                    }
                  },
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
      child: SafeArea(
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
                  labelColor: isDark ? Colors.white : AppColors.textPrimaryLight,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "HyWenhei",
                    fontSize: 15,
                  ),
                  controller: _tabController,
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

              /// 🔥 TAB BAR VIEW (Konten yang berubah-ubah)
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildWeaponsTab(isDark),
                    _buildArtifactsTab(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildWeaponsTab(bool isDark) {
    return FutureBuilder<List<Weapon>>(
      future: _weaponsFuture,
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
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => WeaponDetailSheet(weapon: weapon),
                ).then((_) {
                  if (mounted) _refresh();
                });
              },
            );
          },
        );
      },
    );
  }

  Widget _buildArtifactsTab(bool isDark) {
    return FutureBuilder<List<Artifact>>(
      future: _artifactsFuture,
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
          return const Center(child: Text("No Artifacts found"));
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
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ArtifactDetailSheet(artifact: artifact),
                ).then((_) {
                  if (mounted) _refresh();
                });
              },
            );
          },
        );
      },
    );
  }
}
