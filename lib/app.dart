import 'package:flutter/material.dart';

/// The root widget of the Sodium recipe app.
class SodiumApp extends StatelessWidget {
  const SodiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sodium',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Sodium Recipe App'),
        ),
      ),
    );
  }
}
