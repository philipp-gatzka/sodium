import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/recipe.dart';

/// Provider that initializes and provides the Isar database instance.
///
/// This is the single source of truth for database access. The database
/// is opened once and shared across all dependent providers.
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
    [RecipeSchema],
    directory: dir.path,
  );

  ref.onDispose(() async {
    await isar.close();
  });

  return isar;
});
