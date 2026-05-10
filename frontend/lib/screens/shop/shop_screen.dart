import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/widgets/header/screen_header.dart';
import 'package:frontend/widgets/card/weapon_card.dart';
import 'package:frontend/widgets/card/artifact_card.dart';
import 'package:frontend/models/weapon_model.dart';
import 'package:frontend/models/artifact_model.dart';
import 'package:frontend/services/weapon_service.dart';
import 'package:frontend/services/artifact_service.dart';
import 'package:frontend/view_models/user_viewmodel.dart';
import 'create_artifact_screen.dart';
import 'create_weapon_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // DefaultTabController is removed in favor of this managed controller 
    // so the FloatingActionButton can listen to index changes.
    _tabController = TabController(length: 2, vsync: this);
    
    // This ensures the FAB updates its text/icon when you swipe tabs
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
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

    return ListenableBuilder(
      listenable: UserViewModel.instance,
      builder: (context, _) {
        final bool isAdmin = UserViewModel.instance.isAdmin;

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
          
          // --- DYNAMIC FLOATING ACTION BUTTON ---
          floatingActionButton: isAdmin 
              ? FloatingActionButton.extended(
                  onPressed: () {
                    if (_tabController.index == 0) {
                      _openWeaponCreateForm(context);
                    } else {
                      _openArtifactCreateForm(context);
                    }
                  },
                  backgroundColor: AppColors.primary,
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24
                  ),
                  label: Text(
                    _tabController.index == 0 
                        ? "CREATE WEAPON" 
                        : "CREATE ARTIFACT",
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                      fontFamily: "HyWenhei",
                    ),
                  ),
                )
              : null,

          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenHeader(title: "Shop"),

                /// TAB BAR
/// TAB BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorColor: AppColors.primary,
                    labelColor: isDark ? Colors.white : AppColors.textPrimaryLight,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "HyWenhei",
                      fontSize: 15,
                    ),
                    tabs: const [
                      // WEAPON TAB WITH ICON
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shield_moon, size: 18),
                            SizedBox(width: 8),
                            Text("Weapons"),
                          ],
                        ),
                      ),
                      // ARTIFACT TAB WITH ICON
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome_rounded, size: 18),
                            SizedBox(width: 8),
                            Text("Artifacts"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                /// TAB CONTENT
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildWeaponsTab(),
                      _buildArtifactsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeaponsTab() {
    return FutureBuilder<List<Weapon>>(
      // Using UserViewModel.instance.inventoryRefreshKey as a trigger to reload
      key: ValueKey(UserViewModel.instance.inventoryRefreshKey),
      future: WeaponService().getWeapons(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading weapons"));
        }

        final weapons = snapshot.data ?? [];
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 80), // Extra bottom padding for FAB
          itemCount: weapons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) => WeaponCard(weapon: weapons[index]),
        );
      },
    );
  }

  Widget _buildArtifactsTab() {
    return FutureBuilder<List<Artifact>>(
      key: ValueKey(UserViewModel.instance.inventoryRefreshKey),
      future: ArtifactService().getArtifacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading artifacts"));
        }

        final artifacts = snapshot.data ?? [];
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 80), // Extra bottom padding for FAB
          itemCount: artifacts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) => ArtifactCard(artifact: artifacts[index]),
        );
      },
    );
  }

  void _openWeaponCreateForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWeaponScreen(),
      ),
    );
  }
  // Inside ShopScreen class...
  void _openArtifactCreateForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateArtifactScreen()),
    );
  }
}