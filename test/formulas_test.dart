import 'package:caloriedesi/core/formulas.dart';
import 'package:caloriedesi/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BMR (Mifflin-St Jeor)', () {
    test('male', () {
      final bmr = Formulas.bmr(
          sex: Sex.male, weightKg: 70, heightCm: 175, ageYears: 30);
      expect(bmr, closeTo(1648.75, 0.01));
    });

    test('female is 166 less than male for same stats', () {
      final male = Formulas.bmr(
          sex: Sex.male, weightKg: 70, heightCm: 175, ageYears: 30);
      final female = Formulas.bmr(
          sex: Sex.female, weightKg: 70, heightCm: 175, ageYears: 30);
      expect(male - female, closeTo(166, 0.001));
    });
  });

  test('TDEE applies activity factor', () {
    final tdee = Formulas.tdee(bmr: 1648.75, activity: ActivityLevel.sedentary);
    expect(tdee, closeTo(1978.5, 0.01));
  });

  test('step calories scale with weight', () {
    expect(Formulas.stepCalories(steps: 10000, weightKg: 70),
        closeTo(399.0, 0.001));
    expect(Formulas.stepCalories(steps: 0, weightKg: 70), 0);
  });

  test('MET duration formula', () {
    final kcal = Formulas.exerciseCaloriesByDuration(
        met: 7.5, weightKg: 70, minutes: 30);
    expect(kcal, closeTo(275.625, 0.001));
  });

  test('rep formula scales by weight ratio', () {
    final kcal = Formulas.exerciseCaloriesByReps(
        kcalPerRep: 0.32, reps: 50, weightKg: 70, referenceWeightKg: 70);
    expect(kcal, closeTo(16.0, 0.001));
    final heavier = Formulas.exerciseCaloriesByReps(
        kcalPerRep: 0.32, reps: 50, weightKg: 140, referenceWeightKg: 70);
    expect(heavier, closeTo(32.0, 0.001));
  });

  group('age from birth date', () {
    test('before birthday this year', () {
      final age = Formulas.ageFromBirthDate(
        DateTime(1990, 12, 31),
        now: DateTime(2026, 6, 1),
      );
      expect(age, 35);
    });

    test('after birthday this year', () {
      final age = Formulas.ageFromBirthDate(
        DateTime(1990, 1, 1),
        now: DateTime(2026, 6, 1),
      );
      expect(age, 36);
    });
  });
}
