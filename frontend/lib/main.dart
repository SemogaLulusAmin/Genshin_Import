import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Genshin Import',
      home: const LoginPage(),
    );
  }
}
