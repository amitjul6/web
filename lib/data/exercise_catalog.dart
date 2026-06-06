import '../models/enums.dart';
import '../models/exercise_type.dart';

/// Built-in exercise catalog. Duration types use MET; rep types use kcal/rep
/// calibrated at a 70 kg reference. Values are typical estimates.
const List<ExerciseType> kExerciseCatalog = [
  // Duration-based (MET)
  ExerciseType(id: 'walking', name: 'Walking', icon: '🚶', inputMode: ExerciseInputMode.duration, met: 3.5),
  ExerciseType(id: 'brisk_walk', name: 'Brisk Walking', icon: '🚶‍♂️', inputMode: ExerciseInputMode.duration, met: 4.3),
  ExerciseType(id: 'cycling', name: 'Cycling (moderate)', icon: '🚴', inputMode: ExerciseInputMode.duration, met: 7.5),
  ExerciseType(id: 'yoga', name: 'Yoga', icon: '🧘', inputMode: ExerciseInputMode.duration, met: 2.5),
  ExerciseType(id: 'swimming', name: 'Swimming', icon: '🏊', inputMode: ExerciseInputMode.duration, met: 8.0),
  ExerciseType(id: 'jump_rope', name: 'Jump Rope', icon: '🪢', inputMode: ExerciseInputMode.duration, met: 11.0),
  ExerciseType(id: 'strength', name: 'Strength Training', icon: '🏋️', inputMode: ExerciseInputMode.duration, met: 5.0),
  ExerciseType(id: 'dancing', name: 'Dancing', icon: '💃', inputMode: ExerciseInputMode.duration, met: 5.5),
  ExerciseType(id: 'cricket', name: 'Cricket', icon: '🏏', inputMode: ExerciseInputMode.duration, met: 5.0),
  ExerciseType(id: 'badminton', name: 'Badminton', icon: '🏸', inputMode: ExerciseInputMode.duration, met: 5.5),
  ExerciseType(id: 'aerobics', name: 'Aerobics', icon: '🤸', inputMode: ExerciseInputMode.duration, met: 7.3),

  // Distance-based (MET applied over an estimated duration via running pace)
  ExerciseType(id: 'running', name: 'Running', icon: '🏃', inputMode: ExerciseInputMode.distance, met: 9.8),

  // Rep-based (kcal per rep @ 70 kg)
  ExerciseType(id: 'pushups', name: 'Push-ups', icon: '💪', inputMode: ExerciseInputMode.reps, kcalPerRep: 0.32),
  ExerciseType(id: 'situps', name: 'Sit-ups', icon: '🔥', inputMode: ExerciseInputMode.reps, kcalPerRep: 0.26),
  ExerciseType(id: 'squats', name: 'Squats', icon: '🦵', inputMode: ExerciseInputMode.reps, kcalPerRep: 0.32),
  ExerciseType(id: 'pullups', name: 'Pull-ups', icon: '🧗', inputMode: ExerciseInputMode.reps, kcalPerRep: 1.0),
  ExerciseType(id: 'burpees', name: 'Burpees', icon: '⚡', inputMode: ExerciseInputMode.reps, kcalPerRep: 0.5),
];

/// Average running pace (minutes per km) used to convert distance → duration
/// for the MET formula.
const double kRunningMinPerKm = 6.5;
