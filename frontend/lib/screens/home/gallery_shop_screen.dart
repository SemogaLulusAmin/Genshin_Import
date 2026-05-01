import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/app_colors.dart';
import '../../models/weapon_model.dart';
import '../../services/weapon_service.dart';

class GalleryShopScreen extends StatefulWidget {
  const GalleryShopScreen({super.key});

  @override
  State<GalleryShopScreen> createState() => _GalleryShopScreenState();
}

class _GalleryShopScreenState extends State<GalleryShopScreen> {
  final WeaponService _weaponService = WeaponService();
  late Future<List<Weapon>> _weaponFuture;

  // Future<void> fetchDataArtifacts() async {}

  @override
  void initState() {
    super.initState();
    _weaponFuture = _weaponService.getWeapons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            SingleChildScrollView(child: Column(children: [SearchBarWdiget()])),
          ],
        ),
      ),
    );
  }
}

class SearchBarWdiget extends StatelessWidget {
  const SearchBarWdiget({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          leading: const Icon(Icons.search),
          hintText: 'Search weapons and artifacts here!',
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return [
          ListTile(title: Text("Suggestion 1")),
          ListTile(title: Text("Suggestion 2")),
        ];
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 16.0, bottom: 8.0),
        child: DisplayCoin(),
      ),
    );
  }
}

class DisplayCoin extends StatelessWidget {
  const DisplayCoin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.monetization_on, color: Colors.amber, size: 18),
          SizedBox(width: 4),
          Text(
            '1.200',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
