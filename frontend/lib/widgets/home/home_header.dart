import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, right: 16.0, bottom: 8.0),
        child: DisplayCoin(),
      ),
    );
  }
}

class DisplayCoin extends StatelessWidget {
  const DisplayCoin({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserMoney(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(
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
                Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text(
                  snapshot.data!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

//   ),
//   child: const Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Icon(Icons.monetization_on, color: Colors.amber, size: 18),
//       SizedBox(width: 4),
//       Text(
//         '0', // This will be updated by the FutureBuilder in the parent widget
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//     ],
//   ),
// );

Future<String> _getUserMoney() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get('money')?.toString() ?? '0';
}
