import 'enums.dart';
import 'exercise_entry.dart';
import 'food_log_entry.dart';
import 'step_record.dart';

/// Everything logged for a single calendar day.
class DayLog {
  final String dayKey;
  final List<FoodLogEntry> foods;
  final List<ExerciseEntry> exercises;
  final StepRecord steps;

  DayLog({
    required this.dayKey,
    List<FoodLogEntry>? foods,
    List<ExerciseEntry>? exercises,
    StepRecord? steps,
  })  : foods = foods ?? const [],
        exercises = exercises ?? const [],
        steps = steps ?? StepRecord(dayKey: dayKey);

  double get caloriesIn => foods.fold(0.0, (s, e) => s + e.totalCalories);
  double get proteinG => foods.fold(0.0, (s, e) => s + e.totalProtein);
  double get carbsG => foods.fold(0.0, (s, e) => s + e.totalCarbs);
  double get fatG => foods.fold(0.0, (s, e) => s + e.totalFat);
  double get exerciseCalories =>
      exercises.fold(0.0, (s, e) => s + e.caloriesBurned);

  /// Total workout minutes for the day. Duration entries contribute directly;
  /// distance entries are converted at a typical running pace (~6.5 min/km);
  /// rep-based entries don't carry a duration so they're excluded here.
  double get workoutMinutes => exercises.fold(0.0, (s, e) {
        switch (e.inputMode) {
          case ExerciseInputMode.duration:
            return s + e.amount;
          case ExerciseInputMode.distance:
            return s + e.amount * 6.5;
          case ExerciseInputMode.reps:
            return s;
        }
      });

  DayLog copyWith({
    List<FoodLogEntry>? foods,
    List<ExerciseEntry>? exercises,
    StepRecord? steps,
  }) =>
      DayLog(
        dayKey: dayKey,
        foods: foods ?? this.foods,
        exercises: exercises ?? this.exercises,
        steps: steps ?? this.steps,
      );

  Map<String, dynamic> toJson() => {
        'dayKey': dayKey,
        'foods': foods.map((e) => e.toJson()).toList(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'steps': steps.toJson(),
      };

  factory DayLog.fromJson(Map<String, dynamic> j) => DayLog(
        dayKey: j['dayKey'] as String,
        foods: ((j['foods'] as List?) ?? const [])
            .map((e) => FoodLogEntry.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        exercises: ((j['exercises'] as List?) ?? const [])
            .map((e) => ExerciseEntry.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        steps: j['steps'] != null
            ? StepRecord.fromJson(Map<String, dynamic>.from(j['steps']))
            : StepRecord(dayKey: j['dayKey'] as String),
      );
}
