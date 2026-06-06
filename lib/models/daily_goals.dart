import '../core/constants.dart';

/// User-editable daily targets.
class DailyGoals {
  final int stepGoal;
  final int netCalorieGoal; // target net calories (in - out)
  final int activeCalorieGoal; // active kcal burned (steps + exercise) — "move" ring
  final int workoutMinutesGoal; // logged workout minutes — "exercise" ring

  const DailyGoals({
    this.stepGoal = K.defaultStepGoal,
    this.netCalorieGoal = K.defaultNetCalorieGoal,
    this.activeCalorieGoal = K.defaultActiveCalorieGoal,
    this.workoutMinutesGoal = K.defaultWorkoutMinutesGoal,
  });

  DailyGoals copyWith({
    int? stepGoal,
    int? netCalorieGoal,
    int? activeCalorieGoal,
    int? workoutMinutesGoal,
  }) =>
      DailyGoals(
        stepGoal: stepGoal ?? this.stepGoal,
        netCalorieGoal: netCalorieGoal ?? this.netCalorieGoal,
        activeCalorieGoal: activeCalorieGoal ?? this.activeCalorieGoal,
        workoutMinutesGoal: workoutMinutesGoal ?? this.workoutMinutesGoal,
      );

  Map<String, dynamic> toJson() => {
        'stepGoal': stepGoal,
        'netCalorieGoal': netCalorieGoal,
        'activeCalorieGoal': activeCalorieGoal,
        'workoutMinutesGoal': workoutMinutesGoal,
      };

  factory DailyGoals.fromJson(Map<String, dynamic> j) => DailyGoals(
        stepGoal: (j['stepGoal'] as num?)?.toInt() ?? K.defaultStepGoal,
        netCalorieGoal:
            (j['netCalorieGoal'] as num?)?.toInt() ?? K.defaultNetCalorieGoal,
        activeCalorieGoal: (j['activeCalorieGoal'] as num?)?.toInt() ??
            K.defaultActiveCalorieGoal,
        workoutMinutesGoal: (j['workoutMinutesGoal'] as num?)?.toInt() ??
            K.defaultWorkoutMinutesGoal,
      );
}
