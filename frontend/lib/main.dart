import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'widgets/main_navigation_bar.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/screens/profile/profile_screen.dart';
import 'package:frontend/view_models/auth_viewmodel.dart';
import 'screens/shop/shop_screen.dart';
import 'states/auth_state.dart';
import 'package:provider/provider.dart';
import 'states/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthViewModel.instance.bootstrapSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
      ],
      child: const GenshinImportApp(),
    ),
  );
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
      themeMode: ThemeMode.dark,

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

  final List<Widget> _pages = [
    const Center(child: ShopScreen()),
    // const Center(child: Text('Orders Screen')),
    const Center(child: InventoryScreen()),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthViewModel.instance.currentUser;
    final pages = <Widget>[
      const Center(child: ShopScreen()),
      const Center(child: Text('Inventory Screen')),
      const Center(child: Text('Delivery Package Screen')),
      currentUser != null
          ? ProfileScreen(user: currentUser)
          : const Center(child: Text('User session is not loaded yet')),
    ];

    return Scaffold(
      // Menggunakan IndexedStack agar state halaman tidak hilang saat pindah tab
      body: IndexedStack(index: _selectedIndex, children: pages),
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
