import 'enums.dart';

/// A catalog exercise. Duration-based types use [met]; rep-based types use
/// [kcalPerRep] (calibrated at [referenceWeightKg]).
class ExerciseType {
  final String id;
  final String name;
  final String icon; // emoji for lightweight visuals
  final ExerciseInputMode inputMode;
  final double met; // for duration & distance modes
  final double kcalPerRep; // for reps mode
  final double referenceWeightKg;

  const ExerciseType({
    required this.id,
    required this.name,
    required this.icon,
    required this.inputMode,
    this.met = 0,
    this.kcalPerRep = 0,
    this.referenceWeightKg = 70,
  });
}
