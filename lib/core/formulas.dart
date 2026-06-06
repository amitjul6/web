import 'constants.dart';
import '../models/enums.dart';

/// Pure energy-balance math. Kept dependency-free so it is fully unit-testable.
class Formulas {
  Formulas._();

  /// Mifflin-St Jeor Basal Metabolic Rate (kcal/day).
  static double bmr({
    required Sex sex,
    required double weightKg,
    required double heightCm,
    required int ageYears,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * ageYears;
    return sex == Sex.male ? base + 5 : base - 161;
  }

  /// Total Daily Energy Expenditure = BMR * activity factor.
  static double tdee({
    required double bmr,
    required ActivityLevel activity,
  }) =>
      bmr * activity.factor;

  /// Calories burned from steps, scaled by body weight.
  static double stepCalories({
    required int steps,
    required double weightKg,
  }) =>
      steps * K.kcalPerStepPerKg * weightKg;

  /// MET-based calories for a duration activity:
  /// kcal = MET * 3.5 * weightKg / 200 * minutes  (== MET * kg * hours).
  static double exerciseCaloriesByDuration({
    required double met,
    required double weightKg,
    required double minutes,
  }) =>
      met * 3.5 * weightKg / 200.0 * minutes;

  /// Rep-based fallback (e.g. push-ups). kcalPerRep is weight-scaled by the catalog.
  static double exerciseCaloriesByReps({
    required double kcalPerRep,
    required int reps,
    required double weightKg,
    required double referenceWeightKg,
  }) =>
      kcalPerRep * reps * (weightKg / referenceWeightKg);

  /// Age in whole years from a birth date.
  static int ageFromBirthDate(DateTime birthDate, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    var age = ref.year - birthDate.year;
    final hadBirthday = (ref.month > birthDate.month) ||
        (ref.month == birthDate.month && ref.day >= birthDate.day);
    if (!hadBirthday) age--;
    return age < 0 ? 0 : age;
  }
}
