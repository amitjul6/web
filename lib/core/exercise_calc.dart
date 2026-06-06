import '../data/exercise_catalog.dart';
import '../models/enums.dart';
import '../models/exercise_type.dart';
import 'formulas.dart';

/// Calories burned for a catalog exercise given the user's weight and the entered
/// amount (minutes / reps / km depending on the type's input mode).
double computeExerciseCalories(
  ExerciseType type,
  double amount,
  double weightKg,
) {
  switch (type.inputMode) {
    case ExerciseInputMode.duration:
      return Formulas.exerciseCaloriesByDuration(
        met: type.met,
        weightKg: weightKg,
        minutes: amount,
      );
    case ExerciseInputMode.distance:
      // Convert distance → estimated minutes via a typical running pace.
      final minutes = amount * kRunningMinPerKm;
      return Formulas.exerciseCaloriesByDuration(
        met: type.met,
        weightKg: weightKg,
        minutes: minutes,
      );
    case ExerciseInputMode.reps:
      return Formulas.exerciseCaloriesByReps(
        kcalPerRep: type.kcalPerRep,
        reps: amount.round(),
        weightKg: weightKg,
        referenceWeightKg: type.referenceWeightKg,
      );
  }
}

String inputLabelFor(ExerciseInputMode mode) {
  switch (mode) {
    case ExerciseInputMode.duration:
      return 'Minutes';
    case ExerciseInputMode.reps:
      return 'Reps';
    case ExerciseInputMode.distance:
      return 'Distance (km)';
  }
}
