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
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '1.200',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: List.generate(
                  10,
                  (index) => Container(
                    height: 100,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: const Center(child: Text('Item')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
