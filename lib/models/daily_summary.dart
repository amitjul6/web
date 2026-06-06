import '../core/formulas.dart';
import 'day_log.dart';
import 'profile.dart';

/// Computed (never persisted) energy snapshot for one day.
class DailySummary {
  final double caloriesIn;
  final double bmr;
  final double stepCalories;
  final double exerciseCalories;
  final int steps;
  final double workoutMinutes;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const DailySummary({
    required this.caloriesIn,
    required this.bmr,
    required this.stepCalories,
    required this.exerciseCalories,
    required this.steps,
    required this.workoutMinutes,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  /// Active energy burned (excludes the BMR baseline) — the "move" ring metric.
  double get activeCalories => stepCalories + exerciseCalories;

  /// Calories out uses BMR as the baseline (NOT TDEE) plus measured activity,
  /// so the activity factor is never double-counted.
  double get caloriesOut => bmr + stepCalories + exerciseCalories;
  double get net => caloriesIn - caloriesOut;

  static DailySummary from(DayLog day, Profile? profile) {
    final weight = profile?.weightKg ?? 70;
    final bmr = profile?.bmr ?? 0;
    final steps = day.steps.effectiveSteps;
    return DailySummary(
      caloriesIn: day.caloriesIn,
      bmr: bmr,
      stepCalories: Formulas.stepCalories(steps: steps, weightKg: weight),
      exerciseCalories: day.exerciseCalories,
      steps: steps,
      workoutMinutes: day.workoutMinutes,
      proteinG: day.proteinG,
      carbsG: day.carbsG,
      fatG: day.fatG,
    );
  }

  static const empty = DailySummary(
    caloriesIn: 0,
    bmr: 0,
    stepCalories: 0,
    exerciseCalories: 0,
    steps: 0,
    workoutMinutes: 0,
    proteinG: 0,
    carbsG: 0,
    fatG: 0,
  );
}
