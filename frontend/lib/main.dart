import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'widgets/main_navigation_bar.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'package:frontend/view_models/auth_viewmodel.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthViewModel.instance.bootstrapSession();

  runApp(const GenshinImportApp());
}

class GenshinImportApp extends StatelessWidget {
  const GenshinImportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genshin Import',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      home: AnimatedBuilder(
        animation: AuthViewModel.instance,
        builder: (context, child) {
          final authViewModel = AuthViewModel.instance;

          if (authViewModel.isBootstrapping) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (authViewModel.isLoggedIn) {
            return const MainNavigationScreen();
          }

          return const AuthScreen();
        },
      ),
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

  @override
  Widget build(BuildContext context) {
    final authViewModel = AuthViewModel.instance;

    final pages = <Widget>[
      const Center(child: ShopScreen()),
      const Center(child: InventoryScreen()),
      const ProfileScreen(),
      if (authViewModel.isAdmin) const AdminDashboardScreen(),
    ];

    final safeIndex = _selectedIndex.clamp(0, pages.length - 1);

    return Scaffold(
      // Menggunakan IndexedStack agar state halaman tidak hilang saat pindah tab
      body: IndexedStack(index: safeIndex, children: pages),
      // Memanggil komponen Navbar terpisah
      bottomNavigationBar: MainNavigationBar(
        currentIndex: safeIndex,
        showAdmin: authViewModel.isAdmin,
        onTap: (index) {
          setState(() {
            _selectedIndex = index.clamp(0, pages.length - 1);
          });
        },
      ),
    );
  }
}
