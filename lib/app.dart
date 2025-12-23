import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// The root widget of the Sodium recipe app.
class SodiumApp extends StatelessWidget {
  const SodiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sodium',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
