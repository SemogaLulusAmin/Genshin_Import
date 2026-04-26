import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class GalleryShopScreen extends StatefulWidget {
  const GalleryShopScreen({super.key});

  @override
  State<GalleryShopScreen> createState() => _GalleryShopScreenState();
}

class _GalleryShopScreenState extends State<GalleryShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            height: 60,
            child: const Center(child: Text('Coin: ')),
          ),
          SingleChildScrollView(child: Text('Welcome to Genshin Import!')),
        ],
      ),
    );
  }
}
