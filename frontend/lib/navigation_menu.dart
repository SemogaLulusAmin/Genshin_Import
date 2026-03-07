import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/app_icons.dart';

class NavigationMenu extends StatefulWidget {
  final Function(int) onItemSelected;

  const NavigationMenu({super.key, required this.onItemSelected});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;

  final List<Map<String, String>> icons = [
    {"inactive": AppIcons.swordOutlined, "active": AppIcons.swordFilled},
    {"inactive": AppIcons.boxOutlined, "active": AppIcons.boxFilled},
    {"inactive": AppIcons.userOutlined, "active": AppIcons.userFilled},
  ];

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Row(
        children: List.generate(icons.length, (index) {
          bool isActive = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                transform: Matrix4.translationValues(0, isActive ? -4 : 0, 0),
                child: SvgPicture.asset(
                  isActive
                      ? icons[index]["active"]!
                      : icons[index]["inactive"]!,
                  width: isActive ? 32 : 28,
                  height: isActive ? 32 : 28,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
