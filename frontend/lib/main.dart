import 'package:flutter/material.dart';
import 'package:frontend/screens/create/create_item_screen.dart';
import 'package:frontend/view_models/user_viewmodel.dart';
import 'core/app_theme.dart';
import 'widgets/main_navigation_bar.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'package:frontend/view_models/auth_viewmodel.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/theme/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthViewModel.instance.bootstrapSession();

  runApp(const GenshinImportApp());
}

class GenshinImportApp extends StatelessWidget {
  const GenshinImportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeManager(),
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Genshin Import',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

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
      },
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
    final pages = <Widget>[
      const ShopScreen(),
      if (UserViewModel.instance.isAdmin == false) const InventoryScreen(),
      if (UserViewModel.instance.isAdmin == true) const CreateItemScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      // Use IndexedStack to preserve page state when switching tabs
      body: IndexedStack(index: _selectedIndex, children: pages),
      // Use the separate navbar component
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
