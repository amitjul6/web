import '../core/constants.dart';

/// User-editable daily targets.
class DailyGoals {
  final int stepGoal;
  final int netCalorieGoal; // target net calories (in - out)

  const DailyGoals({
    this.stepGoal = K.defaultStepGoal,
    this.netCalorieGoal = K.defaultNetCalorieGoal,
  });

  DailyGoals copyWith({int? stepGoal, int? netCalorieGoal}) => DailyGoals(
        stepGoal: stepGoal ?? this.stepGoal,
        netCalorieGoal: netCalorieGoal ?? this.netCalorieGoal,
      );

  Map<String, dynamic> toJson() => {
        'stepGoal': stepGoal,
        'netCalorieGoal': netCalorieGoal,
      };

  factory DailyGoals.fromJson(Map<String, dynamic> j) => DailyGoals(
        stepGoal: (j['stepGoal'] as num?)?.toInt() ?? K.defaultStepGoal,
        netCalorieGoal:
            (j['netCalorieGoal'] as num?)?.toInt() ?? K.defaultNetCalorieGoal,
      );
}
