import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'widgets/main_navigation_bar.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const GenshinImportApp());
}

class GenshinImportApp extends StatelessWidget {
  const GenshinImportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genshin Import',
      debugShowCheckedModeBanner: false,

      // Menggunakan tema yang sudah dibuat
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      home: const LoginScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Placeholder untuk 5 halaman wajib sesuai dokumen
  final List<Widget> _pages = [
    const Center(child: Text('Gallery & Shop Screen')),
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
