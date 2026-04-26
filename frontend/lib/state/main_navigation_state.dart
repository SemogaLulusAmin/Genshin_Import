import 'package:flutter/material.dart';
import 'package:frontend/screens/home/gallery_shop_screen.dart';
import 'package:frontend/widgets/main_navigation_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Placeholder untuk 5 halaman wajib sesuai dokumen
  final List<Widget> _pages = [
    const GalleryShopScreen(),
    const Center(child: Text('Inventory Screen')),
    const Center(child: Text('Delivery Package Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar state halaman tidak hilang saat pindah tab
      body: IndexedStack(index: _selectedIndex, children: _pages),
      // Memanggil komponen Navbar terpisah
      bottomNavigationBar: MainNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
