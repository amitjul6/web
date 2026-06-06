import 'package:caloriedesi/core/exercise_calc.dart';
import 'package:caloriedesi/data/exercise_catalog.dart';
import 'package:caloriedesi/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('duration-based cycling matches MET formula', () {
    final cycling = kExerciseCatalog.firstWhere((e) => e.id == 'cycling');
    final kcal = computeExerciseCalories(cycling, 30, 70);
    // MET 7.5, 70kg, 30min
    expect(kcal, closeTo(275.625, 0.01));
  });

  test('rep-based push-ups scale with weight', () {
    final pushups = kExerciseCatalog.firstWhere((e) => e.id == 'pushups');
    expect(pushups.inputMode, ExerciseInputMode.reps);
    final kcal = computeExerciseCalories(pushups, 50, 70);
    expect(kcal, closeTo(16.0, 0.01));
  });

  test('distance running converts km to minutes via pace', () {
    final running = kExerciseCatalog.firstWhere((e) => e.id == 'running');
    final kcal = computeExerciseCalories(running, 5, 70); // 5 km
    const minutes = 5 * kRunningMinPerKm;
    final expected = running.met * 3.5 * 70 / 200 * minutes;
    expect(kcal, closeTo(expected, 0.01));
  });
}
