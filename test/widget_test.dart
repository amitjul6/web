import 'package:caloriedesi/data/food_library.dart';
import 'package:flutter_test/flutter_test.dart';

// Lightweight sanity checks for the bundled library data. Full widget tests that
// boot the app require Hive initialization and Riverpod overrides.
void main() {
  test('food library is populated and well-formed', () {
    expect(kFoodLibrary.length, greaterThan(50));
    for (final f in kFoodLibrary) {
      expect(f.id, isNotEmpty);
      expect(f.name, isNotEmpty);
      expect(f.calories, greaterThan(0));
    }
  });

  test('food ids are unique', () {
    final ids = kFoodLibrary.map((f) => f.id).toSet();
    expect(ids.length, kFoodLibrary.length);
  });

  test('category filter and search work', () {
    expect(foodCategories().first, 'All');
    final dosas = searchFoods('dosa');
    expect(dosas, isNotEmpty);
    expect(dosas.every((f) => f.name.toLowerCase().contains('dosa')), isTrue);
  });
}
