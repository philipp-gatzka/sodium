import 'package:isar/isar.dart';

part 'recipe.g.dart';

@collection
class Recipe {
  Id id = Isar.autoIncrement;

  late String title;

  late List<String> ingredients;

  late List<String> instructions;

  DateTime? createdAt;

  DateTime? updatedAt;
}
