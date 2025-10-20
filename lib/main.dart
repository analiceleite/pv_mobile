import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PalavraDaVidaApp());
}

class PalavraDaVidaApp extends StatelessWidget {
  const PalavraDaVidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Igreja Palavra da Vida',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
