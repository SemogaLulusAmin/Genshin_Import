import 'package:flutter/material.dart';
import 'package:frontend/state/main_navigation_state.dart';
import 'core/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'states/auth_state.dart';

void main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('jwt_token');
  isLoggedIn.value = (token != null);

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

      home: ValueListenableBuilder<bool>(
        valueListenable: isLoggedIn,
        builder: (context, loggedIn, child) {
          if (loggedIn) {
            return const MainNavigationScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}


