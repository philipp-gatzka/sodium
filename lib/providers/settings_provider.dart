import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing the app's theme mode setting.
///
/// Defaults to system theme. Users can choose between light, dark, or system.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
