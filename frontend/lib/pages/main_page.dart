import 'package:flutter/material.dart';
import '../navigation_menu.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const CartPage(),
    const ProfilePage(),
  ];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: NavigationMenu(onItemSelected: changePage),
    );
  }
}
