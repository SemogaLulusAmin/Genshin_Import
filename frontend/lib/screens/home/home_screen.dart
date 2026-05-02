import 'package:flutter/material.dart';

import '../../models/weapon_model.dart';
import '../../models/artifact_model.dart';

import '../../services/weapon_service.dart';
import '../../services/artifact_service.dart';

import '../../widgets/cards/weapon_card.dart';
import '../../widgets/cards/artifact_card.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeaponService _weaponService = WeaponService();
  final ArtifactService _artifactService = ArtifactService();

  late Future<List<Weapon>> _weaponFuture;
  late Future<List<Artifact>> _artifactFuture;

  @override
  void initState() {
    super.initState();
    _weaponFuture = _weaponService.getWeapons();
    _artifactFuture = _artifactService.getArtifacts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Genshin Import'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Weapons', icon: Icon(Icons.shield_outlined)),
              Tab(text: 'Artifacts', icon: Icon(Icons.auto_awesome_outlined)),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const HomeHeader(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: HomeSearchBar(),
              ),
              Expanded(
                child: TabBarView(
                  children: [_buildWeaponGrid(), _buildArtifactGrid()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeaponGrid() {
    return FutureBuilder<List<Weapon>>(
      future: _weaponFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No weapons found'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return WeaponCard(weapon: snapshot.data![index]);
          },
        );
      },
    );
  }

  Widget _buildArtifactGrid() {
    return FutureBuilder<List<Artifact>>(
      future: _artifactFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No artifacts found'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ArtifactCard(artifact: snapshot.data![index]);
          },
        );
      },
    );
  }
}
